import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/providers/http_ai.dart';
import 'package:http/http.dart' as http;

/// Gemini over plain HTTP (the `generateContent` REST endpoint).
class GeminiHttpGenerator implements AiGenerator {
  final String apiKey;
  final String model;
  final Duration timeout;

  /// Injected in tests; a fresh client per request otherwise.
  final http.Client? httpClient;

  GeminiHttpGenerator({
    required this.apiKey,
    required this.model,
    this.timeout = const Duration(seconds: 90),
    this.httpClient,
  });

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    if (apiKey.isEmpty) return const AiResult.fail(AiFailure.noKey);

    final client = httpClient ?? http.Client();
    try {
      final reply = await postJson(
        client,
        Uri.https(
          'generativelanguage.googleapis.com',
          '/v1beta/models/$model:generateContent',
        ),
        headers: {'x-goog-api-key': apiKey},
        body: {
          if (system != null)
            'systemInstruction': {
              'parts': [
                {'text': system},
              ],
            },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.3,
            if (json) 'responseMimeType': 'application/json',
          },
        },
        timeout: timeout,
      );
      if (!reply.isOk) return AiResult.fail(reply.failure, reply.detail);
      return _parse(reply.value!);
    } finally {
      if (httpClient == null) client.close();
    }
  }

  AiResult<String> _parse(Map<String, dynamic> body) {
    final blockReason = (body['promptFeedback'] as Map?)?['blockReason'];
    if (blockReason != null) {
      return AiResult.fail(AiFailure.blocked, 'Prompt blocked: $blockReason');
    }
    final candidates = body['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      return const AiResult.fail(AiFailure.blocked, 'No candidates');
    }
    final first = candidates.first as Map;
    final parts = (first['content'] as Map?)?['parts'];
    final text = parts is List
        ? parts
              .whereType<Map>()
              .map((p) => p['text'])
              .whereType<String>()
              .join()
        : null;
    return textResult(text, 'Empty response (${first['finishReason']})');
  }
}
