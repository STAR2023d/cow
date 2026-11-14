// Live check: sends real requests to each AI provider that has settings.
// A plain `flutter test` passes no settings, so every test here is skipped.
// Run with:
//   flutter test test/live --dart-define-from-file=$HOME/.config/cow/env.json
// Never prints keys.
import 'package:cow/services/ai/ai_provider_factory.dart';
import 'package:cow/services/ai/vet_service.dart';
import 'package:flutter_test/flutter_test.dart';

const env = AiConfig.fromEnvironment();

AiConfig only(String provider) => AiConfig(
  provider: provider,
  geminiKey: env.geminiKey,
  geminiModel: env.geminiModel,
  geminiFallbackModel: env.geminiFallbackModel,
  anthropicKey: env.anthropicKey,
  anthropicModel: env.anthropicModel,
  openAiKey: env.openAiKey,
  openAiModel: env.openAiModel,
  openAiBaseUrl: env.openAiBaseUrl,
  openAiJsonMode: env.openAiJsonMode,
);

String? whySkip(String provider) => switch (provider) {
  'gemini' when env.geminiKey.isEmpty => 'no GEMINI_API_KEY',
  'anthropic' when env.anthropicKey.isEmpty => 'no ANTHROPIC_API_KEY',
  'openai' when env.openAiKey.isEmpty || env.openAiModel.isEmpty =>
    'no OPENAI_API_KEY or OPENAI_MODEL',
  _ => null,
};

String model(String provider) => switch (provider) {
  'gemini' => env.geminiModel,
  'anthropic' => env.anthropicModel,
  _ => env.openAiModel,
};

String head(String s) => s.length > 200 ? '${s.substring(0, 200)}...' : s;

// Digits followed by a dose unit, e.g. "10 ml" or "5mg/kg".
final _dose = RegExp(r'\d+\s*(ml|mg|g|cc|iu)\b', caseSensitive: false);

const _case = VetCase(
  cowName: 'Daisy',
  breed: 'Friesian',
  ageYears: 4,
  breedingStatus: 'Milking, 3 months after calving',
  symptoms: 'She is eating less than usual and gave less milk',
  duration: '1 day',
);

void main() {
  for (final provider in ['gemini', 'anthropic', 'openai']) {
    group('$provider (${model(provider)})', () {
      final skip = whySkip(provider);

      test('plain reply', skip: skip, () async {
        final ai = buildAiGenerator(only(provider));
        final r = await ai.generate(prompt: 'Reply with the single word OK');
        // ignore: avoid_print
        print('$provider plain: ${r.failure ?? head(r.value ?? '')} '
            '${r.detail ?? ''}');
        expect(r.failure, isNull);
        expect(r.value!.trim(), isNotEmpty);
      }, timeout: const Timeout(Duration(minutes: 2)));

      test('vet case parses, no doses', skip: skip, () async {
        final ai = buildAiGenerator(only(provider));
        final r = await VetService(ai).assess(_case);
        final a = r.value;
        // ignore: avoid_print
        print('$provider vet: ${r.failure ?? '${a!.urgency.name}: '
            '${head(a.summary)}'} ${r.detail ?? ''}');
        expect(r.failure, isNull);
        expect(a!.summary.trim(), isNotEmpty);
        expect(a.whatToDoNow, isNotEmpty);
        final all = [a.summary, ...a.whatToDoNow, ...a.possibleCauses,
            ...a.callVetIf, a.milkAdvice].join('\n');
        expect(_dose.hasMatch(all), isFalse, reason: 'dose found: $all');
      }, timeout: const Timeout(Duration(minutes: 2)));
    });
  }
}
