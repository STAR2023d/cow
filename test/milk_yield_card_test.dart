import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/screens/widgets/milk_yield_card.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    // Yesterday morning 10 L; today morning 11 L saved at 07:42.
    await db.upsertMilkEntry(
      cowId: cowId,
      date: today
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 7)),
      session: MilkSession.morning,
      amount: 10,
    );
    await db.upsertMilkEntry(
      cowId: cowId,
      date: today.add(const Duration(hours: 7, minutes: 42)),
      session: MilkSession.morning,
      amount: 11,
    );
  });
  tearDown(() => db.close());

  testWidgets('milk saved today at its real time shows on the card', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(body: MilkYieldCard(db: db)),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }

    expect(find.textContaining('not logged yet'), findsNothing);
    expect(find.text('11 L'), findsOneWidget);
    expect(find.textContaining('+10% from yesterday'), findsOneWidget);

    // Drop the card so drift's stream clean-up timer can run.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
