import 'package:cow/database/app_database.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> cow(String name) => db.insertCow(CowCompanion.insert(name: name));

  Future<void> treat(int cowId, DateTime date, int? days) =>
      db.insertHealthRecord(
        HealthRecordCompanion.insert(
          date: date,
          cowId: cowId,
          recordType: 'Treatment',
          description: 'test',
          milkWithdrawalDays: Value(days),
        ),
      );

  test('lists cows still on hold, soonest to end first', () async {
    final daisy = await cow('Daisy');
    final bella = await cow('Bella');
    final cleo = await cow('Cleo');

    await treat(daisy, DateTime(2026, 11, 5), 3); // safe from 9 Nov
    await treat(daisy, DateTime(2026, 11, 6), 5); // safe from 12 Nov (wins)
    await treat(bella, DateTime(2026, 10, 1), 3); // long over
    await treat(cleo, DateTime(2026, 11, 6), 2); // safe from 9 Nov

    final records = await db.watchWithdrawalRecords().first;
    final holds = activeHolds(records, DateTime(2026, 11, 7));

    expect(holds.map((h) => h.cowId), [cleo, daisy]);
    expect(holds.last.withdrawal.safeFrom, DateTime(2026, 11, 12));
  });

  test('records without withdrawal days are left out', () async {
    final daisy = await cow('Daisy');
    await treat(daisy, DateTime(2026, 11, 5), null);

    final records = await db.watchWithdrawalRecords().first;

    expect(records, isEmpty);
    expect(activeHolds(records, DateTime(2026, 11, 7)), isEmpty);
  });
}
