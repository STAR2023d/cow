import 'dart:io';

import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/screens/widgets/erase_data_dialog.dart';
import 'package:cow/services/erase_data.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('erase saves a backup, then empties every table and photos', () async {
    SharedPreferences.setMockInitialValues({'milk_price_set': true});
    final dir = Directory.systemTemp.createTempSync('cow_erase_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = AppDatabase(NativeDatabase(File('${dir.path}/db.sqlite')));
    addTearDown(db.close);

    final cow = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    await db.upsertMilkEntry(
      cowId: cow,
      date: DateTime(2026, 11, 20, 7),
      session: MilkSession.morning,
      amount: 6,
    );
    await db.insertExpense(
      ExpensesCompanion.insert(
        date: DateTime(2026, 11, 20),
        description: 'Dairy meal',
        amount: 2500,
      ),
    );
    final photo = File('${dir.path}/cow_photos/a.jpg')
      ..createSync(recursive: true);

    final backup = await eraseAllFarmData(
      db,
      folder: dir,
      now: DateTime(2026, 11, 20, 22, 5),
    );

    expect(
      backup,
      endsWith('my_database.before-erase-2026-11-20-220500.sqlite'),
    );
    for (final t in db.allTables) {
      expect(await db.select(t).get(), isEmpty, reason: t.actualTableName);
    }
    expect(photo.existsSync(), isFalse);
    expect(
      (await SharedPreferences.getInstance()).getBool('milk_price_set'),
      isNull,
    );
    // Numbering starts again.
    expect(await db.insertCow(CowCompanion.insert(name: 'New')), 1);

    // The backup still has the old records.
    final old = AppDatabase(NativeDatabase(File(backup)));
    addTearDown(old.close);
    expect((await old.allCows()).single.name, 'Daisy');
    expect(await old.select(old.milkTable).get(), hasLength(1));
  });

  testWidgets('erase button works only after typing the word', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var erased = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: EraseDataDialog(db: db, erase: () async => erased = true),
        ),
      ),
    );
    FilledButton button() => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Erase everything'),
    );
    expect(button().onPressed, isNull);
    await tester.enterText(find.byKey(const ValueKey('erase-confirm')), 'eras');
    await tester.pump();
    expect(button().onPressed, isNull);
    await tester.enterText(
      find.byKey(const ValueKey('erase-confirm')),
      'erase',
    );
    await tester.pump();
    expect(button().onPressed, isNotNull);
    await tester.tap(find.text('Erase everything'));
    await tester.pump();
    expect(erased, isTrue);
  });
}
