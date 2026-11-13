import 'dart:io';

import 'package:cow/database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('cow_migration_');
    file = File('${dir.path}/db.sqlite');
  });

  tearDown(() => dir.deleteSync(recursive: true));

  /// Builds a v9 database on disk with one cow and one milk entry: create
  /// the current schema, remove what v10 added, write the data, and mark
  /// it as version 9. The next open must run the v9 -> v10 upgrade.
  Future<void> makeV9Database() async {
    final db = AppDatabase(NativeDatabase(file));
    await db.customStatement('DROP TABLE calves');
    await db.customStatement('ALTER TABLE milk_table DROP COLUMN buyer');
    await db.customStatement("INSERT INTO cow (id, name) VALUES (1, 'Daisy')");
    await db.customStatement(
      'INSERT INTO milk_table (id, entry_date, session, amount, cow_id) '
      "VALUES ('old', 0, 'Morning', 4.5, 1)",
    );
    await db.customStatement('PRAGMA user_version = 9');
    await db.close();
  }

  Future<List<String>> columns(AppDatabase db, String table) async {
    final rows = await db.customSelect('PRAGMA table_info($table)').get();
    return [for (final r in rows) r.read<String>('name')];
  }

  test('a v9 database upgrades to v10 and keeps its data', () async {
    await makeV9Database();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    expect(await columns(db, 'milk_table'), contains('buyer'));
    expect(await columns(db, 'calves'), containsAll(['sex', 'bought_in']));
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 10);

    // Old rows survive, with no buyer.
    final old = await db.select(db.milkTable).getSingle();
    expect(old.amount, 4.5);
    expect(old.buyer, isNull);

    // The new table works.
    final id = await db.insertCalf(
      CalvesCompanion.insert(
        dateOfBirth: DateTime(2026, 6, 1),
        sex: 'female',
        damCowId: const Value(1),
        boughtIn: const Value(true),
      ),
    );
    await db.updateCalf(id, const CalvesCompanion(birthWeightKg: Value(32)));
    final calf = (await db.watchCalves().first).single;
    expect(calf.birthWeightKg, 32);
    expect(calf.boughtIn, isTrue);
    expect(calf.notes, isNull);
  });
}
