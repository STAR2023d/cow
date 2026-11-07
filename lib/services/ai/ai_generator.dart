import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

/// Why an AI request did not produce text.
enum AiFailure {
  /// No GEMINI_API_KEY was supplied at build time.
  noKey,

  /// No internet, DNS failure, or the request timed out.
  network,

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

/// Gemini through the google_generative_ai package.
class GeminiGenerator implements AiGenerator {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  final String model;
  final Duration timeout;

  const GeminiGenerator({
    this.model = 'gemini-3.7-flash',
    this.timeout = const Duration(seconds: 45),
  });

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    if (_apiKey.isEmpty) return const AiResult.fail(AiFailure.noKey);

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
      final looksOffline =
          message.contains('SocketException') ||
          message.contains('ClientException') ||
          message.contains('Failed host lookup');
      return AiResult.fail(
        looksOffline ? AiFailure.network : AiFailure.unknown,
        message,
      );
    }
  }
}
