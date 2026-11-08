import 'package:cow/services/ai/ai_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('classifyAiError', () {
    test('overload and limit errors are "busy"', () {
      expect(
        classifyAiError(
          'Server Error [503]: The model is overloaded. Please try again later.',
        ),
        AiFailure.busy,
      );
      expect(
        classifyAiError('{"error":{"code":503,"status":"UNAVAILABLE"}}'),
        AiFailure.busy,
      );
      expect(
        classifyAiError('Quota exceeded ... RESOURCE_EXHAUSTED'),
        AiFailure.busy,
      );
      expect(classifyAiError('429 Too Many Requests'), AiFailure.busy);
    });

    test('connection errors are "network"', () {
      expect(
        classifyAiError(
          'SocketException: Failed host lookup: generativelanguage.googleapis.com',
        ),
        AiFailure.network,
      );
      expect(
        classifyAiError('ClientException: Connection closed'),
        AiFailure.network,
      );
    });

    test('anything else is "unknown"', () {
      expect(classifyAiError('Something odd happened'), AiFailure.unknown);
    });
  });

  group('retryWhenBusy', () {
    const noWait = [Duration.zero, Duration.zero];

    test('keeps trying while busy, then returns the success', () async {
      var calls = 0;
      final result = await retryWhenBusy<String>(() async {
        calls++;
        return calls < 3
            ? const AiResult.fail(AiFailure.busy)
            : const AiResult.ok('done');
      }, delays: noWait);

      expect(result.value, 'done');
      expect(calls, 3);
    });

    test('gives up after the last delay and reports busy', () async {
      var calls = 0;
      final result = await retryWhenBusy<String>(() async {
        calls++;
        return const AiResult.fail(AiFailure.busy);
      }, delays: noWait);

      expect(result.failure, AiFailure.busy);
      expect(calls, 3); // the first try plus two retries
    });

    test('does not retry other failures', () async {
      var calls = 0;
      final result = await retryWhenBusy<String>(() async {
        calls++;
        return const AiResult.fail(AiFailure.network);
      }, delays: noWait);

      expect(result.failure, AiFailure.network);
      expect(calls, 1);
    });

    test('does not retry a success', () async {
      var calls = 0;
      final result = await retryWhenBusy<String>(() async {
        calls++;
        return const AiResult.ok('fine');
      }, delays: noWait);

      expect(result.isOk, isTrue);
      expect(calls, 1);
    });
  });
}
