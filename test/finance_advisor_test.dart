import 'package:cow/models/monthly_report.dart';
import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/finance_advisor_service.dart';
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

MonthlyReport report({
  double litres = 0,
  double milkCash = 0,
  double otherIncome = 0,
  Map<String, double> spend = const {},
  int? throughDay,
}) => MonthlyReport(
  month: DateTime(2026, 11),
  throughDay: throughDay,
  litres: litres,
  milkCash: milkCash,
  otherIncome: otherIncome,
  totalExpenses: spend.values.fold(0.0, (a, b) => a + b),
  expensesByCategory: spend,
);

const _replyJson = '''
{
  "headline": "A solid month so far.",
  "insights": ["Feed is your biggest cost"],
  "suggestions": ["Compare feed prices", "Check for waste"],
  "answer": "Profit is lower because feed cost more."
}
''';

void main() {
  setUp(FinanceAdvisorService.clearCache);

  group('findFinanceAlerts', () {
    test('warns when expenses beat income', () {
      final alerts = findFinanceAlerts(
        report(milkCash: 1000, spend: {'feed': 1500}),
        null,
      );
      expect(alerts, ['Expenses are higher than income by 500.']);
    });

    test('warns when cost per litre jumps', () {
      final alerts = findFinanceAlerts(
        report(litres: 100, milkCash: 6000, spend: {'feed': 4000}),
        report(litres: 100, milkCash: 6000, spend: {'feed': 3000}),
      );
      expect(
        alerts,
        contains('Cost per litre rose from 30.00 to 40.00 (+33%).'),
      );
    });

    test('warns about a category that rose sharply', () {
      final alerts = findFinanceAlerts(
        report(milkCash: 5000, spend: {'feed': 1500, 'vet': 500}),
        report(milkCash: 5000, spend: {'feed': 1000, 'vet': 500}),
      );
      expect(alerts, ['Feed spending rose 50% (from 1,000 to 1,500).']);
    });

    test('does not warn about a small change', () {
      final alerts = findFinanceAlerts(
        report(milkCash: 5000, spend: {'feed': 1100}),
        report(milkCash: 5000, spend: {'feed': 1000}),
      );
      expect(alerts, isEmpty);
    });

    test('warns about a big new category', () {
      final alerts = findFinanceAlerts(
        report(milkCash: 5000, spend: {'feed': 1000, 'labour': 600}),
        report(milkCash: 5000, spend: {'feed': 1000}),
      );
      expect(alerts.single, startsWith('Labour is new this month: 600'));
    });

    test('warns when income and milk both fall', () {
      final alerts = findFinanceAlerts(
        report(litres: 150, milkCash: 7000),
        report(litres: 200, milkCash: 10000),
      );
      expect(alerts, contains('Income is down 30% compared with last month.'));
      expect(alerts, contains('Milk production is down 25% (200 L to 150 L).'));
    });

    test('a month in progress is compared with the same days', () {
      final alerts = findFinanceAlerts(
        report(litres: 150, milkCash: 7000, throughDay: 10),
        report(litres: 200, milkCash: 10000, throughDay: 10),
      );
      expect(
        alerts,
        contains('Income is down 30% compared with the same days last month.'),
      );
    });

    test('a healthy month has no alerts', () {
      final healthy = report(
        litres: 100,
        milkCash: 6000,
        spend: {'feed': 2000},
      );
      expect(findFinanceAlerts(healthy, healthy), isEmpty);
    });
  });

  group('buildFinancePrompt', () {
    test('includes the figures, alerts and question', () {
      final prompt = buildFinancePrompt(
        current: report(litres: 100, milkCash: 6000, spend: {'feed': 2000}),
        alerts: ['Example alert.'],
        question: 'Why is profit low?',
      );

      expect(prompt, contains('November 2026'));
      expect(prompt, contains('Milk produced: 100.0 L'));
      expect(prompt, contains('Total expenses: 2,000 (Feed: 2,000)'));
      expect(prompt, contains('Profit: 4,000'));
      expect(prompt, contains('Cost per litre: 20.00'));
      expect(prompt, contains('No earlier month to compare with.'));
      expect(prompt, contains('- Example alert.'));
      expect(prompt, contains("Farmer's question: Why is profit low?"));
    });

    test('says so when there is nothing unusual and no question', () {
      final prompt = buildFinancePrompt(
        current: report(milkCash: 100),
        alerts: const [],
      );
      expect(prompt, contains('- nothing unusual'));
      expect(prompt, isNot(contains("Farmer's question")));
    });

    test('labels a month in progress and its comparison', () {
      final prompt = buildFinancePrompt(
        current: report(milkCash: 100, throughDay: 8),
        previous: report(milkCash: 200, throughDay: 8),
        alerts: const [],
      );
      expect(prompt, contains('November 2026 (so far, days 1 to 8)'));
      expect(prompt, contains('Last month (the same days)'));
    });
  });

  group('parseFinanceAdvice', () {
    test('reads a normal reply', () {
      final a = parseFinanceAdvice(_replyJson)!;
      expect(a.headline, 'A solid month so far.');
      expect(a.insights, ['Feed is your biggest cost']);
      expect(a.suggestions.length, 2);
      expect(a.answer, 'Profit is lower because feed cost more.');
    });

    test('reads a reply wrapped in a code fence', () {
      expect(parseFinanceAdvice('```json\n$_replyJson\n```'), isNotNull);
    });

    test('garbage or an empty object gives null', () {
      expect(parseFinanceAdvice('not json'), isNull);
      expect(parseFinanceAdvice('{}'), isNull);
      expect(parseFinanceAdvice('[1]'), isNull);
    });
  });

  group('FinanceAdvisorService.advise', () {
    final current = report(litres: 100, milkCash: 6000, spend: {'feed': 2000});

    test('asks once for the same numbers and question', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = FinanceAdvisorService(fake);

      final first = await service.advise(current: current);
      final second = await service.advise(current: current);

      expect(first.isOk, isTrue);
      expect(second.isOk, isTrue);
      expect(fake.calls, 1);
    });

    test('a different question asks again', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = FinanceAdvisorService(fake);

      await service.advise(current: current);
      await service.advise(current: current, question: 'Why is profit low?');

      expect(fake.calls, 2);
      expect(fake.lastPrompt, contains("Farmer's question"));
    });

    test('forceRefresh asks again', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final service = FinanceAdvisorService(fake);

      await service.advise(current: current);
      await service.advise(current: current, forceRefresh: true);

      expect(fake.calls, 2);
    });

    test('failures are passed on and not remembered', () async {
      final fake = CountingGenerator(const AiResult.fail(AiFailure.busy));
      final service = FinanceAdvisorService(fake);

      final first = await service.advise(current: current);
      await service.advise(current: current);

      expect(first.failure, AiFailure.busy);
      expect(fake.calls, 2);
    });

    test('an unreadable reply is a failure', () async {
      final fake = CountingGenerator(const AiResult.ok('nonsense'));
      final result = await FinanceAdvisorService(fake).advise(current: current);

      expect(result.isOk, isFalse);
    });

    test('an empty month never reaches the AI', () async {
      final fake = CountingGenerator(const AiResult.ok(_replyJson));
      final result = await FinanceAdvisorService(
        fake,
      ).advise(current: report());

      expect(result.isOk, isFalse);
      expect(fake.calls, 0);
    });
  });
}
