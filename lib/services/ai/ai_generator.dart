import 'dart:async';

/// Why an AI request did not produce text.
enum AiFailure {
  /// No API key (or model / base URL) was supplied at build time for the
  /// chosen provider.
  noKey,

  /// No internet, DNS failure, or the request timed out.
  network,

  /// The provider's servers are overloaded (503/529) or a usage limit was
  /// reached (429). Trying again in a little while usually works.
  busy,

  /// The model returned nothing (for example, blocked by safety filters).
  blocked,

  /// Anything else; see [AiResult.detail].
  unknown,
}

/// Either a value or a reason there is none. Lets screens show a helpful
/// message instead of silently failing.
class AiResult<T> {
  final T? value;
  final AiFailure? failure;

  /// Raw error text, for debugging only. Never show this to the farmer.
  final String? detail;

  const AiResult.ok(this.value) : failure = null, detail = null;
  const AiResult.fail(this.failure, [this.detail]) : value = null;

  bool get isOk => failure == null;
}

/// The one thing the app needs from an AI provider: send a prompt, get text.
/// Providers live in `providers/`; `ai_provider_factory.dart` picks one
/// from the build settings. The vet, finance and insights services only
/// see this interface.
abstract class AiGenerator {
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  });
}

/// Runs [attempt]. While it reports [AiFailure.busy], waits for each of
/// [delays] in turn and tries again. Any other outcome is returned at once.
Future<AiResult<T>> retryWhenBusy<T>(
  Future<AiResult<T>> Function() attempt, {
  List<Duration> delays = const [Duration(seconds: 2), Duration(seconds: 5)],
}) async {
  var result = await attempt();
  for (final delay in delays) {
    if (result.failure != AiFailure.busy) break;
    await Future<void>.delayed(delay);
    result = await attempt();
  }
  return result;
}

/// Runs [primary]. If it ends up [AiFailure.busy] and a [fallback] is
/// given, runs that instead. Any other outcome is returned as it is.
Future<AiResult<T>> fallbackWhenBusy<T>(
  Future<AiResult<T>> Function() primary,
  Future<AiResult<T>> Function()? fallback,
) async {
  final result = await primary();
  if (result.failure == AiFailure.busy && fallback != null) {
    return fallback();
  }
  return result;
}
