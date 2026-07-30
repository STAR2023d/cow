

import 'package:cow/database/app_database.dart';

class PeriodStatement {
  final DateTime periodStart;
  final DateTime periodEnd;
  final double openingBalance;
  final double totalMilkCash;
  final double totalExpenses;
  final List<MilkRecord> milkRecords;
  final List<Expense> expenseRecords;

  PeriodStatement({
    required this.periodStart,
    required this.periodEnd,
    required this.openingBalance,
    required this.totalMilkCash,
    required this.totalExpenses,
    required this.milkRecords,
    required this.expenseRecords,
  });

  double get closingBalance => openingBalance + totalMilkCash - totalExpenses;
  double get netForPeriod => totalMilkCash - totalExpenses;
}

class StatementCalculator {
  final AppDatabase db;
  StatementCalculator(this.db);

  /// Returns the (start, end) date pair for the half-month period
  /// containing [reference]. Day 1-15 = first half, 16-end = second half.
  static (DateTime, DateTime) periodBoundsFor(DateTime reference) {
    final year = reference.year;
    final month = reference.month;
    if (reference.day <= 15) {
      return (DateTime(year, month, 1), DateTime(year, month, 15, 23, 59, 59));
    }
    final lastDay = DateTime(year, month + 1, 0).day;
    return (
      DateTime(year, month, 16),
      DateTime(year, month, lastDay, 23, 59, 59),
    );
  }

  /// Opening balance = closing balance of the immediately preceding period.
  /// Walks backward one period at a time; returns 0 once no records exist
  /// before [periodStart] (i.e. the very first tracked period).
  Future<double> _openingBalanceFor(DateTime periodStart) async {
    final priorPeriodEnd = periodStart.subtract(const Duration(seconds: 1));
    final (priorStart, _) = periodBoundsFor(priorPeriodEnd);

    final milk = await db.milkRecordsInRange(priorStart, priorPeriodEnd);
    final exp = await db.expensesInRange(priorStart, priorPeriodEnd);

    if (milk.isEmpty && exp.isEmpty) {
      // No activity before this period at all — treat as the start of books.
      final earliestMilk = await db.milkRecordsInRange(
          DateTime(2000), periodStart.subtract(const Duration(seconds: 1)));
      final earliestExp = await db.expensesInRange(
          DateTime(2000), periodStart.subtract(const Duration(seconds: 1)));
      if (earliestMilk.isEmpty && earliestExp.isEmpty) return 0.0;
    }

    final priorOpening = await _openingBalanceFor(priorStart);
    final milkCash = milk.fold<double>(0, (s, r) => s + r.litres * r.pricePerLitre);
    final expTotal = exp.fold<double>(0, (s, e) => s + e.amount);
    return priorOpening + milkCash - expTotal;
  }

  Future<PeriodStatement> statementFor(DateTime reference) async {
    final (start, end) = periodBoundsFor(reference);
    final milk = await db.milkRecordsInRange(start, end);
    final exp = await db.expensesInRange(start, end);

    final milkCash = milk.fold<double>(0, (s, r) => s + r.litres * r.pricePerLitre);
    final expTotal = exp.fold<double>(0, (s, e) => s + e.amount);
    final opening = await _openingBalanceFor(start);

    return PeriodStatement(
      periodStart: start,
      periodEnd: end,
      openingBalance: opening,
      totalMilkCash: milkCash,
      totalExpenses: expTotal,
      milkRecords: milk,
      expenseRecords: exp,
    );
  }
}