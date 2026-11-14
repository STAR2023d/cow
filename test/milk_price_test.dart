import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_price.dart';
import 'package:cow/screens/widgets/milk_price_card.dart';
import 'package:cow/screens/widgets/set_price_dialog.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('price setting', () {
    test('a price set later in the day covers that morning\'s milk', () async {
      // Set at 14:00, milk was at 07:00 the same day.
      await db.setPricePerLitre(55, effectiveDate: DateTime(2026, 11, 14, 14));
      expect(await db.priceForDate(DateTime(2026, 11, 14, 7)), 55);
    });

    test('earlier milk keeps its old price', () async {
      await db.setPricePerLitre(50, effectiveDate: DateTime(2026, 10, 1));
      await db.setPricePerLitre(55, effectiveDate: DateTime(2026, 11, 1));
      expect(await db.priceForDate(DateTime(2026, 10, 31, 18)), 50);
      expect(await db.priceForDate(DateTime(2026, 11, 1, 7)), 55);
    });

    test('setting a price twice on one day replaces it', () async {
      await db.setPricePerLitre(55, effectiveDate: DateTime(2026, 11, 1));
      await db.setPricePerLitre(58, effectiveDate: DateTime(2026, 11, 1, 9));
      final history = await db.watchPriceHistory().first;
      final nov1 = history.where(
        (p) => p.effectiveDate == DateTime(2026, 11, 1),
      );
      expect(nov1.single.pricePerLitre, 58);
    });

    test('history is newest first; current skips upcoming prices', () async {
      await db.setPricePerLitre(50, effectiveDate: DateTime(2026, 10, 1));
      await db.setPricePerLitre(55, effectiveDate: DateTime(2026, 11, 1));
      await db.setPricePerLitre(60, effectiveDate: DateTime(2026, 12, 1));
      final history = await db.watchPriceHistory().first;
      expect(history.first.pricePerLitre, 60);
      expect(currentPrice(history, DateTime(2026, 11, 14))!.pricePerLitre, 55);
    });

    test('a deleted price can be restored', () async {
      await db.setPricePerLitre(55, effectiveDate: DateTime(2026, 11, 1));
      // Pick ours: the built-in KSh 50 row is dated today, so it is newer.
      final row = (await db.watchPriceHistory().first).firstWhere(
        (p) => p.pricePerLitre == 55,
      );
      await db.deletePrice(row.id);
      expect(await db.priceForDate(DateTime(2026, 11, 2)), isNot(55));
      await db.restorePrice(row);
      expect(await db.priceForDate(DateTime(2026, 11, 2)), 55);
    });
  });

  testWidgets('dialog returns the price and the day it applies from', (
    tester,
  ) async {
    NewPrice? result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showDialog<NewPrice>(
              context: context,
              builder: (_) =>
                  SetPriceDialog(current: 50, today: DateTime(2026, 11, 14)),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Now: KSh 50.00 per litre'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a price above 0'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '55.5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(result, (price: 55.5, from: DateTime(2026, 11, 14)));
  });

  PriceSetting price(int id, double kes, DateTime from) =>
      PriceSetting(id: id, effectiveDate: from, pricePerLitre: kes);

  Future<void> pumpCard(
    WidgetTester tester, {
    required bool isSet,
    required List<PriceSetting> history,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: MilkPriceCard(
            db: db,
            isSet: () async => isSet,
            history: Stream.value(history),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('dashboard asks for the price until it is set', (tester) async {
    await pumpCard(
      tester,
      isSet: false,
      history: [price(1, 50, DateTime(2026, 11, 14, 9))],
    );
    expect(find.text('Set your milk price'), findsOneWidget);
  });

  testWidgets('dashboard shows the price once set', (tester) async {
    await pumpCard(
      tester,
      isSet: true,
      history: [price(2, 55, DateTime(2026, 11, 1))],
    );
    expect(find.text('Milk price: KSh 55 per litre'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
  });
}
