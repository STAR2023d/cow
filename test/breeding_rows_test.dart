import 'package:cow/breeding/breeding_rows.dart';
import 'package:cow/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dueLabel wording', () {
    expect(dueLabel(-3), '3 days overdue');
    expect(dueLabel(-1), '1 day overdue');
    expect(dueLabel(0), 'today');
    expect(dueLabel(1), 'tomorrow');
    expect(dueLabel(6), 'in 6 days');
  });

  group('buildBreedingRows', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('most urgent first, idle cows last', () async {
      final anna = await db.insertCow(CowCompanion.insert(name: 'Anna'));
      final bella = await db.insertCow(CowCompanion.insert(name: 'Bella'));
      await db.insertCow(CowCompanion.insert(name: 'Cleo'));

      final cycleB = await db.startBreedingCycle(
        cowId: bella,
        heatDate: DateTime(2026, 1, 9),
      );
      await db.recordService(cycleB, DateTime(2026, 1, 10));

      final cycleA = await db.startBreedingCycle(
        cowId: anna,
        heatDate: DateTime(2025, 12, 31),
      );
      await db.recordService(cycleA, DateTime(2026, 1, 1));

      final now = DateTime(2026, 1, 25);
      final rows = buildBreedingRows(
        await db.watchAllCow().first,
        await db.watchAllActiveBreedingCycles().first,
        now: now,
      );

      expect(rows.map((r) => r.cow.name), ['Anna', 'Bella', 'Cleo']);
      expect(rows[0].daysUntilDue(now), -3); // check 1 due 22 Jan
      expect(rows[1].daysUntilDue(now), 6); // check 1 due 31 Jan
      expect(rows[2].stage, isNull);

      expect(rows[0].needsAttention(now), isTrue);
      expect(rows[1].needsAttention(now), isTrue);
      expect(rows[2].needsAttention(now), isFalse);
    });
  });
}
