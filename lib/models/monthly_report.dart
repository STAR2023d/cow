import 'package:cow/database/app_database.dart';

/// One calendar month of the farm's money, in a form that is easy to show
/// on screen and to hand to the AI finance advisor.
class MonthlyReport {
  /// The first day of the month.
  final DateTime month;

  /// Set when the report only covers the first days of the month (for
  /// example the current month so far). Null means the whole month.
  final int? throughDay;

  final double litres;
  final double milkCash;
  final double otherIncome;
  final double totalExpenses;

  /// Spending per [ExpenseCategory] key.
  final Map<String, double> expensesByCategory;

  const MonthlyReport({
    required this.month,
    required this.litres,
    required this.milkCash,
    required this.otherIncome,
    required this.totalExpenses,
    required this.expensesByCategory,
    this.throughDay,
  });

  double get totalIncome => milkCash + otherIncome;
  double get net => totalIncome - totalExpenses;

  /// Expenses divided by litres produced. Null when no milk was logged.
  double? get costPerLitre => litres > 0 ? totalExpenses / litres : null;

  bool get isEmpty => litres == 0 && totalIncome == 0 && totalExpenses == 0;

  /// Categories that had spending, biggest first.
  List<MapEntry<String, double>> get categoriesBySpend {
    final list = expensesByCategory.entries.where((e) => e.value > 0).toList();
    list.sort((a, b) => b.value.compareTo(a.value));
    return list;
  }
}

class MonthlyReportCalculator {
  final AppDatabase db;
  MonthlyReportCalculator(this.db);

  /// First moment and last moment of the month containing [reference].
  /// With [throughDay], the end is the last moment of that day of the
  /// month instead (kept inside the month, so day 31 in a 30-day month
  /// means the whole month).
  static (DateTime, DateTime) monthBounds(
    DateTime reference, {
    int? throughDay,
  }) {
    final start = DateTime(reference.year, reference.month);
    final lastDay = DateTime(reference.year, reference.month + 1, 0).day;

    var day = lastDay;
    if (throughDay != null) {
      day = throughDay < 1 ? 1 : (throughDay > lastDay ? lastDay : throughDay);
    }

    final end = DateTime(reference.year, reference.month, day, 23, 59, 59);
    return (start, end);
  }

  Future<MonthlyReport> reportFor(DateTime reference, {int? throughDay}) async {
    final (start, end) = monthBounds(reference, throughDay: throughDay);

    final milk = await db.milkEntriesInRange(start, end);
    final litres = milk.fold<double>(0, (sum, m) => sum + m.amount);
    final milkCash = await db.cashInRange(start, end);
    final otherIncome = await db.totalIncomeInRange(start, end);

    final expenses = await db.expensesInRange(start, end);
    final byCategory = <String, double>{};
    var totalExpenses = 0.0;
    for (final e in expenses) {
      byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
      totalExpenses += e.amount;
    }

    return MonthlyReport(
      month: start,
      throughDay: throughDay,
      litres: litres,
      milkCash: milkCash,
      otherIncome: otherIncome,
      totalExpenses: totalExpenses,
      expensesByCategory: byCategory,
    );
  }
}
