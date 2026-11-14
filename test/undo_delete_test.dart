import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('restore puts the same row back', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('milk entry', () async {
      final cow = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
      await db.upsertMilkEntry(
        cowId: cow,
        date: DateTime(2026, 11, 14, 7),
        session: MilkSession.morning,
        amount: 6.5,
        buyer: 'KCC',
      );
      final before = (await db.watchAllEntries().first).single;

      await db.deleteMilkEntry(before.id);
      expect(await db.watchAllEntries().first, isEmpty);
      await db.restoreMilkEntry(before);

      expect((await db.watchAllEntries().first).single, before);
    });

    test('feeding record', () async {
      final id = await db.insertFeedingLog(
        FeedingLogCompanion.insert(
          date: DateTime(2026, 11, 14),
          feedType: 'Dairy meal',
          quantityKg: 4,
          notes: const Value('morning'),
        ),
      );
      final row = (await db.select(db.feedingLog).get()).single;
      await db.deleteFeedingLog(id);
      await db.restoreFeedingLog(row);
      expect((await db.select(db.feedingLog).get()).single, row);
    });
  });

  testWidgets('deletes at once and Undo restores', (tester) async {
    var deleted = 0, restored = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => deleteWithUndo(
                context,
                what: 'Feeding record',
                delete: () async => deleted++,
                restore: () async => restored++,
              ),
              child: const Text('delete'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('delete'));
    await tester.pumpAndSettle();
    expect(deleted, 1);
    expect(find.text('Feeding record deleted'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(restored, 1);
  });

  testWidgets('the message goes away by itself', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => deleteWithUndo(
                context,
                what: 'Health record',
                delete: () async {},
                restore: () async {},
              ),
              child: const Text('delete'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('delete'));
    await tester.pumpAndSettle();
    expect(find.text('Health record deleted'), findsOneWidget);

    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    expect(find.text('Health record deleted'), findsNothing);
  });
}
