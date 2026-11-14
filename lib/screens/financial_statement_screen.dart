import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/models/period_runner.dart';
import 'package:cow/services/pdf_export.dart';
import 'package:cow/services/statement_pdf.dart';
import 'package:flutter/material.dart';

class StatementScreen extends StatefulWidget {
  final AppDatabase db;
  const StatementScreen({super.key, required this.db});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  DateTime _reference = DateTime.now();
  late Future<PeriodStatement> _future;
  late StatementCalculator _calc;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _calc = StatementCalculator(widget.db);
    _future = _calc.statementFor(_reference);
  }

  void _shiftPeriod(int direction) {
    final (start, _) = StatementCalculator.periodBoundsFor(_reference);
    setState(() {
      _reference = direction < 0
          ? start.subtract(const Duration(days: 1)) // jump into prior period
          : DateTime(start.year, start.month, start.day + 20); // jump forward
      _future = _calc.statementFor(_reference);
    });
  }

  String _fmt(DateTime d) => shortDate(d);
  String _money(double v) => ksh(v, cents: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navStatement),
        actions: [
          IconButton(
            tooltip: context.l10n.exportPdf,
            icon: _exporting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _exporting ? null : _exportPdf,
          ),
        ],
      ),
      body: FutureBuilder<PeriodStatement>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _shiftPeriod(-1),
                  ),
                  Text(
                    context.l10n.periodRange(
                      _fmt(s.periodStart),
                      _fmt(s.periodEnd),
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _shiftPeriod(1),
                  ),
                ],
              ),
              const Divider(height: 32),
              _row(context.l10n.openingBalance, s.openingBalance),
              _row(
                context.l10n.milkCashRecords(s.milkRecords.length),
                s.totalMilkCash,
              ),
              _row(
                context.l10n.otherIncomeEntries(s.incomeRecords.length),
                s.otherIncome,
              ),
              _row(
                context.l10n.expensesEntries(s.expenseRecords.length),
                -s.totalExpenses,
              ),
              const Divider(),
              _row(context.l10n.closingBalance, s.closingBalance, bold: true),
              const SizedBox(height: 24),
              Text(
                context.l10n.milkRecords,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ...s.milkRecords.map(
                (r) => ListTile(
                  dense: true,
                  title: Text(
                    '${_fmt(r.entryDate)} • ${sessionLabel(context.l10n, r.session)}',
                  ),
                  subtitle: Text(litres(r.amount)),
                  trailing: Text(_money(s.cashFor(r))),
                ),
              ),
              if (s.incomeRecords.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  context.l10n.otherIncome,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                ...s.incomeRecords.map(
                  (i) => ListTile(
                    dense: true,
                    title: Text(incomeCategoryLabel(context.l10n, i.category)),
                    subtitle: Text(
                      (i.note == null || i.note!.isEmpty)
                          ? _fmt(i.date)
                          : '${_fmt(i.date)} • ${i.note}',
                    ),
                    trailing: Text('+${_money(i.amount)}'),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                context.l10n.navExpenses,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ...s.expenseRecords.map(
                (e) => ListTile(
                  dense: true,
                  title: Text(e.description),
                  subtitle: Text(
                    '${expenseCategoryLabel(context.l10n, e.category)} • ${_fmt(e.date)}',
                  ),
                  trailing: Text('-${_money(e.amount)}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Saves the shown month as a PDF in Documents/Mwauras Farm and opens it.
  Future<void> _exportPdf() async {
    final l10n = context.l10n;
    setState(() => _exporting = true);
    String message;
    try {
      final s = await _future;
      final file = await savePdf(
        await buildStatementPdf(s, l10n: l10n),
        statementFileName(s),
      );
      final opened = await openFile(file);
      message = opened
          ? l10n.savedFile(file.path)
          : l10n.savedFileNotOpened(file.path);
    } catch (e) {
      message = l10n.couldNotSavePdf('$e');
    }
    if (!mounted) return;
    setState(() => _exporting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    final style = bold
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : const TextStyle(fontSize: 15);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(_money(value), style: style),
        ],
      ),
    );
  }
}
