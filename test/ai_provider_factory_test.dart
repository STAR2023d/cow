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
    expect(c.geminiModel, 'gemini-3.5-flash-lite');
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

  group('cross-provider fallback', () {
    AiGenerator fixed(List<String> log, String name, AiResult<String> r) =>
        _Fixed(log, name, r);

    test('busy or unreachable moves on to the next provider', () async {
      for (final failure in [AiFailure.busy, AiFailure.network]) {
        final log = <String>[];
        final r = await ChainGenerator([
          fixed(log, 'a', AiResult.fail(failure)),
          fixed(log, 'b', const AiResult.ok('from b')),
        ]).generate(prompt: 'hi');
        expect(r.value, 'from b');
        expect(log, ['a', 'b']);
      }
    });

    test('a blocked answer is never retried elsewhere', () async {
      final log = <String>[];
      final r = await ChainGenerator([
        fixed(log, 'a', const AiResult.fail(AiFailure.blocked)),
        fixed(log, 'b', const AiResult.ok('from b')),
      ]).generate(prompt: 'hi');
      expect(r.failure, AiFailure.blocked);
      expect(log, ['a']);
    });

    test(
      'providers not set up are skipped, keeping the real failure',
      () async {
        final log = <String>[];
        final r = await ChainGenerator([
          fixed(log, 'a', const AiResult.fail(AiFailure.busy)),
          fixed(log, 'b', const AiResult.fail(AiFailure.noKey)),
          fixed(log, 'c', const AiResult.ok('from c')),
        ]).generate(prompt: 'hi');
        expect(r.value, 'from c');

        final none = await ChainGenerator([
          fixed(log, 'a', const AiResult.fail(AiFailure.busy)),
          fixed(log, 'b', const AiResult.fail(AiFailure.noKey)),
        ]).generate(prompt: 'hi');
        expect(none.failure, AiFailure.busy);
      },
    );

    test('a primary that is not set up does not fall back', () async {
      final log = <String>[];
      final r = await ChainGenerator([
        fixed(log, 'a', const AiResult.fail(AiFailure.noKey)),
        fixed(log, 'b', const AiResult.ok('from b')),
      ]).generate(prompt: 'hi');
      expect(r.failure, AiFailure.noKey);
      expect(log, ['a']);
    });

    test('the factory chains configured providers, end to end', () async {
      final rec = _Recorder();
      final gen = buildAiGenerator(
        const AiConfig(
          provider: 'openai',
          openAiKey: 'o',
          openAiModel: 'm',
          anthropicKey: 'a',
          // Unknown, repeated and unconfigured names are ignored/skipped.
          fallbackProviders: 'claude, OPENAI, gemini, anthropic',
        ),
        httpClient: rec.client(
          (req) => req.url.host == 'api.openai.com'
              ? _json('{}', 400) // unknown failure: no fallback
              : _json(_anthropicOk),
        ),
      );
      expect(gen, isA<ChainGenerator>());
      expect((gen as ChainGenerator).generators, hasLength(3));

      final r = await gen.generate(prompt: 'hi');
      expect(r.failure, AiFailure.unknown);
      expect(rec.hosts, ['api.openai.com']);
    });

    test('no fallback list means no chain', () {
      expect(
        buildAiGenerator(const AiConfig(geminiKey: 'g')),
        isA<RetryingGenerator>(),
      );
    });
  });
}

class _Fixed implements AiGenerator {
  final List<String> log;
  final String name;
  final AiResult<String> result;

  _Fixed(this.log, this.name, this.result);

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    log.add(name);
    return result;
  }
}
