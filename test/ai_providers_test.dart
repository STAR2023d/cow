import 'dart:convert';
import 'dart:io';

import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/providers/anthropic_http.dart';
import 'package:cow/services/ai/providers/gemini_http.dart';
import 'package:cow/services/ai/providers/openai_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake HTTP client that records the request and replies with [status]
/// and [body] (a JSON-encodable value or a raw string).
class _Fake {
  late http.Request request;
  Map<String, dynamic> get sent =>
      jsonDecode(request.body) as Map<String, dynamic>;

  MockClient reply(int status, Object body) => MockClient((req) async {
    request = req;
    return http.Response(
      body is String ? body : jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });

  MockClient fail(Exception e) => MockClient((req) async {
    request = req;
    throw e;
  });
}

void main() {
  group('Anthropic', () {
    final ok = {
      'content': [
        {'type': 'thinking', 'thinking': ''},
        {'type': 'text', 'text': 'Hello '},
        {'type': 'text', 'text': 'farmer'},
      ],
      'stop_reason': 'end_turn',
    };

    test('sends a Messages API request and joins the text blocks', () async {
      final fake = _Fake();
      final gen = AnthropicGenerator(
        apiKey: 'k',
        model: 'claude-opus-5-5',
        httpClient: fake.reply(200, ok),
      );
      final r = await gen.generate(
        prompt: 'Hi',
        system: 'Be brief',
        json: true,
      );

      expect(r.value, 'Hello farmer');
      expect(
        fake.request.url.toString(),
        'https://api.anthropic.com/v1/messages',
      );
      expect(fake.request.headers['x-api-key'], 'k');
      expect(fake.request.headers['anthropic-version'], '2026-10-21');
      expect(
        fake.request.headers['anthropic-beta'],
        AnthropicGenerator.fallbackBeta,
      );
      expect(fake.sent['model'], 'claude-opus-5-5');
      expect(fake.sent['fallbacks'], 'default');
      expect(fake.sent.containsKey('temperature'), isFalse);
      expect(fake.sent['system'], startsWith('Be brief'));
      expect(fake.sent['system'], contains('JSON object only'));
      expect(fake.sent['messages'], [
        {'role': 'user', 'content': 'Hi'},
      ]);
    });

    test('a refusal is reported as blocked', () async {
      final gen = AnthropicGenerator(
        apiKey: 'k',
        model: 'm',
        httpClient: _Fake().reply(200, {
          'content': <Object>[],
          'stop_reason': 'refusal',
          'stop_details': {'category': 'bio'},
        }),
      );
      final r = await gen.generate(prompt: 'x');
      expect(r.failure, AiFailure.blocked);
    });

    test('529 overloaded is busy; 400 is unknown', () async {
      final busy = await AnthropicGenerator(
        apiKey: 'k',
        model: 'm',
        httpClient: _Fake().reply(529, {'type': 'error'}),
      ).generate(prompt: 'x');
      expect(busy.failure, AiFailure.busy);

      final bad = await AnthropicGenerator(
        apiKey: 'k',
        model: 'm',
        httpClient: _Fake().reply(400, {'type': 'error'}),
      ).generate(prompt: 'x');
      expect(bad.failure, AiFailure.unknown);
      expect(bad.detail, startsWith('HTTP 400'));
    });

    test('no key fails without calling the network', () async {
      final r = await AnthropicGenerator(
        apiKey: '',
        model: 'm',
        httpClient: MockClient((_) => fail('must not be called')),
      ).generate(prompt: 'x');
      expect(r.failure, AiFailure.noKey);
    });
  });

  group('Gemini', () {
    test('sends generateContent and reads the parts', () async {
      final fake = _Fake();
      final gen = GeminiHttpGenerator(
        apiKey: 'g',
        model: 'gemini-x',
        httpClient: fake.reply(200, {
          'candidates': [
            {
              'content': {
                'parts': [
                  {'text': '{"a":'},
                  {'text': '1}'},
                ],
              },
              'finishReason': 'STOP',
            },
          ],
        }),
      );
      final r = await gen.generate(prompt: 'Hi', system: 'S', json: true);

      expect(r.value, '{"a":1}');
      expect(
        fake.request.url.toString(),
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-x:generateContent',
      );
      expect(fake.request.headers['x-goog-api-key'], 'g');
      expect(fake.request.url.query, isEmpty); // key not in the URL
      expect(fake.sent['systemInstruction']['parts'][0]['text'], 'S');
      expect(
        fake.sent['generationConfig']['responseMimeType'],
        'application/json',
      );
    });

    test('a blocked prompt or no candidates is blocked', () async {
      final blocked = await GeminiHttpGenerator(
        apiKey: 'g',
        model: 'm',
        httpClient: _Fake().reply(200, {
          'promptFeedback': {'blockReason': 'SAFETY'},
        }),
      ).generate(prompt: 'x');
      expect(blocked.failure, AiFailure.blocked);

      final empty = await GeminiHttpGenerator(
        apiKey: 'g',
        model: 'm',
        httpClient: _Fake().reply(200, {'candidates': <Object>[]}),
      ).generate(prompt: 'x');
      expect(empty.failure, AiFailure.blocked);
    });

    test('429 and 503 are busy', () async {
      for (final status in [429, 503]) {
        final r = await GeminiHttpGenerator(
          apiKey: 'g',
          model: 'm',
          httpClient: _Fake().reply(status, {'error': {}}),
        ).generate(prompt: 'x');
        expect(r.failure, AiFailure.busy, reason: '$status');
      }
    });
  });

  group('OpenAI and compatible', () {
    final ok = {
      'choices': [
        {
          'message': {'role': 'assistant', 'content': 'Sawa'},
          'finish_reason': 'stop',
        },
      ],
    };

    test('sends chat completions with JSON mode and a bearer key', () async {
      final fake = _Fake();
      final r = await OpenAiGenerator(
        apiKey: 'o',
        model: 'some-model',
        httpClient: fake.reply(200, ok),
      ).generate(prompt: 'Hi', system: 'S', json: true);

      expect(r.value, 'Sawa');
      expect(
        fake.request.url.toString(),
        'https://api.openai.com/v1/chat/completions',
      );
      expect(fake.request.headers['authorization'], 'Bearer o');
      expect(fake.sent['response_format'], {'type': 'json_object'});
      expect(fake.sent['messages'][0]['role'], 'system');
      expect(fake.sent['messages'][1], {'role': 'user', 'content': 'Hi'});
    });

    test(
      'a compatible service uses its base URL; JSON mode can be off',
      () async {
        final fake = _Fake();
        await OpenAiGenerator(
          apiKey: 'o',
          model: 'local',
          baseUrl: Uri.parse('http://localhost:8080/v1/'),
          supportsJsonMode: false,
          httpClient: fake.reply(200, ok),
        ).generate(prompt: 'Hi', json: true);

        expect(
          fake.request.url.toString(),
          'http://localhost:8080/v1/chat/completions',
        );
        expect(fake.sent.containsKey('response_format'), isFalse);
        expect(
          fake.sent['messages'][0]['content'],
          contains('JSON object only'),
        );
      },
    );

    test('content filter and refusals are blocked', () async {
      final filtered = await OpenAiGenerator(
        apiKey: 'o',
        model: 'm',
        httpClient: _Fake().reply(200, {
          'choices': [
            {
              'message': {'content': null},
              'finish_reason': 'content_filter',
            },
          ],
        }),
      ).generate(prompt: 'x');
      expect(filtered.failure, AiFailure.blocked);

      final refused = await OpenAiGenerator(
        apiKey: 'o',
        model: 'm',
        httpClient: _Fake().reply(200, {
          'choices': [
            {
              'message': {'content': null, 'refusal': 'No'},
              'finish_reason': 'stop',
            },
          ],
        }),
      ).generate(prompt: 'x');
      expect(refused.failure, AiFailure.blocked);
    });

    test('missing model counts as not configured', () async {
      final r = await OpenAiGenerator(
        apiKey: 'o',
        model: '',
      ).generate(prompt: 'x');
      expect(r.failure, AiFailure.noKey);
    });
  });

  group('shared error handling', () {
    test('network errors and timeouts are network', () async {
      final socket = await OpenAiGenerator(
        apiKey: 'o',
        model: 'm',
        httpClient: _Fake().fail(const SocketException('no route')),
      ).generate(prompt: 'x');
      expect(socket.failure, AiFailure.network);

      final client = await AnthropicGenerator(
        apiKey: 'k',
        model: 'm',
        httpClient: _Fake().fail(http.ClientException('reset')),
      ).generate(prompt: 'x');
      expect(client.failure, AiFailure.network);

      final slow = await GeminiHttpGenerator(
        apiKey: 'g',
        model: 'm',
        timeout: const Duration(milliseconds: 10),
        httpClient: MockClient((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          return http.Response('{}', 200);
        }),
      ).generate(prompt: 'x');
      expect(slow.failure, AiFailure.network);
    });

    test('a non-JSON reply is unknown and the key never leaks', () async {
      final r = await AnthropicGenerator(
        apiKey: 'secret-key',
        model: 'm',
        httpClient: _Fake().reply(200, '<html>oops</html>'),
      ).generate(prompt: 'x');
      expect(r.failure, AiFailure.unknown);
      expect(r.detail, isNot(contains('secret-key')));
    });
  });
}
