import 'package:cow/database/app_database.dart';
import 'package:cow/models/expense_category.dart';
import 'package:cow/models/monthly_report.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int cowId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.setPricePerLitre(60, effectiveDate: DateTime(2026, 11, 1));
    cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> milk(DateTime date, double litres) => db.upsertMilkEntry(
    cowId: cowId,
    date: date,
    session: MilkSession.morning,
    amount: litres,
  );

  Future<void> spend(DateTime date, String category, double amount) =>
      db.insertExpense(
        ExpensesCompanion.insert(
          date: date,
          description: 'test',
          amount: amount,
          category: Value(category),
        ),
      );

  test('totals a month of milk, income and spending', () async {
    await milk(DateTime(2026, 11, 5, 6, 30), 10);
    await milk(DateTime(2026, 11, 20, 6, 30), 5);
    await spend(DateTime(2026, 11, 6), ExpenseCategory.feed, 600);
    await spend(DateTime(2026, 11, 25), ExpenseCategory.vet, 200);
    await spend(DateTime(2026, 11, 30, 23, 30), ExpenseCategory.other, 100);
    await db.insertIncome(
      LedgerEntriesCompanion.insert(
        type: 'income',
        category: 'calf_sale',
        amount: 5000,
        date: Value(DateTime(2026, 11, 12)),
      ),
    );

    final r = await MonthlyReportCalculator(
      db,
    ).reportFor(DateTime(2026, 11, 14));

    expect(r.month, DateTime(2026, 11));
    expect(r.litres, 15);
    expect(r.milkCash, 900); // 15 L x 60
    expect(r.otherIncome, 5000);
    expect(r.totalIncome, 5900);
    expect(r.totalExpenses, 900);
    expect(r.net, 5000);
    expect(r.costPerLitre, 60); // 900 / 15
    expect(r.expensesByCategory, {'feed': 600.0, 'vet': 200.0, 'other': 100.0});
    expect(r.categoriesBySpend.map((e) => e.key), ['feed', 'vet', 'other']);
  });

  test('only counts entries inside the month', () async {
    await spend(DateTime(2026, 10, 31, 23, 59), ExpenseCategory.feed, 111);
    await spend(DateTime(2026, 11, 1), ExpenseCategory.feed, 222);
    await spend(DateTime(2026, 11, 30, 23, 59), ExpenseCategory.feed, 333);
    await spend(DateTime(2026, 12, 1), ExpenseCategory.feed, 444);

    final r = await MonthlyReportCalculator(
      db,
    ).reportFor(DateTime(2026, 11, 1));

    expect(r.totalExpenses, 555); // 222 + 333
  });

  test('december works across the year end', () async {
    await spend(DateTime(2026, 12, 31, 12), ExpenseCategory.labour, 400);
    await spend(DateTime(2027, 1, 1), ExpenseCategory.labour, 999);

    final r = await MonthlyReportCalculator(
      db,
    ).reportFor(DateTime(2026, 12, 20));

    expect(r.totalExpenses, 400);
  });

  test('a month with no milk has no cost per litre', () async {
    await spend(DateTime(2026, 11, 6), ExpenseCategory.feed, 600);

    final r = await MonthlyReportCalculator(
      db,
    ).reportFor(DateTime(2026, 11, 6));

    expect(r.litres, 0);
    expect(r.costPerLitre, isNull);
    expect(r.isEmpty, isFalse);
  });

  test('an empty month is empty', () async {
    final r = await MonthlyReportCalculator(
      db,
    ).reportFor(DateTime(2026, 9, 10));

    expect(r.isEmpty, isTrue);
    expect(r.categoriesBySpend, isEmpty);
  });
}
