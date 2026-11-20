import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/screens/expenses_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

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

  Future<double> total(WidgetTester tester) async => (await tester.runAsync(
    () => db.totalExpensesInRange(DateTime(2020), DateTime(2100)),
  ))!;

  testWidgets('save, change and delete an expense; totals follow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: ExpenseEntryScreen(db: db),
      ),
    );
    await settle(tester);
    expect(find.text('No expenses saved yet.'), findsOneWidget);

    // New expense; Feed is the default category.
    await tester.enterText(find.byType(TextFormField).at(0), 'Dairy meal');
    await tester.enterText(find.byType(TextFormField).at(1), '2500');
    await tester.tap(find.text('Save expense'));
    await settle(tester);
    var saved = (await tester.runAsync(() => db.watchExpenses().first))!.single;
    expect(saved.category, 'feed');
    expect(await total(tester), 2500);
    expect(find.text('Dairy meal'), findsOneWidget);

    // Tap it, fix the amount.
    await tester.tap(find.text('Dairy meal'));
    await tester.pumpAndSettle();
    expect(find.text('Editing expense'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), '250');
    await tester.tap(find.text('Save changes'));
    await settle(tester);
    saved = (await tester.runAsync(() => db.watchExpenses().first))!.single;
    expect(saved.amount, 250);
    expect(await total(tester), 250);

    // Delete it: gone from the totals the statement uses.
    await tester.tap(find.byTooltip('Delete'));
    await settle(tester);
    expect(await total(tester), 0);
    expect(find.text('No expenses saved yet.'), findsOneWidget);

    // Close the live list before the database closes.
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
