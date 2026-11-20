import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/screens/milk_entry.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late AppDatabase db;
  late int daisy;
  final now = DateTime(2026, 11, 14, 7, 30);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    daisy = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    await db.setInMilk(daisy, false);
  });
  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('cow screen uses the shared form: day, session, list switch', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Provider<AppDatabase>.value(
        value: db,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: MilkData(cowId: daisy, cowName: 'Daisy', clock: () => now),
        ),
      ),
    );
    await settle(tester);

    // Off the milking list, but her own screen still logs her milk.
    expect(find.byKey(ValueKey('litres-$daisy')), findsOneWidget);
    await tester.tap(find.text('Yesterday'));
    await settle(tester);
    await tester.tap(find.text('Evening'));
    await settle(tester);
    await tester.enterText(find.byKey(ValueKey('litres-$daisy')), '4.5');
    await tester.pump();
    await tester.tap(find.textContaining('Save 1 cow'));
    await settle(tester);

    final e = (await tester.runAsync(
      () => db.milkEntriesInRange(
        DateTime(2026, 11, 13),
        DateTime(2026, 11, 13, 23, 59),
      ),
    ))!.single;
    expect(e.session, MilkSession.evening);
    expect(e.amount, 4.5);
    expect(find.text('Saved: 4.5 L'), findsOneWidget);
    expect(find.text('4.5 L'), findsOneWidget); // history card

    // Put her back on the milking list from here.
    await tester.tap(find.byKey(const ValueKey('on-milking-list')));
    await settle(tester);
    final cows = await tester.runAsync(db.allCows);
    expect(cows!.single.inMilk, isTrue);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
