import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/providers/http_ai.dart';
import 'package:http/http.dart' as http;

/// Claude over plain HTTP (the Messages API). Dart has no official
/// Anthropic SDK, so this posts to `/v1/messages` directly.
///
/// Notes on the request:
/// - No `temperature`: API version 2026-10-21 rejects sampling parameters.
/// - No assistant prefill (current models reject it); JSON is asked for in
///   the system prompt instead, and callers already parse leniently.
/// - Server-side refusal fallback is on (`fallbacks: "default"`), so a
///   refused request is retried on another Claude model by the API itself.
class AnthropicGenerator implements AiGenerator {
  static const apiVersion = '2026-10-21';
  static const fallbackBeta = 'server-side-fallback-2026-07-01';

  final String apiKey;
  final String model;
  final int maxTokens;
  final Duration timeout;

  /// Injected in tests; a fresh client per request otherwise.
  final http.Client? httpClient;

  AnthropicGenerator({
    required this.apiKey,
    required this.model,
    this.maxTokens = 16000,
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

    final systemText = [?system, if (json) jsonOnlyInstruction].join('\n\n');

    final client = httpClient ?? http.Client();
    try {
      final reply = await postJson(
        client,
        Uri.https('api.anthropic.com', '/v1/messages'),
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': apiVersion,
          'anthropic-beta': fallbackBeta,
        },
        body: {
          'model': model,
          'max_tokens': maxTokens,
          if (systemText.isNotEmpty) 'system': systemText,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'fallbacks': 'default',
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
    final stop = body['stop_reason'];
    if (stop == 'refusal') {
      final category = (body['stop_details'] as Map?)?['category'];
      return AiResult.fail(AiFailure.blocked, 'Refused ($category)');
    }
    // Content may hold thinking blocks too; only text blocks are the reply.
    final content = body['content'];
    final text = content is List
        ? content
              .whereType<Map>()
              .where((b) => b['type'] == 'text')
              .map((b) => b['text'])
              .whereType<String>()
              .join()
        : null;
    return textResult(text, 'Empty response ($stop)');
  }
}
