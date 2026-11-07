import 'package:cow/services/ai/vet_service.dart';

extension VetUrgencyLabel on VetUrgency {
  String get headline => switch (this) {
    VetUrgency.emergency => 'Call a vet now',
    VetUrgency.seeVetSoon => 'A vet should see her soon',
    VetUrgency.monitorAtHome => 'Monitor her at home',
  };

  /// How many days until the farmer should check on her again. Starts from
  /// tomorrow, so it shows up in the upcoming follow-ups list.
  int get followUpDays => switch (this) {
    VetUrgency.emergency => 1,
    VetUrgency.seeVetSoon => 1,
    VetUrgency.monitorAtHome => 2,
  };
}

/// What gets written to the health records when the farmer saves an
/// assessment.
class VetRecordDraft {
  final String recordType;
  final String description;
  final DateTime followUpDate;

  const VetRecordDraft({
    required this.recordType,
    required this.description,
    required this.followUpDate,
  });
}

/// The health record table allows up to 300 characters of description.
const int _maxDescription = 300;

VetRecordDraft buildVetRecordDraft({
  required VetAssessment assessment,
  required String symptoms,
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final followUp = DateTime(
    current.year,
    current.month,
    current.day + assessment.urgency.followUpDays,
  );

  final cleanSymptoms = symptoms.trim().replaceAll(RegExp(r'\s+'), ' ');
  var text = 'Vet Assistant (${assessment.urgency.headline}): $cleanSymptoms';
  if (assessment.summary.isNotEmpty) text += ' — ${assessment.summary}';
  if (text.length > _maxDescription) {
    text = '${text.substring(0, _maxDescription - 1)}…';
  }

  return VetRecordDraft(
    recordType: 'Illness',
    description: text,
    followUpDate: followUp,
  );
}
