import 'package:cow/database/app_database.dart';

/// One calendar month of the farm's money, in a form that is easy to show
/// on screen and to hand to the AI finance advisor later.
class MonthlyReport {
  /// The first day of the month.
  final DateTime month;
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
  static (DateTime, DateTime) monthBounds(DateTime reference) {
    final start = DateTime(reference.year, reference.month);
    final end = DateTime(reference.year, reference.month + 1, 0, 23, 59, 59);
    return (start, end);
  }

  Future<MonthlyReport> reportFor(DateTime reference) async {
    final (start, end) = monthBounds(reference);

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
      litres: litres,
      milkCash: milkCash,
      otherIncome: otherIncome,
      totalExpenses: totalExpenses,
      expensesByCategory: byCategory,
    );
  }
}
