import 'package:cow/database/app_database.dart';
import 'package:cow/models/expense_category.dart';
import 'package:cow/models/monthly_report.dart';
import 'package:cow/screens/widgets/finance_advisor_card.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A month and the one before it (for comparison).
class _MonthData {
  final MonthlyReport current;

  /// Null when nothing was recorded in the earlier month.
  final MonthlyReport? previous;

  const _MonthData(this.current, this.previous);
}

/// A month of the farm's money at a glance: income, expenses, profit,
/// cost per litre, and where the spending went.
class MonthlyReportScreen extends StatefulWidget {
  final AppDatabase db;

  const MonthlyReportScreen({super.key, required this.db});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  late final MonthlyReportCalculator _calc;
  late DateTime _month;
  late Future<_MonthData> _future;

  @override
  void initState() {
    super.initState();
    _calc = MonthlyReportCalculator(widget.db);
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _future = _load(_month);
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _month.year == now.year && _month.month == now.month;
  }

  /// Loads [month] and the month before it. For the month in progress, the
  /// earlier month is cut off at the same day so the comparison is fair.
  Future<_MonthData> _load(DateTime month) async {
    final now = DateTime.now();
    final inProgress = month.year == now.year && month.month == now.month;
    final day = inProgress ? now.day : null;

    final current = await _calc.reportFor(month, throughDay: day);
    final previous = await _calc.reportFor(
      DateTime(month.year, month.month - 1),
      throughDay: day,
    );
    return _MonthData(current, previous.isEmpty ? null : previous);
  }

  void _shift(int months) {
    setState(() {
      _month = DateTime(_month.year, _month.month + months);
      _future = _load(_month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _shift(-1),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_month),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _isCurrentMonth ? null : () => _shift(1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<_MonthData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Couldn't load this month. Please try again.",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                );
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _ReportBody(data: snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}

final _money = NumberFormat('#,##0');
final _money2 = NumberFormat('#,##0.00');

class _ReportBody extends StatelessWidget {
  final _MonthData data;

  const _ReportBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final report = data.current;

    if (report.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Nothing recorded this month.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    final biggest = report.totalIncome > report.totalExpenses
        ? report.totalIncome
        : report.totalExpenses;
    final cost = report.costPerLitre;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SummaryTile(
              label: 'Income',
              value: _money.format(report.totalIncome),
              color: Colors.greenAccent,
            ),
            const SizedBox(width: 8),
            _SummaryTile(
              label: 'Expenses',
              value: _money.format(report.totalExpenses),
              color: Colors.orangeAccent,
            ),
            const SizedBox(width: 8),
            _SummaryTile(
              label: 'Profit',
              value: _money.format(report.net),
              color: report.net >= 0 ? Colors.greenAccent : Colors.redAccent,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Panel(
          title: 'Milk',
          children: [
            Text(
              '${report.litres.toStringAsFixed(1)} litres produced',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              cost == null
                  ? 'Cost per litre: no milk logged'
                  : 'Cost per litre: ${_money2.format(cost)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        if (report.earningsByBuyer.isNotEmpty) ...[
          const SizedBox(height: 16),
          _BuyerPanel(report: report),
        ],
        const SizedBox(height: 16),
        _Panel(
          title: 'Income vs expenses',
          children: [
            _Bar(
              label: 'Income',
              value: report.totalIncome,
              max: biggest,
              color: Colors.greenAccent,
              valueText: _money.format(report.totalIncome),
            ),
            const SizedBox(height: 8),
            _Bar(
              label: 'Expenses',
              value: report.totalExpenses,
              max: biggest,
              color: Colors.orangeAccent,
              valueText: _money.format(report.totalExpenses),
            ),
            const SizedBox(height: 8),
            Text(
              'Milk ${_money.format(report.milkCash)}'
              '  •  Other income ${_money.format(report.otherIncome)}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Panel(
          title: 'Where the money went',
          children: [
            if (report.categoriesBySpend.isEmpty)
              const Text(
                'No expenses recorded this month.',
                style: TextStyle(color: Colors.white54),
              )
            else
              for (final entry in report.categoriesBySpend) ...[
                _Bar(
                  label: ExpenseCategory.label(entry.key),
                  labelWidth: 110,
                  value: entry.value,
                  max: report.totalExpenses,
                  color: Colors.lightBlueAccent,
                  valueText:
                      '${_money.format(entry.value)} '
                      '(${(entry.value / report.totalExpenses * 100).toStringAsFixed(0)}%)',
                ),
                const SizedBox(height: 8),
              ],
          ],
        ),
        const SizedBox(height: 16),
        // A new card for each month, so advice never carries over.
        FinanceAdvisorCard(
          key: ValueKey(report.month),
          current: report,
          previous: data.previous,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BuyerPanel extends StatelessWidget {
  final MonthlyReport report;

  const _BuyerPanel({required this.report});

  @override
  Widget build(BuildContext context) {
    final buyers = report.earningsByBuyer;
    final top = buyers.fold<double>(0, (m, b) => b.cash > m ? b.cash : m);
    return _Panel(
      title: 'Earnings per buyer',
      children: [
        if (!report.hasBuyers)
          const Text(
            'No buyers recorded this month. Add a buyer when logging milk '
            'to see who pays the most.',
            style: TextStyle(color: Colors.white54),
          )
        else
          for (final b in buyers) ...[
            _Bar(
              label: b.buyer ?? 'Not recorded',
              labelWidth: 110,
              value: b.cash,
              max: top,
              color: b.buyer == null ? Colors.white38 : Colors.tealAccent,
              valueText: _money.format(b.cash),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 110, top: 2, bottom: 8),
              child: Text(
                '${b.litres.toStringAsFixed(1)} L'
                '${report.milkCash > 0 ? '  •  ${(b.cash / report.milkCash * 100).toStringAsFixed(0)}% of milk income' : ''}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Panel({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double labelWidth;
  final double value;
  final double max;
  final Color color;
  final String valueText;

  const _Bar({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.valueText,
    this.labelWidth = 80,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0).toDouble();

    return Row(
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 14,
              backgroundColor: Colors.white12,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            valueText,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
