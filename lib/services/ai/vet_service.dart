import 'dart:convert';

import 'package:cow/services/ai/ai_generator.dart';

enum VetUrgency {
  /// Call a vet now.
  emergency,

  /// A vet should see her within about a day.
  seeVetSoon,

  /// Safe to manage at home and watch closely.
  monitorAtHome,
}

enum VetLanguage {
  english('English'),
  swahili('Kiswahili');

  final String promptName;
  const VetLanguage(this.promptName);
}

/// Everything the assistant is told about one sick cow.
class VetCase {
  final String cowName;
  final String? breed;
  final int? ageYears;

  /// For example "Pregnant, 3 weeks to calving" or "Recently calved".
  final String? breedingStatus;

  /// For example "Milk dropped from 12 L to 7 L in 3 days".
  final String? recentMilkNote;

  /// The farmer's own words.
  final String symptoms;

  /// For example "2 days".
  final String? duration;

  final VetLanguage language;

  const VetCase({
    required this.cowName,
    required this.symptoms,
    this.breed,
    this.ageYears,
    this.breedingStatus,
    this.recentMilkNote,
    this.duration,
    this.language = VetLanguage.english,
  });
}

class VetAssessment {
  final VetUrgency urgency;
  final String summary;
  final List<String> possibleCauses;
  final List<String> whatToDoNow;
  final List<String> callVetIf;
  final String milkAdvice;

  /// Danger signs found in the farmer's description. When not empty, the
  /// urgency was raised to [VetUrgency.emergency] regardless of what the
  /// AI said.
  final List<String> redFlags;

  const VetAssessment({
    required this.urgency,
    required this.summary,
    this.possibleCauses = const [],
    this.whatToDoNow = const [],
    this.callVetIf = const [],
    this.milkAdvice = '',
    this.redFlags = const [],
  });

  VetAssessment copyWith({VetUrgency? urgency, List<String>? redFlags}) {
    return VetAssessment(
      urgency: urgency ?? this.urgency,
      summary: summary,
      possibleCauses: possibleCauses,
      whatToDoNow: whatToDoNow,
      callVetIf: callVetIf,
      milkAdvice: milkAdvice,
      redFlags: redFlags ?? this.redFlags,
    );
  }
}

const String vetSystemInstruction = '''
You are a veterinary assistant for small-scale dairy farmers in Kenya.
Give practical, plain-language guidance a farmer can act on today.

Rules:
- You are NOT a replacement for a vet. When unsure, choose the safer urgency.
- Never give drug names with doses, and never tell the farmer to inject or
  dose anything. For medicines, tell them to ask a vet or animal health
  officer.
- If antibiotics or other treatment may be involved, remind them that milk
  from treated cows must be withheld for the period on the medicine label.
- Think about diseases common in Kenyan dairy herds, such as mastitis,
  East Coast fever and other tick-borne diseases, milk fever, bloat, foot
  and mouth disease, lumpy skin disease and calving problems.
- Use the cow's breeding status: late pregnancy and the weeks after
  calving carry specific risks.
- Urgency levels: "emergency" means call a vet now; "see_vet_soon" means a
  vet should see her within about a day; "monitor_at_home" means it is
  safe to manage at home and watch closely.
- Reply with JSON only, no other text.
''';

/// The user message: the cow's details, the symptoms, and the JSON shape
/// the reply must follow.
String buildVetPrompt(VetCase c) {
  final lines = <String>[
    'Cow: ${c.cowName}',
    if (c.breed != null && c.breed!.isNotEmpty) 'Breed: ${c.breed}',
    if (c.ageYears != null) 'Age: ${c.ageYears} years',
    if (c.breedingStatus != null && c.breedingStatus!.isNotEmpty)
      'Breeding status: ${c.breedingStatus}',
    if (c.recentMilkNote != null && c.recentMilkNote!.isNotEmpty)
      'Recent milk: ${c.recentMilkNote}',
    'Symptoms (farmer\'s words): ${c.symptoms}',
    if (c.duration != null && c.duration!.isNotEmpty) 'How long: ${c.duration}',
    'Write all text values in ${c.language.promptName}.',
  ];

  return '''
${lines.join('\n')}

Reply with a JSON object with exactly these keys:
{
  "urgency": "emergency" | "see_vet_soon" | "monitor_at_home",
  "summary": "one or two plain sentences",
  "possibleCauses": ["up to 4 short items, most likely first"],
  "whatToDoNow": ["up to 5 short, practical steps"],
  "callVetIf": ["up to 4 warning signs that mean call a vet"],
  "milkAdvice": "whether to keep using the milk, or empty string"
}
''';
}

/// Danger signs that always mean "call a vet now", whatever the AI says.
/// This list deliberately errs on the side of caution: a false alarm costs
/// a phone call, a missed emergency can cost the cow. English only for now.
const List<String> _redFlagPhrases = [
  'bloat',
  'cannot stand',
  "can't stand",
  'unable to stand',
  'down cow',
  'collapsed',
  'convulsion',
  'seizure',
  'difficulty breathing',
  'struggling to breathe',
  'laboured breathing',
  'labored breathing',
  'not breathing',
  'heavy bleeding',
  'severe bleeding',
  'prolapse',
  'stuck calf',
  'calf stuck',
  'difficult calving',
  'paralysed',
  'paralyzed',
  'foaming',
  'snakebite',
  'snake bite',
  'poison',
];

/// The danger phrases found in [symptoms] (empty when none).
List<String> findRedFlags(String symptoms) {
  final text = symptoms.toLowerCase().replaceAll('\u2019', "'");
  return _redFlagPhrases.where(text.contains).toList();
}

/// Turns the AI's reply into a [VetAssessment]. Returns null when the
/// reply is not usable JSON. An unknown urgency value becomes
/// [VetUrgency.seeVetSoon] so bad output never looks like "all clear".
VetAssessment? parseVetResponse(String raw) {
  var text = raw.trim();
  final fenced = RegExp(r'```(?:json)?\s*([\s\S]*?)```').firstMatch(text);
  if (fenced != null) text = fenced.group(1)!.trim();

  final Object? decoded;
  try {
    decoded = jsonDecode(text);
  } catch (_) {
    return null;
  }
  if (decoded is! Map<String, dynamic>) return null;

  List<String> strings(Object? value) => value is List
      ? value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
      : <String>[];

  final urgency = switch (decoded['urgency']) {
    'emergency' => VetUrgency.emergency,
    'monitor_at_home' => VetUrgency.monitorAtHome,
    _ => VetUrgency.seeVetSoon,
  };

  return VetAssessment(
    urgency: urgency,
    summary: (decoded['summary'] ?? '').toString(),
    possibleCauses: strings(decoded['possibleCauses']),
    whatToDoNow: strings(decoded['whatToDoNow']),
    callVetIf: strings(decoded['callVetIf']),
    milkAdvice: (decoded['milkAdvice'] ?? '').toString(),
  );
}

class VetService {
  final AiGenerator generator;

  const VetService([this.generator = const GeminiGenerator()]);

  /// Asks the AI to assess [vetCase]. Danger signs in the farmer's
  /// description can only raise the urgency, never lower it.
  Future<AiResult<VetAssessment>> assess(VetCase vetCase) async {
    final result = await generator.generate(
      prompt: buildVetPrompt(vetCase),
      system: vetSystemInstruction,
      json: true,
    );

    if (!result.isOk) return AiResult.fail(result.failure!, result.detail);

    final assessment = parseVetResponse(result.value!);
    if (assessment == null) {
      return AiResult.fail(AiFailure.unknown, 'Could not read the AI reply');
    }

    final flags = findRedFlags(vetCase.symptoms);
    if (flags.isEmpty) return AiResult.ok(assessment);

    return AiResult.ok(
      assessment.copyWith(urgency: VetUrgency.emergency, redFlags: flags),
    );
  }
}
