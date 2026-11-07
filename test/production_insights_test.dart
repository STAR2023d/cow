import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/production_insights_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// A pretend AI that counts how often it is asked.
class CountingGenerator implements AiGenerator {
  final AiResult<String> result;
  int calls = 0;
  String? lastPrompt;

  CountingGenerator(this.result);

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    calls++;
    lastPrompt = prompt;
    return result;
  }
}

const _replyJson = '''
{
  "headline": "A steady day with 20 litres.",
  "topCows": ["Daisy: 12.0 L"],
  "sessionNotes": ["Morning was the strongest session"],
  "tips": ["Keep water clean", "Check Bella's feed"]
}
''';

const _snapshot = ProductionSnapshot(
  logs: [
    MilkLog(cowName: 'Daisy', session: 'Morning', litres: 12),
    MilkLog(cowName: 'Bella', session: 'Evening', litres: 8),
  ],
);

void main() {
  setUp(ProductionInsightsService.clearCache);

  group('ProductionSnapshot', () {
    test('totals add up overall and per session', () {
      expect(_snapshot.total, 20);
      expect(_snapshot.bySession, {'Morning': 12.0, 'Evening': 8.0});
    });

    test('signature ignores the order of entries', () {
      const reversed = ProductionSnapshot(
        logs: [
          MilkLog(cowName: 'Bella', session: 'Evening', litres: 8),
          MilkLog(cowName: 'Daisy', session: 'Morning', litres: 12),
        ],
      );
      expect(reversed.signature, _snapshot.signature);
    });

    test('signature changes when the milk changes', () {
      const more = ProductionSnapshot(
        logs: [
          MilkLog(cowName: 'Daisy', session: 'Morning', litres: 12),
          MilkLog(cowName: 'Bella', session: 'Evening', litres: 9),
        ],
      );
      expect(more.signature, isNot(_snapshot.signature));
    });
  });

  test('the prompt lists every entry and the totals', () {
    final prompt = buildProductionPrompt(_snapshot);
    expect(prompt, contains('- Daisy: 12.0 L, Morning'));
    expect(prompt, contains('- Bella: 8.0 L, Evening'));
    expect(prompt, contains('20.0 L in total'));
    expect(prompt, contains('Morning: 12.0 L, Evening: 8.0 L'));
  });

  group('parseProductionInsights', () {
    test('reads a normal reply', () {
      final i = parseProductionInsights(_replyJson)!;
      expect(i.headline, 'A steady day with 20 litres.');
      expect(i.topCows, ['Daisy: 12.0 L']);
      expect(i.tips.length, 2);
    });

    test('reads a reply wrapped in a code fence', () {
      expect(parseProductionInsights('```json\n$_replyJson\n```'), isNotNull);
    });

    test('garbage or an empty object gives null', () {
      expect(parseProductionInsights('not json'), isNull);
      expect(parseProductionInsights('{}'), isNull);
      expect(parseProductionInsights('[1]'), isNull);
    });
  });

  group('ProductionInsightsService.analyse', () {
    test('asks the AI once for the same data, then uses the cache', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = ProductionInsightsService(fake);

      final first = await service.analyse(_snapshot);
      final second = await service.analyse(_snapshot);

      expect(first.isOk, isTrue);
      expect(second.isOk, isTrue);
      expect(fake.calls, 1);
      expect(ProductionInsightsService.cached(_snapshot), isNotNull);
    });

    test('forceRefresh asks again', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = ProductionInsightsService(fake);

      await service.analyse(_snapshot);
      await service.analyse(_snapshot, forceRefresh: true);

      expect(fake.calls, 2);
    });

    test('different milk data asks again', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = ProductionInsightsService(fake);
      const other = ProductionSnapshot(
        logs: [MilkLog(cowName: 'Daisy', session: 'Morning', litres: 5)],
      );

      await service.analyse(_snapshot);
      await service.analyse(other);

      expect(fake.calls, 2);
    });

    test('failures are passed on and not cached', () async {
      final fake = CountingGenerator(const AiResult.fail(AiFailure.network));
      final service = ProductionInsightsService(fake);

      final result = await service.analyse(_snapshot);

      expect(result.isOk, isFalse);
      expect(result.failure, AiFailure.network);
      expect(ProductionInsightsService.cached(_snapshot), isNull);
    });

    test('an unreadable reply is a failure and not cached', () async {
      final fake = CountingGenerator(const AiResult.ok('nonsense'));
      final service = ProductionInsightsService(fake);

      final result = await service.analyse(_snapshot);

      expect(result.isOk, isFalse);
      expect(ProductionInsightsService.cached(_snapshot), isNull);
    });

    test('no milk logged means no AI call', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = ProductionInsightsService(fake);

      final result = await service.analyse(
        const ProductionSnapshot(logs: []),
      );

      expect(result.isOk, isFalse);
      expect(fake.calls, 0);
    });
  });
}