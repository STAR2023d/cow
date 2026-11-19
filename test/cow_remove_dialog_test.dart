import 'package:cow/abstract/dialog_deletion.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/screens/left_herd_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CowData daisy;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final id = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    daisy = (await db.allCows()).firstWhere((c) => c.id == id);
  });
  tearDown(() => db.close());

  Widget app(Widget home) => MaterialApp(
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: home,
  );

  // Database calls need real time; the test clock is fake. Let them run,
  // then draw the result.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (_) => CowRemoveDialog(
                  cow: daisy,
                  recordCount: () => db.cowRecordCount(daisy.id),
                  onLeft: (r, on) => db.removeFromHerd(daisy.id, r, on),
                  onDelete: () => db.deleteCow(daisy.id),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('left the farm: pick a reason, cow keeps her row', (
    tester,
  ) async {
    await openDialog(tester);
    await tester.tap(find.text('She left the farm'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Died'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(find.byType(CowRemoveDialog), findsNothing);
    final cow = (await tester.runAsync(db.allCows))!.single;
    expect(cow.leftReason, 'died');
    expect(cow.leftOn, isNotNull);
  });

  testWidgets('added by mistake: shows the record count before deleting', (
    tester,
  ) async {
    await openDialog(tester);
    await tester.tap(find.text('Added by mistake: delete'));
    await settle(tester);
    expect(find.textContaining('Daisy and 0 records'), findsOneWidget);

    await tester.tap(find.text('Delete for good'));
    await settle(tester);
    expect(await tester.runAsync(db.allCows), isEmpty);
  });

  testWidgets('Left the herd lists her and can bring her back', (tester) async {
    await tester.runAsync(
      () => db.removeFromHerd(daisy.id, 'sold', DateTime(2026, 11, 12)),
    );
    await tester.pumpWidget(app(LeftHerdScreen(db: db)));
    await settle(tester);
    expect(find.text('Sold · 12 Nov 2026'), findsOneWidget);

    await tester.tap(find.text('Return to herd'));
    await settle(tester);
    expect(find.text('No cows have left the herd.'), findsOneWidget);
    expect((await tester.runAsync(db.herdCows))!.length, 1);

    // Close the live list before the database closes.
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
