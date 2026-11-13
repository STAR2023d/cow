/// Quick-fill presets for the add-health-record dialog.
///
/// The follow-up gaps are rough suggestions only; the farmer can change
/// them and the vet's advice comes first. Presets never name a medicine or
/// a dose.
class HealthPreset {
  final String label;
  final String recordType;
  final String description;
  final int followUpDays;

  const HealthPreset({
    required this.label,
    required this.recordType,
    required this.description,
    required this.followUpDays,
  });

  /// The suggested follow-up day, [followUpDays] after [treatedOn].
  DateTime followUpFrom(DateTime treatedOn) =>
      DateTime(treatedOn.year, treatedOn.month, treatedOn.day + followUpDays);
}

const List<HealthPreset> healthPresets = [
  HealthPreset(
    label: 'Vaccination',
    recordType: 'Vaccination',
    description: 'Vaccination as advised by the vet',
    followUpDays: 180,
  ),
  HealthPreset(
    label: 'Tick control',
    recordType: 'Tick control',
    description: 'Tick control (spray or dip)',
    followUpDays: 14,
  ),
  HealthPreset(
    label: 'Deworming',
    recordType: 'Deworming',
    description: 'Deworming',
    followUpDays: 90,
  ),
  HealthPreset(
    label: 'Hoof care',
    recordType: 'Hoof care',
    description: 'Hoof check and trimming',
    followUpDays: 180,
  ),
  HealthPreset(
    label: 'Vet check',
    recordType: 'Checkup',
    description: 'Routine vet check',
    followUpDays: 30,
  ),
];
