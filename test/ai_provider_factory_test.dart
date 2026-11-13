import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/ai_provider_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Records which host each request went to and answers with [reply].
class _Recorder {
  final hosts = <String>[];
  final paths = <String>[];

  MockClient client(http.Response Function(http.Request) reply) =>
      MockClient((req) async {
        hosts.add(req.url.host);
        paths.add(req.url.path);
        return reply(req);
      });
}

http.Response _json(String body, [int status = 200]) =>
    http.Response(body, status, headers: {'content-type': 'application/json'});

const _anthropicOk =
    '{"content":[{"type":"text","text":"ok"}],"stop_reason":"end_turn"}';
const _geminiOk = '{"candidates":[{"content":{"parts":[{"text":"ok"}]}}]}';
const _openAiOk =
    '{"choices":[{"message":{"content":"ok"},"finish_reason":"stop"}]}';

void main() {
  test('provider names parse ignoring case', () {
    expect(AiProvider.parse(' Anthropic '), AiProvider.anthropic);
    expect(AiProvider.parse('COMPATIBLE'), AiProvider.compatible);
    expect(AiProvider.parse('claude'), isNull);
  });

  test('defaults: Gemini, today\'s Gemini model, Claude Opus 5.5', () {
    const c = AiConfig();
    expect(c.provider, 'gemini');
    expect(c.geminiModel, 'gemini-3.8-flash');
    expect(c.anthropicModel, 'claude-opus-5-5');
  });

  test('each provider goes to its own API', () async {
    final cases = {
      const AiConfig(provider: 'gemini', geminiKey: 'g'): (
        'generativelanguage.googleapis.com',
        _geminiOk,
      ),
      const AiConfig(provider: 'anthropic', anthropicKey: 'a'): (
        'api.anthropic.com',
        _anthropicOk,
      ),
      const AiConfig(provider: 'openai', openAiKey: 'o', openAiModel: 'm'): (
        'api.openai.com',
        _openAiOk,
      ),
      const AiConfig(
        provider: 'compatible',
        openAiKey: 'o',
        openAiModel: 'm',
        openAiBaseUrl: 'http://localhost:8080/v1',
      ): (
        'localhost',
        _openAiOk,
      ),
    };
    for (final MapEntry(key: config, value: (host, body)) in cases.entries) {
      final rec = _Recorder();
      final gen = buildAiGenerator(
        config,
        httpClient: rec.client((_) => _json(body)),
      );
      final r = await gen.generate(prompt: 'hi');
      expect(r.value, 'ok', reason: config.provider);
      expect(rec.hosts, [host], reason: config.provider);
    }
  });

  test('a busy Gemini model hands over to the fallback model', () async {
    final rec = _Recorder();
    final gen = buildAiGenerator(
      const AiConfig(
        geminiKey: 'g',
        geminiModel: 'main',
        geminiFallbackModel: 'spare',
      ),
      httpClient: rec.client(
        (req) =>
            req.url.path.contains('main') ? _json('{}', 503) : _json(_geminiOk),
      ),
    );
    // Shorten the waits so the test is quick.
    final r = await RetryingGenerator(
      (gen as RetryingGenerator).primary,
      fallback: gen.fallback,
      delays: const [Duration.zero],
      fallbackDelays: const [],
    ).generate(prompt: 'hi');

    expect(r.value, 'ok');
    expect(rec.paths.where((p) => p.contains('main')), hasLength(2));
    expect(rec.paths.last, contains('spare'));
  });

  test('incomplete settings fail as "not set up" without a request', () async {
    final configs = [
      const AiConfig(provider: 'claude'),
      const AiConfig(provider: 'anthropic'), // no key
      const AiConfig(provider: 'openai', openAiKey: 'o'), // no model
      const AiConfig(provider: 'compatible', openAiKey: 'o', openAiModel: 'm'),
      const AiConfig(
        provider: 'compatible',
        openAiKey: 'o',
        openAiModel: 'm',
        openAiBaseUrl: 'not a url',
      ),
    ];
    for (final c in configs) {
      final rec = _Recorder();
      final r = await buildAiGenerator(
        c,
        httpClient: rec.client((_) => _json(_openAiOk)),
      ).generate(prompt: 'hi');
      expect(r.failure, AiFailure.noKey, reason: '${c.provider} ${r.detail}');
      expect(rec.hosts, isEmpty);
    }
  });
}
