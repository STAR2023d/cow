import 'package:cow/database/app_database.dart';
import 'package:cow/models/period_runner.dart';
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

  Future<void> addCalfSaleIncome(double amount, DateTime date) async {
    await db.insertIncome(
      LedgerEntriesCompanion.insert(
        type: 'income',
        category: 'calf_sale',
        amount: amount,
        date: Value(date),
      ),
    );
  }

  test('calf sale income is part of the statement', () async {
    await db.upsertMilkEntry(
      cowId: cowId,
      date: DateTime(2026, 11, 5, 6, 30),
      session: MilkSession.morning,
      amount: 10,
    );
    await db.insertExpense(
      ExpensesCompanion.insert(
        date: DateTime(2026, 11, 6),
        description: 'Dairy meal',
        amount: 100,
      ),
    );
    await addCalfSaleIncome(5000, DateTime(2026, 11, 7));

    final s = await StatementCalculator(db).statementFor(DateTime(2026, 11, 7));

    expect(s.totalMilkCash, 600); // 10 L x 60
    expect(s.otherIncome, 5000);
    expect(s.totalExpenses, 100);
    expect(s.netForPeriod, 5500);
    expect(s.openingBalance, 0);
    expect(s.closingBalance, 5500);
    expect(s.incomeRecords.length, 1);
    expect(s.incomeRecords.first.category, 'calf_sale');
  });

  test('income carries into the next period\'s opening balance', () async {
    await db.upsertMilkEntry(
      cowId: cowId,
      date: DateTime(2026, 11, 5, 6, 30),
      session: MilkSession.morning,
      amount: 10,
    );
    await db.insertExpense(
      ExpensesCompanion.insert(
        date: DateTime(2026, 11, 6),
        description: 'Dairy meal',
        amount: 100,
      ),
    );
    await addCalfSaleIncome(5000, DateTime(2026, 11, 7));

    final next = await StatementCalculator(
      db,
    ).statementFor(DateTime(2026, 11, 20));

    expect(next.openingBalance, 5500);
    expect(next.otherIncome, 0);
    expect(next.closingBalance, 5500);
  });

  test('a calf sale recorded the real way shows up in the statement', () async {
    final cycleId = await db.startBreedingCycle(
      cowId: cowId,
      heatDate: DateTime(2026, 1, 1),
    );
    await db.sellCalf(
      cycleId: cycleId,
      cowId: cowId,
      amount: 8000,
      saleDate: DateTime(2026, 11, 10),
    );

    final s = await StatementCalculator(
      db,
    ).statementFor(DateTime(2026, 11, 10));

    expect(s.otherIncome, 8000);
    expect(s.closingBalance, 8000);
    expect(s.incomeRecords.single.category, 'calf_sale');
  });
}
