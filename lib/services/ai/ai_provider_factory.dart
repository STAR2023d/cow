import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/providers/anthropic_http.dart';
import 'package:cow/services/ai/providers/gemini_http.dart';
import 'package:cow/services/ai/providers/openai_http.dart';
import 'package:http/http.dart' as http;

/// Which AI service the app talks to.
enum AiProvider {
  gemini,
  anthropic,
  openai,

  /// Any service with an OpenAI-compatible API at [AiConfig.openAiBaseUrl].
  compatible;

  /// Matches `AI_PROVIDER` values, ignoring case. Null when unknown.
  static AiProvider? parse(String name) {
    final n = name.trim().toLowerCase();
    for (final p in values) {
      if (p.name == n) return p;
    }
    return null;
  }
}

/// AI settings, read from `--dart-define` values at build time (put them in
/// the private env file passed with `--dart-define-from-file`, never in the
/// repository). Every field can also be set directly, for tests.
class AiConfig {
  /// `gemini` (default), `anthropic`, `openai` or `compatible`.
  final String provider;

  final String geminiKey;
  final String geminiModel;

  /// Second Gemini model tried when the first stays busy. Empty = none.
  final String geminiFallbackModel;

  final String anthropicKey;
  final String anthropicModel;

  final String openAiKey;

  /// No default: OpenAI and compatible services need a model named.
  final String openAiModel;

  /// For `compatible`, e.g. `http://localhost:8080/v1`. Empty = OpenAI.
  final String openAiBaseUrl;

  /// Set to false for compatible services that reject `response_format`.
  final bool openAiJsonMode;

  /// Other providers to try, in order, when [provider] stays busy or
  /// unreachable, e.g. `anthropic,openai`. Ones not fully set up are
  /// skipped. Empty = none.
  final String fallbackProviders;

  const AiConfig({
    this.provider = 'gemini',
    this.geminiKey = '',
    this.geminiModel = 'gemini-3.5-flash-lite',
    this.geminiFallbackModel = '',
    this.anthropicKey = '',
    this.anthropicModel = 'claude-opus-5-5',
    this.openAiKey = '',
    this.openAiModel = '',
    this.openAiBaseUrl = '',
    this.openAiJsonMode = true,
    this.fallbackProviders = '',
  });

  const AiConfig.fromEnvironment()
    : provider = const String.fromEnvironment(
        'AI_PROVIDER',
        defaultValue: 'gemini',
      ),
      geminiKey = const String.fromEnvironment('GEMINI_API_KEY'),
      geminiModel = const String.fromEnvironment(
        'GEMINI_MODEL',
        defaultValue: 'gemini-3.5-flash-lite',
      ),
      geminiFallbackModel = const String.fromEnvironment(
        'GEMINI_FALLBACK_MODEL',
      ),
      anthropicKey = const String.fromEnvironment('ANTHROPIC_API_KEY'),
      anthropicModel = const String.fromEnvironment(
        'ANTHROPIC_MODEL',
        defaultValue: 'claude-opus-5-5',
      ),
      openAiKey = const String.fromEnvironment('OPENAI_API_KEY'),
      openAiModel = const String.fromEnvironment('OPENAI_MODEL'),
      openAiBaseUrl = const String.fromEnvironment('OPENAI_BASE_URL'),
      openAiJsonMode = const bool.fromEnvironment(
        'OPENAI_JSON_MODE',
        defaultValue: true,
      ),
      fallbackProviders = const String.fromEnvironment('AI_FALLBACK_PROVIDERS');
}

/// Retries a busy [primary] (2 s, then 5 s), then hands over to [fallback]
/// (one retry after 2 s) if that is still busy. The behaviour the app has
/// had since Phase 2, now for any provider.
class RetryingGenerator implements AiGenerator {
  final AiGenerator primary;
  final AiGenerator? fallback;
  final List<Duration> delays;
  final List<Duration> fallbackDelays;

  const RetryingGenerator(
    this.primary, {
    this.fallback,
    this.delays = const [Duration(seconds: 2), Duration(seconds: 5)],
    this.fallbackDelays = const [Duration(seconds: 2)],
  });

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) {
    Future<AiResult<String>> Function() call(AiGenerator g) =>
        () => g.generate(prompt: prompt, system: system, json: json);

    final f = fallback;
    return fallbackWhenBusy(
      () => retryWhenBusy(call(primary), delays: delays),
      f == null ? null : () => retryWhenBusy(call(f), delays: fallbackDelays),
    );
  }
}

/// Always fails as "not set up" ([AiFailure.noKey]); used when the
/// settings are incomplete.
class _NotConfigured implements AiGenerator {
  final String why;
  const _NotConfigured(this.why);

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async => AiResult.fail(AiFailure.noKey, why);
}

/// Tries [generators] in order. Moves to the next one only while the
/// result so far is [AiFailure.busy] or [AiFailure.network]. A generator
/// that is not set up ([AiFailure.noKey]) is skipped and the earlier
/// failure kept. A blocked answer is never retried elsewhere: if one
/// model declines, the app does not shop around for another.
class ChainGenerator implements AiGenerator {
  final List<AiGenerator> generators;

  const ChainGenerator(this.generators);

  static const _moveOn = {AiFailure.busy, AiFailure.network};

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    AiResult<String>? result;
    for (final g in generators) {
      if (result != null && !_moveOn.contains(result.failure)) break;
      final r = await g.generate(prompt: prompt, system: system, json: json);
      if (r.isOk) return r;
      if (result == null || r.failure != AiFailure.noKey) result = r;
    }
    return result ?? const AiResult.fail(AiFailure.noKey, 'No providers');
  }
}

/// Builds the generator for [config.provider] (with retries), followed by
/// any [AiConfig.fallbackProviders]. [httpClient] is for tests.
AiGenerator buildAiGenerator(AiConfig config, {http.Client? httpClient}) {
  final primary = _buildProvider(config.provider, config, httpClient);
  final primaryKind = AiProvider.parse(config.provider);
  final seen = {?primaryKind};
  final fallbacks = <AiGenerator>[];
  for (final name in config.fallbackProviders.split(',')) {
    final kind = AiProvider.parse(name);
    if (kind == null || !seen.add(kind)) continue; // unknown or repeated
    fallbacks.add(_buildProvider(name, config, httpClient));
  }
  return fallbacks.isEmpty ? primary : ChainGenerator([primary, ...fallbacks]);
}

AiGenerator _buildProvider(
  String name,
  AiConfig config,
  http.Client? httpClient,
) {
  final provider = AiProvider.parse(name);
  switch (provider) {
    case null:
      return _NotConfigured('Unknown AI provider "$name"');
    case AiProvider.gemini:
      GeminiHttpGenerator gemini(String model) => GeminiHttpGenerator(
        apiKey: config.geminiKey,
        model: model,
        httpClient: httpClient,
      );
      final fb = config.geminiFallbackModel;
      return RetryingGenerator(
        gemini(config.geminiModel),
        fallback: fb.isNotEmpty && fb != config.geminiModel ? gemini(fb) : null,
      );
    case AiProvider.anthropic:
      return RetryingGenerator(
        AnthropicGenerator(
          apiKey: config.anthropicKey,
          model: config.anthropicModel,
          httpClient: httpClient,
        ),
      );
    case AiProvider.openai:
    case AiProvider.compatible:
      final base = config.openAiBaseUrl.trim();
      if (provider == AiProvider.compatible && base.isEmpty) {
        return const _NotConfigured('OPENAI_BASE_URL is required');
      }
      final uri = base.isEmpty ? null : Uri.tryParse(base);
      if (base.isNotEmpty && (uri == null || !uri.hasScheme)) {
        return _NotConfigured('Bad OPENAI_BASE_URL "$base"');
      }
      return RetryingGenerator(
        OpenAiGenerator(
          apiKey: config.openAiKey,
          model: config.openAiModel,
          baseUrl: uri,
          supportsJsonMode: config.openAiJsonMode,
          httpClient: httpClient,
        ),
      );
  }
}

/// The app's default generator: built once from the `--dart-define`
/// settings the first time it is used. `const`, so services and screens
/// can keep `const` default arguments.
class ConfiguredAiGenerator implements AiGenerator {
  const ConfiguredAiGenerator();

  static final AiGenerator _instance = buildAiGenerator(
    const AiConfig.fromEnvironment(),
  );

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) => _instance.generate(prompt: prompt, system: system, json: json);
}
