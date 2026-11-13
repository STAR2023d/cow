import 'package:cow/health/health_presets.dart';
import 'package:cow/screens/health_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int days(String label) =>
      healthPresets.firstWhere((p) => p.label == label).followUpDays;

  test('suggested follow-up gaps', () {
    expect(days('Tick control'), 14);
    expect(days('Deworming'), 90);
    expect(days('Vaccination'), 180);
    expect(days('Hoof care'), 180);
    expect(days('Vet check'), 30);
  });

  test('follow-up is counted from the treatment day, date only', () {
    final p = healthPresets.firstWhere((p) => p.label == 'Tick control');
    expect(p.followUpFrom(DateTime(2026, 12, 25, 18)), DateTime(2027, 1, 8));
  });

  test('every preset type is in the record type dropdown', () {
    for (final p in healthPresets) {
      expect(healthRecordTypes, contains(p.recordType));
    }
  });

  test('presets never carry a dose', () {
    final dose = RegExp(r'\d|\b(mg|ml|cc|dose)\b', caseSensitive: false);
    for (final p in healthPresets) {
      expect(dose.hasMatch(p.description), isFalse, reason: p.label);
    }
  });
}
