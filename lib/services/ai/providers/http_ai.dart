import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cow/services/ai/ai_generator.dart';
import 'package:http/http.dart' as http;

/// Status codes that mean "busy, try again soon": rate limited (429),
/// server errors (500/502/503/504) and Anthropic's "overloaded" (529).
const _busyStatuses = {429, 500, 502, 503, 504, 529};

/// Posts [body] as JSON to [url] and returns the decoded JSON reply, or an
/// [AiFailure]. Shared by every HTTP provider so they sort errors the same
/// way. [detail] strings never contain the API key.
Future<AiResult<Map<String, dynamic>>> postJson(
  http.Client client,
  Uri url, {
  required Map<String, String> headers,
  required Map<String, dynamic> body,
  required Duration timeout,
}) async {
  final http.Response response;
  try {
    response = await client
        .post(
          url,
          headers: {'content-type': 'application/json', ...headers},
          body: jsonEncode(body),
        )
        .timeout(timeout);
  } on TimeoutException {
    return const AiResult.fail(AiFailure.network, 'Timed out');
  } on SocketException catch (e) {
    return AiResult.fail(AiFailure.network, e.message);
  } on http.ClientException catch (e) {
    return AiResult.fail(AiFailure.network, e.message);
  }

  final status = response.statusCode;
  if (status < 200 || status >= 300) {
    final failure = _busyStatuses.contains(status)
        ? AiFailure.busy
        : AiFailure.unknown;
    return AiResult.fail(failure, 'HTTP $status: ${_short(response.body)}');
  }

  try {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is Map<String, dynamic>) return AiResult.ok(decoded);
  } on FormatException {
    // Falls through to the failure below.
  }
  return AiResult.fail(AiFailure.unknown, 'Bad JSON: ${_short(response.body)}');
}

String _short(String s) => s.length <= 300 ? s : '${s.substring(0, 300)}…';

/// Turns extracted text into a result: blank text counts as [AiFailure.blocked].
AiResult<String> textResult(String? text, String whyEmpty) =>
    text == null || text.trim().isEmpty
    ? AiResult.fail(AiFailure.blocked, whyEmpty)
    : AiResult.ok(text);

/// Added to the system prompt when the caller wants JSON back, for
/// providers with no JSON switch in the request.
const jsonOnlyInstruction =
    'Reply with a single JSON object only: no markdown code fences and no '
    'text before or after it.';
