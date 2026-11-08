import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

/// Why an AI request did not produce text.
enum AiFailure {
  /// No GEMINI_API_KEY was supplied at build time.
  noKey,

  /// No internet, DNS failure, or the request timed out.
  network,

  /// Google's servers are overloaded (503) or a usage limit was reached
  /// (429). Trying again in a little while usually works.
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
/// Swapping providers later (for example to firebase_ai) means writing one
/// new class that implements this, with no changes to the vet or finance
/// services that use it.
abstract class AiGenerator {
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  });
}

/// Sorts a raw error message into an [AiFailure].
AiFailure classifyAiError(String message) {
  final m = message.toLowerCase();

  if (m.contains('socketexception') ||
      m.contains('clientexception') ||
      m.contains('failed host lookup')) {
    return AiFailure.network;
  }

  if (m.contains('503') ||
      m.contains('overloaded') ||
      m.contains('unavailable') ||
      m.contains('high demand') ||
      m.contains('429') ||
      m.contains('quota') ||
      m.contains('resource_exhausted') ||
      m.contains('rate limit')) {
    return AiFailure.busy;
  }

  return AiFailure.unknown;
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

/// Gemini through the google_generative_ai package.
class GeminiGenerator implements AiGenerator {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Override without editing code:
  /// flutter run --dart-define=GEMINI_MODEL=some-model-name
  static const String _defaultModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-3.8-flash',
  );

  final String model;
  final Duration timeout;

  const GeminiGenerator({
    this.model = _defaultModel,
    this.timeout = const Duration(seconds: 45),
  });

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    if (_apiKey.isEmpty) return const AiResult.fail(AiFailure.noKey);

    return retryWhenBusy(
      () => _attempt(prompt: prompt, system: system, json: json),
    );
  }

  Future<AiResult<String>> _attempt({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    try {
      final client = GenerativeModel(
        model: model,
        apiKey: _apiKey,
        systemInstruction: system == null ? null : Content.system(system),
        generationConfig: GenerationConfig(
          temperature: 0.3,
          responseMimeType: json ? 'application/json' : null,
        ),
      );

      final response = await client
          .generateContent([Content.text(prompt)])
          .timeout(timeout);

      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        return const AiResult.fail(AiFailure.blocked, 'Empty response');
      }
      return AiResult.ok(text);
    } on TimeoutException {
      return const AiResult.fail(AiFailure.network, 'Timed out');
    } catch (e) {
      final message = e.toString();
      return AiResult.fail(classifyAiError(message), message);
    }
  }
}