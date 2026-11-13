import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/providers/http_ai.dart';
import 'package:http/http.dart' as http;

/// OpenAI, or any service with an OpenAI-compatible Chat Completions
/// endpoint (set [baseUrl], for example a local or hosted gateway).
class OpenAiGenerator implements AiGenerator {
  static final defaultBaseUrl = Uri.parse('https://api.openai.com/v1');

  final String apiKey;
  final String model;

  /// Up to and including the version segment, e.g. `https://host/v1`.
  final Uri baseUrl;

  /// Some compatible services reject `response_format`; turn it off there
  /// and JSON is asked for in the system prompt only.
  final bool supportsJsonMode;
  final Duration timeout;

  /// Injected in tests; a fresh client per request otherwise.
  final http.Client? httpClient;

  OpenAiGenerator({
    required this.apiKey,
    required this.model,
    Uri? baseUrl,
    this.supportsJsonMode = true,
    this.timeout = const Duration(seconds: 60),
    this.httpClient,
  }) : baseUrl = baseUrl ?? defaultBaseUrl;

  Uri get _endpoint {
    final path = baseUrl.path.endsWith('/')
        ? baseUrl.path.substring(0, baseUrl.path.length - 1)
        : baseUrl.path;
    return baseUrl.replace(path: '$path/chat/completions');
  }

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    if (apiKey.isEmpty || model.isEmpty) {
      return const AiResult.fail(AiFailure.noKey);
    }

    final systemText = [?system, if (json) jsonOnlyInstruction].join('\n\n');

    final client = httpClient ?? http.Client();
    try {
      final reply = await postJson(
        client,
        _endpoint,
        headers: {'authorization': 'Bearer $apiKey'},
        body: {
          'model': model,
          'messages': [
            if (systemText.isNotEmpty)
              {'role': 'system', 'content': systemText},
            {'role': 'user', 'content': prompt},
          ],
          if (json && supportsJsonMode)
            'response_format': {'type': 'json_object'},
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
    final choices = body['choices'];
    if (choices is! List || choices.isEmpty) {
      return const AiResult.fail(AiFailure.blocked, 'No choices');
    }
    final first = choices.first as Map;
    if (first['finish_reason'] == 'content_filter') {
      return const AiResult.fail(AiFailure.blocked, 'Content filter');
    }
    final message = first['message'] as Map?;
    if (message?['refusal'] is String) {
      return AiResult.fail(AiFailure.blocked, 'Refused');
    }
    final content = message?['content'];
    return textResult(
      content is String ? content : null,
      'Empty response (${first['finish_reason']})',
    );
  }
}
