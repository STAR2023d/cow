import 'package:cow/database/app_database.dart';
import 'package:cow/models/buyer_earnings.dart';
import 'package:cow/models/monthly_report.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

MilkTableData _milk(String id, DateTime date, double litres, String? buyer) =>
    MilkTableData(
      id: id,
      entryDate: date,
      session: MilkSession.morning,
      amount: litres,
      cowId: 1,
      buyer: buyer,
    );

void main() {
  group('earningsByBuyer', () {
    // 50 a litre before the 10th, 60 from the 10th.
    Future<double> price(DateTime day) async => day.day < 10 ? 50 : 60;

    test('groups by buyer ignoring case and spaces, priced per day', () async {
      final r = await earningsByBuyer([
        _milk('a', DateTime(2026, 11, 1, 7), 10, 'Githunguri Dairy'),
        _milk('b', DateTime(2026, 11, 12, 7), 10, ' githunguri  dairy '),
        _milk('c', DateTime(2026, 11, 12, 18), 5, 'Hotel'),
      ], price);

      expect(r.map((b) => b.buyer), ['Githunguri Dairy', 'Hotel']);
      expect(r[0].litres, 20);
      expect(r[0].cash, 10 * 50 + 10 * 60);
      expect(r[1].cash, 5 * 60);
    });

    test('entries with no buyer are grouped last, even when biggest', () async {
      final r = await earningsByBuyer([
        _milk('a', DateTime(2026, 11, 1), 2, 'Neighbour'),
        _milk('b', DateTime(2026, 11, 2), 30, null),
        _milk('c', DateTime(2026, 11, 3), 5, '   '),
      ], price);

      expect(r.map((b) => b.buyer), ['Neighbour', null]);
      expect(r.last.litres, 35);
    });

    test('nothing in, nothing out', () async {
      expect(await earningsByBuyer(const [], price), isEmpty);
    });
  });

  test('monthly report buyer totals add up to milk income', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.setPricePerLitre(50, effectiveDate: DateTime(2026, 10, 1));
    await db.setPricePerLitre(60, effectiveDate: DateTime(2026, 11, 10));
    final cow = await db.insertCow(CowCompanion.insert(name: 'Daisy'));

    Future<void> milk(DateTime d, String s, double l, [String? buyer]) =>
        db.upsertMilkEntry(
          cowId: cow,
          date: d,
          session: s,
          amount: l,
          buyer: buyer,
        );
    await milk(DateTime(2026, 11, 2, 7), MilkSession.morning, 8, 'Co-op');
    await milk(DateTime(2026, 11, 2, 18), MilkSession.evening, 4);
    await milk(DateTime(2026, 11, 12, 7), MilkSession.morning, 6, 'Hotel');

    final report = await MonthlyReportCalculator(
      db,
    ).reportFor(DateTime(2026, 11, 15));

    expect(report.hasBuyers, isTrue);
    expect(report.earningsByBuyer.map((b) => b.buyer), [
      'Co-op', // 400
      'Hotel', // 360
      null, // 200
    ]);
    final sum = report.earningsByBuyer.fold<double>(0, (s, b) => s + b.cash);
    expect(sum, closeTo(report.milkCash, 0.001));
  });
}
