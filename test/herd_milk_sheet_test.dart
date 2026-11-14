import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/herd_milk_sheet.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int daisy;
  late int bella;
  final now = DateTime(2026, 11, 14, 7, 30); // a morning

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    daisy = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    bella = await db.insertCow(CowCompanion.insert(name: 'Bella'));
    for (var d = 7; d <= 13; d++) {
      await db.upsertMilkEntry(
        cowId: daisy,
        date: DateTime(2026, 11, d, 7),
        session: MilkSession.morning,
        amount: 6,
      );
    }
  });

  tearDown(() => db.close());

  Future<void> openSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HerdMilkSheet(db: db, clock: () => now),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<List<MilkTableData>> onDay(int day) => db.milkEntriesInRange(
    DateTime(2026, 11, day),
    DateTime(2026, 11, day, 23, 59, 59),
  );

  Finder box(int cow) => find.byKey(ValueKey('litres-$cow'));

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

  Future<List<MilkTableData>> saved(WidgetTester tester, int day) async =>
      (await tester.runAsync(() => onDay(day)))!;

  testWidgets('saves the whole herd for this morning', (tester) async {
    await openSheet(tester);
    expect(find.text('Usually about 6 L'), findsOneWidget);
    expect(find.text('No Morning milk in the last 7 days'), findsOneWidget);

    await tester.enterText(box(daisy), '6.5');
    await tester.enterText(box(bella), '5');
    await tester.pump();
    expect(find.text('Save 2 cows: 11.5 L ≈ KSh 575'), findsOneWidget);

    await tester.tap(find.text('Save 2 cows: 11.5 L ≈ KSh 575'));
    await settle(tester);

    final today = await saved(tester, 14);
    expect(today.length, 2);
    expect(today.every((e) => e.session == MilkSession.morning), isTrue);
    expect(
      find.textContaining('Saved Morning milk for 2 cows'),
      findsOneWidget,
    );
  });

  testWidgets('asks about a figure far above usual', (tester) async {
    await openSheet(tester);
    await tester.enterText(box(daisy), '65');
    await tester.pump();
    await tester.tap(find.text('Save 1 cow: 65 L ≈ KSh 3,250'));
    await settle(tester);

    expect(find.text('Check these figures'), findsOneWidget);
    expect(
      find.textContaining('Daisy: 65 L (usually about 6 L)'),
      findsOneWidget,
    );

    await tester.tap(find.text('Go back and fix'));
    await settle(tester);
    expect(await saved(tester, 14), isEmpty);

    await tester.tap(find.text('Save 1 cow: 65 L ≈ KSh 3,250'));
    await settle(tester);
    await tester.tap(find.text('Save anyway'));
    await settle(tester);
    expect((await saved(tester, 14)).single.amount, 65);
  });

  testWidgets('logs yesterday evening on the right day', (tester) async {
    await openSheet(tester);
    await tester.tap(find.text('Yesterday'));
    await settle(tester);
    await tester.tap(find.text('Evening'));
    await settle(tester);
    await tester.enterText(box(bella), '4');
    await tester.pump();
    await tester.tap(find.text('Save 1 cow: 4 L ≈ KSh 200'));
    await settle(tester);

    final evening = (await saved(
      tester,
      13,
    )).where((e) => e.session == MilkSession.evening);
    expect(evening.single.amount, 4);
    expect(evening.single.entryDate, DateTime(2026, 11, 13, 18));
    expect(await saved(tester, 14), isEmpty);
  });

  testWidgets('shows a saved figure and refuses bad input', (tester) async {
    await tester.runAsync(
      () => db.upsertMilkEntry(
        cowId: bella,
        date: DateTime(2026, 11, 14, 6),
        session: MilkSession.morning,
        amount: 5,
      ),
    );
    await openSheet(tester);
    expect(find.textContaining('Saved: 5 L'), findsOneWidget);

    await tester.enterText(box(daisy), 'abc');
    await tester.pump();
    await tester.tap(find.textContaining('Save 1 cow'));
    await settle(tester);

    expect(find.text('Enter a number above 0'), findsOneWidget);
    expect((await saved(tester, 14)).length, 1); // only Bella's earlier entry
  });
}
