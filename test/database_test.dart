import 'package:cow/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  final day = DateTime(2026, 11, 4, 6, 30);

  test(
    'logging the same cow/day/session twice updates, not duplicates',
    () async {
      final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));

      await db.upsertMilkEntry(
        cowId: cowId,
        date: day,
        session: MilkSession.morning,
        amount: 5,
      );
      await db.upsertMilkEntry(
        cowId: cowId,
        date: day,
        session: MilkSession.morning,
        amount: 7,
      );

      final all = await db.watchAllEntries().first;
      expect(all.length, 1);
      expect(all.first.amount, 7);
    },
  );

  test('morning and afternoon are separate entries that add up', () async {
    final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));

    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.morning,
      amount: 5,
    );
    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.afternoon,
      amount: 7,
    );

    final all = await db.watchAllEntries().first;
    expect(all.length, 2);
    expect(await db.watchCowDailyTotal(cowId, day).first, 12);
  });

  test('buyer is saved, and a blank buyer keeps the earlier one', () async {
    final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    final day = DateTime(2026, 5, 1, 7);

    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.morning,
      amount: 5,
      buyer: '  Githunguri Dairy ',
    );
    var entry = await db.select(db.milkTable).getSingle();
    expect(entry.buyer, 'Githunguri Dairy');

    // Correcting the amount without a buyer keeps the stored buyer.
    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.morning,
      amount: 6,
      buyer: '',
    );
    entry = await db.select(db.milkTable).getSingle();
    expect(entry.amount, 6);
    expect(entry.buyer, 'Githunguri Dairy');

    // A different buyer replaces it.
    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.morning,
      amount: 6,
      buyer: 'Hotel',
    );
    entry = await db.select(db.milkTable).getSingle();
    expect(entry.buyer, 'Hotel');

    // No buyer at all on a new entry stays null.
    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.evening,
      amount: 4,
    );
    final evening = await (db.select(
      db.milkTable,
    )..where((t) => t.session.equals(MilkSession.evening))).getSingle();
    expect(evening.buyer, isNull);
  });

  test('price history picks the latest price effective on that date', () async {
    await db.setPricePerLitre(60, effectiveDate: DateTime(2026, 11, 1));

    expect(await db.priceForDate(DateTime(2026, 11, 4)), 60);
    // Before any price existed, it falls back to the default of 50.
    expect(await db.priceForDate(DateTime(2026, 10, 1)), 50);
  });

  test('cash for a day is litres multiplied by that day\'s price', () async {
    final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    await db.setPricePerLitre(60, effectiveDate: DateTime(2026, 11, 1));

    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.morning,
      amount: 5,
    );
    await db.upsertMilkEntry(
      cowId: cowId,
      date: day,
      session: MilkSession.evening,
      amount: 7,
    );

    expect(await db.cashForDate(day), 720); // 12 L x 60
  });
}
