import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/vet_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// A pretend AI that returns whatever we give it, so tests need no internet.
class FakeGenerator implements AiGenerator {
  final AiResult<String> result;
  String? lastPrompt;
  String? lastSystem;
  bool? lastJson;

  FakeGenerator(this.result);

  @override
  Future<AiResult<String>> generate({
    required String prompt,
    String? system,
    bool json = false,
  }) async {
    lastPrompt = prompt;
    lastSystem = system;
    lastJson = json;
    return result;
  }
}

const _monitorJson = '''
{
  "urgency": "monitor_at_home",
  "summary": "Mild digestive upset.",
  "possibleCauses": ["Sudden feed change", "Mild indigestion"],
  "whatToDoNow": ["Offer clean water", "Keep her calm"],
  "callVetIf": ["She stops eating", "Her belly swells"],
  "milkAdvice": ""
}
''';

void main() {
  const mildCase = VetCase(
    cowName: 'Daisy',
    breed: 'Friesian',
    ageYears: 4,
    breedingStatus: 'Pregnant, 4 weeks to calving',
    symptoms: 'She is eating less than usual',
    duration: '2 days',
  );

  group('buildVetPrompt', () {
    test('includes the cow details, symptoms and language', () {
      final prompt = buildVetPrompt(mildCase);
      expect(prompt, contains('Cow: Daisy'));
      expect(prompt, contains('Breed: Friesian'));
      expect(prompt, contains('Age: 4 years'));
      expect(prompt, contains('Pregnant, 4 weeks to calving'));
      expect(prompt, contains('She is eating less than usual'));
      expect(prompt, contains('How long: 2 days'));
      expect(prompt, contains('in English'));
    });

    test('leaves out details that were not given', () {
      const bare = VetCase(
        cowName: 'Bella',
        symptoms: 'Limping',
        language: VetLanguage.swahili,
      );
      final prompt = buildVetPrompt(bare);
      expect(prompt, isNot(contains('Breed:')));
      expect(prompt, isNot(contains('Age:')));
      expect(prompt, isNot(contains('How long:')));
      expect(prompt, contains('in Kiswahili'));
    });
  });

  group('findRedFlags', () {
    test('spots danger signs in any letter case', () {
      expect(findRedFlags('She is BLOATED on the left side'), ['bloat']);
      expect(findRedFlags("She can\u2019t stand up"), ["can't stand"]);
    });

    test('returns nothing for ordinary symptoms', () {
      expect(findRedFlags('She is eating less than usual'), isEmpty);
    });
  });

  group('parseVetResponse', () {
    test('reads a normal reply', () {
      final a = parseVetResponse(_monitorJson)!;
      expect(a.urgency, VetUrgency.monitorAtHome);
      expect(a.summary, 'Mild digestive upset.');
      expect(a.possibleCauses.length, 2);
      expect(a.whatToDoNow.first, 'Offer clean water');
      expect(a.callVetIf.length, 2);
    });

    test('reads a reply wrapped in a code fence', () {
      final a = parseVetResponse('```json\n$_monitorJson\n```')!;
      expect(a.urgency, VetUrgency.monitorAtHome);
    });

    test('an unknown urgency is treated cautiously', () {
      final a = parseVetResponse('{"urgency": "fine", "summary": "x"}')!;
      expect(a.urgency, VetUrgency.seeVetSoon);
    });

    test('missing lists become empty lists', () {
      final a = parseVetResponse('{"urgency": "emergency"}')!;
      expect(a.possibleCauses, isEmpty);
      expect(a.summary, '');
    });

    test('garbage returns null', () {
      expect(parseVetResponse('Sorry, I cannot help'), isNull);
      expect(parseVetResponse('[1, 2, 3]'), isNull);
    });
  });

  group('VetService.assess', () {
    test('sends the prompt and instructions, asking for JSON', () async {
      final fake = FakeGenerator(const AiResult.ok(_monitorJson));
      await VetService(fake).assess(mildCase);

      expect(fake.lastPrompt, contains('Cow: Daisy'));
      expect(fake.lastSystem, vetSystemInstruction);
      expect(fake.lastJson, isTrue);
    });

    test('keeps the AI urgency when there are no danger signs', () async {
      final fake = FakeGenerator(const AiResult.ok(_monitorJson));
      final result = await VetService(fake).assess(mildCase);

      expect(result.isOk, isTrue);
      expect(result.value!.urgency, VetUrgency.monitorAtHome);
      expect(result.value!.redFlags, isEmpty);
    });

    test('danger signs raise a mild answer to emergency', () async {
      final fake = FakeGenerator(const AiResult.ok(_monitorJson));
      const bloated = VetCase(
        cowName: 'Daisy',
        symptoms: 'Her left side is swollen, looks like bloat',
      );
      final result = await VetService(fake).assess(bloated);

      expect(result.value!.urgency, VetUrgency.emergency);
      expect(result.value!.redFlags, ['bloat']);
    });

    test('an AI emergency is never lowered', () async {
      final fake = FakeGenerator(
        const AiResult.ok('{"urgency": "emergency", "summary": "Act now"}'),
      );
      final result = await VetService(fake).assess(mildCase);

      expect(result.value!.urgency, VetUrgency.emergency);
    });

    test('passes failures through', () async {
      final fake = FakeGenerator(const AiResult.fail(AiFailure.noKey));
      final result = await VetService(fake).assess(mildCase);

      expect(result.isOk, isFalse);
      expect(result.failure, AiFailure.noKey);
    });

    test('an unreadable reply is reported as a failure', () async {
      final fake = FakeGenerator(const AiResult.ok('I am not JSON'));
      final result = await VetService(fake).assess(mildCase);

      expect(result.isOk, isFalse);
      expect(result.failure, AiFailure.unknown);
    });
  });
}
