import 'package:cow/services/ai/ai_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fallbackWhenBusy', () {
    test('a good first answer never touches the fallback', () async {
      var fallbackCalls = 0;
      final result = await fallbackWhenBusy<String>(
        () async => const AiResult.ok('first'),
        () async {
          fallbackCalls++;
          return const AiResult.ok('second');
        },
      );

      expect(result.value, 'first');
      expect(fallbackCalls, 0);
    });

    test('a busy first model hands over to the fallback', () async {
      final result = await fallbackWhenBusy<String>(
        () async => const AiResult.fail(AiFailure.busy),
        () async => const AiResult.ok('second'),
      );

      expect(result.value, 'second');
    });

    test('busy with no fallback stays busy', () async {
      final result = await fallbackWhenBusy<String>(
        () async => const AiResult.fail(AiFailure.busy),
        null,
      );

      expect(result.failure, AiFailure.busy);
    });

    test('other failures do not use the fallback', () async {
      var fallbackCalls = 0;
      final result = await fallbackWhenBusy<String>(
        () async => const AiResult.fail(AiFailure.network),
        () async {
          fallbackCalls++;
          return const AiResult.ok('second');
        },
      );

      expect(result.failure, AiFailure.network);
      expect(fallbackCalls, 0);
    });
  });
}
