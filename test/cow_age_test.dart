import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations_en.dart';
import 'package:cow/models/cow_age.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 20);

  test('age counts whole months from the birth date', () {
    expect(ageOn(null, now), isNull);
    expect(ageOn(DateTime(2026, 3, 20), now), const CowAge(0, 8));
    expect(ageOn(DateTime(2026, 3, 21), now), const CowAge(0, 7));
    expect(ageOn(DateTime(2025, 9, 20), now), const CowAge(1, 2));
    expect(ageOn(DateTime(2023, 11, 1), now), const CowAge(3, 0));
    expect(ageOn(DateTime(2027, 1, 1), now), const CowAge(0, 0));
  });

  test('age grows as time passes', () {
    final born = DateTime(2023, 6, 1);
    expect(ageOn(born, DateTime(2026, 6, 1))!.years, 3);
    expect(ageOn(born, DateTime(2027, 6, 1))!.years, 4);
  });

  test('labels', () {
    final l = L10nEn();
    expect(ageLabel(l, const CowAge(0, 1)), '1 month');
    expect(ageLabel(l, const CowAge(0, 8)), '8 months');
    expect(ageLabel(l, const CowAge(1, 0)), '1 year');
    expect(ageLabel(l, const CowAge(3, 2)), '3 years 2 months');
  });

  test('a heifer kept from breeding is born on the calving day', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final dam = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    final cycleId = await db
        .into(db.breedingCycles)
        .insert(
          BreedingCyclesCompanion.insert(
            cowId: dam,
            heatDate: DateTime(2025, 11, 1),
            stage: BreedingStage.calved,
            actualCalvingDate: Value(DateTime(2026, 8, 10)),
          ),
        );
    final calf = await db.keepFemaleCalf(
      cycleId: cycleId,
      damCowId: dam,
      calfName: 'Neema',
    );
    final cows = await db.allCows();
    expect(cows.firstWhere((c) => c.id == calf).bornOn, DateTime(2026, 8, 10));
  });
}
