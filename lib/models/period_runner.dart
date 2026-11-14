import 'package:cow/database/app_database.dart';

class PeriodStatement {
  final DateTime periodStart;
  final DateTime periodEnd;
  final double openingBalance;
  final double totalMilkCash;

  /// Money in from sources other than milk, such as calf sales.
  final double otherIncome;
  final double totalExpenses;
  final List<MilkTableData> milkRecords;
  final List<LedgerEntry> incomeRecords;
  final List<Expense> expenseRecords;

  /// Price-per-litre used for each day in [milkRecords], keyed by
  /// midnight of that day. Prices now live in PriceSettings (looked up
  /// per date) rather than being stored on the milk record itself, so
  /// the UI needs this to show a per-record cash value without an
  /// async lookup per row. Use [cashFor] instead of reading this map
  /// directly.
  final Map<DateTime, double> priceByDay;

  PeriodStatement({
    required this.periodStart,
    required this.periodEnd,
    required this.openingBalance,
    required this.totalMilkCash,
    required this.otherIncome,
    required this.totalExpenses,
    required this.milkRecords,
    required this.incomeRecords,
    required this.expenseRecords,
    required this.priceByDay,
  });

  double get netForPeriod => totalMilkCash + otherIncome - totalExpenses;
  double get closingBalance => openingBalance + netForPeriod;

  /// Cash value of a single milk record, using that day's price.
  double cashFor(MilkTableData record) {
    final day = DateTime(
      record.entryDate.year,
      record.entryDate.month,
      record.entryDate.day,
    );
    return record.amount * (priceByDay[day] ?? 0);
  }
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

    final milk = await db.milkEntriesInRange(priorStart, priorPeriodEnd);
    final exp = await db.expensesInRange(priorStart, priorPeriodEnd);
    final income = await db.incomeEntriesInRange(priorStart, priorPeriodEnd);

    if (milk.isEmpty && exp.isEmpty && income.isEmpty) {
      // No activity in the previous period: is there anything earlier at
      // all? If not, this is the start of the books.
      final earliest = DateTime(2000);
      final before = periodStart.subtract(const Duration(seconds: 1));
      final earlierMilk = await db.milkEntriesInRange(earliest, before);
      final earlierExp = await db.expensesInRange(earliest, before);
      final earlierIncome = await db.incomeEntriesInRange(earliest, before);
      if (earlierMilk.isEmpty && earlierExp.isEmpty && earlierIncome.isEmpty) {
        return 0.0;
      }
    }

    final priorOpening = await _openingBalanceFor(priorStart);
    final milkCash = await db.cashInRange(priorStart, priorPeriodEnd);
    final incomeTotal = await db.totalIncomeInRange(priorStart, priorPeriodEnd);
    final expTotal = await db.totalExpensesInRange(priorStart, priorPeriodEnd);
    return priorOpening + milkCash + incomeTotal - expTotal;
  }

  Future<PeriodStatement> statementFor(DateTime reference) async {
    final (start, end) = periodBoundsFor(reference);
    final milk = await db.milkEntriesInRange(start, end);
    final exp = await db.expensesInRange(start, end);
    final income = await db.incomeEntriesInRange(start, end);

    final milkCash = await db.cashInRange(start, end);
    final incomeTotal = await db.totalIncomeInRange(start, end);
    final expTotal = await db.totalExpensesInRange(start, end);
    final opening = await _openingBalanceFor(start);

    // One price lookup per distinct day in the period, not per record.
    final priceByDay = <DateTime, double>{};
    for (final r in milk) {
      final day = DateTime(
        r.entryDate.year,
        r.entryDate.month,
        r.entryDate.day,
      );
      priceByDay[day] ??= await db.priceForDate(day);
    }

    return PeriodStatement(
      periodStart: start,
      periodEnd: end,
      openingBalance: opening,
      totalMilkCash: milkCash,
      otherIncome: incomeTotal,
      totalExpenses: expTotal,
      milkRecords: milk,
      incomeRecords: income,
      expenseRecords: exp,
      priceByDay: priceByDay,
    );
  }
}

/// Label for an income category, e.g. 'calf_sale' -> 'Calf sale'.
String incomeLabel(String category) {
  if (category == 'calf_sale') return 'Calf sale';
  final words = category.replaceAll('_', ' ');
  if (words.isEmpty) return 'Income';
  return words[0].toUpperCase() + words.substring(1);
}
