import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int daisy;
  late int bella;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    daisy = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    bella = await db.insertCow(CowCompanion.insert(name: 'Bella'));
  });
  tearDown(() => db.close());

  /// Gives [cowId] one record in every table that points at a cow.
  Future<void> addRecords(int cowId) async {
    await db.upsertMilkEntry(
      cowId: cowId,
      date: DateTime(2026, 11, 10, 7),
      session: 'Morning',
      amount: 5,
    );
    await db
        .into(db.healthRecord)
        .insert(
          HealthRecordCompanion.insert(
            date: DateTime(2026, 11, 1),
            cowId: cowId,
            recordType: 'Treatment',
            description: 'Mastitis',
          ),
        );
    final cycle = await db
        .into(db.breedingCycles)
        .insert(
          BreedingCyclesCompanion.insert(
            cowId: cowId,
            heatDate: DateTime(2025, 12, 1),
            stage: BreedingStage.awaitingService,
          ),
        );
    await db
        .into(db.calves)
        .insert(
          CalvesCompanion.insert(
            dateOfBirth: DateTime(2026, 9, 1),
            sex: 'female',
            breedingCycleId: Value(cycle),
            damCowId: Value(cowId),
          ),
        );
  }

  Future<int> rows(String table) async =>
      (await db.customSelect('SELECT COUNT(*) AS n FROM $table').getSingle())
          .read<int>('n');

  test(
    'a cow that left is hidden from the herd but keeps her records',
    () async {
      await addRecords(daisy);
      await db.removeFromHerd(daisy, 'sold', DateTime(2026, 11, 12, 15));

      expect((await db.herdCows()).map((c) => c.name), ['Bella']);
      final gone = (await db.watchLeftCows().first).single;
      expect(gone.name, 'Daisy');
      expect(gone.leftReason, 'sold');
      expect(gone.leftOn, DateTime(2026, 11, 12));
      expect(gone.inMilk, isFalse);
      // Names on old records can still be looked up.
      expect((await db.allCows()).length, 2);
      expect(await db.cowRecordCount(daisy), 4);

      await db.returnToHerd(daisy);
      expect((await db.herdCows()).length, 2);
      final back = (await db.allCows()).firstWhere((c) => c.id == daisy);
      expect(back.leftOn, isNull);
      expect(back.leftReason, isNull);
    },
  );

  test('a full delete removes the cow and all her records only', () async {
    await addRecords(daisy);
    await addRecords(bella);
    final daughter = await db.insertCow(
      CowCompanion.insert(name: 'Daisy Jr', parentCowId: Value(daisy)),
    );

    await db.deleteCow(daisy);

    for (final t in [
      'milk_table',
      'health_record',
      'breeding_cycles',
      'calves',
    ]) {
      expect(await rows(t), 1, reason: t); // Bella's record is left.
    }
    expect(await db.cowRecordCount(bella), 4);
    final left = await db.allCows();
    expect(left.map((c) => c.id), unorderedEquals([bella, daughter]));
    expect(left.firstWhere((c) => c.id == daughter).parentCowId, isNull);
  });

  test('clean-up removes records left by an old-style delete', () async {
    await addRecords(daisy);
    await addRecords(bella);
    final daughter = await db.insertCow(
      CowCompanion.insert(name: 'Daisy Jr', parentCowId: Value(daisy)),
    );
    // Before v12 a delete removed only the cow row.
    await db.customStatement('DELETE FROM cow WHERE id = ?', [daisy]);

    await db.deleteOrphanRecords();

    for (final t in [
      'milk_table',
      'health_record',
      'breeding_cycles',
      'calves',
    ]) {
      expect(await rows(t), 1, reason: t); // Only Bella's are left.
    }
    expect(await db.cowRecordCount(bella), 4);
    final jr = (await db.allCows()).firstWhere((c) => c.id == daughter);
    expect(jr.parentCowId, isNull);
  });
}
