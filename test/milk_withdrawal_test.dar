import 'package:cow/database/app_database.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MilkWithdrawal', () {
    final w = MilkWithdrawal(treatedOn: DateTime(2026, 11, 5), days: 3);

    test('runs from the treatment day through day + days', () {
      expect(w.lastWithheldDay, DateTime(2026, 11, 8));
      expect(w.safeFrom, DateTime(2026, 11, 9));
    });

    test('is active on every day of the hold, and only then', () {
      expect(w.isActiveOn(DateTime(2026, 11, 4)), isFalse); // before
      expect(w.isActiveOn(DateTime(2026, 11, 5)), isTrue);
      expect(w.isActiveOn(DateTime(2026, 11, 8, 23, 59)), isTrue);
      expect(w.isActiveOn(DateTime(2026, 11, 9)), isFalse); // safe again
    });

    test('counts the days left, including today', () {
      expect(w.daysLeft(DateTime(2026, 11, 5)), 4);
      expect(w.daysLeft(DateTime(2026, 11, 8)), 1);
      expect(w.daysLeft(DateTime(2026, 11, 9)), 0);
    });

    test('rolls over the end of a month', () {
      final long = MilkWithdrawal(treatedOn: DateTime(2026, 11, 28), days: 5);
      expect(long.lastWithheldDay, DateTime(2026, 12, 3));
      expect(long.safeFrom, DateTime(2026, 12, 4));
    });

    test('ignores the time of day of the treatment', () {
      final evening = MilkWithdrawal(
        treatedOn: DateTime(2026, 11, 5, 18, 30),
        days: 3,
      );
      expect(evening.treatedOn, DateTime(2026, 11, 5));
      expect(evening.safeFrom, DateTime(2026, 11, 9));
    });
  });

  group('milkWithdrawalOf', () {
    late AppDatabase db;
    late int cowId;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    });

    tearDown(() async {
      await db.close();
    });

    test('is saved with the record and read back', () async {
      await db.insertHealthRecord(
        HealthRecordCompanion.insert(
          date: DateTime(2026, 11, 5, 9),
          cowId: cowId,
          recordType: 'Treatment',
          description: 'Mastitis treatment',
          medicine: const Value('Test medicine'),
          milkWithdrawalDays: const Value(3),
        ),
      );

      final record = (await db.watchHealthRecords().first).single;
      final hold = milkWithdrawalOf(record)!;

      expect(record.medicine, 'Test medicine');
      expect(hold.days, 3);
      expect(hold.medicine, 'Test medicine');
      expect(hold.safeFrom, DateTime(2026, 11, 9));
    });

    test('a record without withdrawal days has no hold', () async {
      await db.insertHealthRecord(
        HealthRecordCompanion.insert(
          date: DateTime(2026, 11, 5),
          cowId: cowId,
          recordType: 'Checkup',
          description: 'Routine check',
        ),
      );

      final record = (await db.watchHealthRecords().first).single;

      expect(record.milkWithdrawalDays, isNull);
      expect(milkWithdrawalOf(record), isNull);
    });
  });
}