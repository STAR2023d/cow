import 'package:cow/utils/format.dart';
import 'dart:typed_data';

import 'package:cow/models/expense_category.dart';
import 'package:cow/models/monthly_report.dart';
import 'package:cow/services/pdf_layout.dart';
import 'package:pdf/widgets.dart' as pw;

String _pct(double part, double whole) =>
    whole > 0 ? '${(part / whole * 100).toStringAsFixed(0)}%' : '-';

/// File name for a monthly report, e.g. `monthly-report-2026-11.pdf`.
String monthlyReportFileName(MonthlyReport r) =>
    'monthly-report-${r.month.year}-'
    '${r.month.month.toString().padLeft(2, '0')}.pdf';

/// The period line, e.g. "November 2026" or, for a month in progress,
/// "November 2026, 1 to 14 (month in progress)".
String monthlyReportPeriod(MonthlyReport r) {
  final name = monthYear(r.month);
  final lastDay = DateTime(r.month.year, r.month.month + 1, 0).day;
  final through = r.throughDay;
  if (through == null || through >= lastDay) return name;
  return '$name, 1 to $through (month in progress)';
}

/// Builds the Monthly Report as a PDF: totals, milk, income, spending by
/// category and earnings per buyer. With [previous], a "Last month"
/// column is added (cut at the same day when the month is in progress).
Future<Uint8List> buildMonthlyReportPdf(
  MonthlyReport r, {
  MonthlyReport? previous,
  DateTime? generatedAt,
  bool compress = true,
}) {
  final p = previous;
  List<String> line(String label, double now, double? before) => [
    label,
    amount(now),
    if (p != null) before == null ? '-' : amount(before),
  ];
  final cost = r.costPerLitre;

  return buildFarmPdf(
    title: 'Monthly Report: ${monthlyReportPeriod(r)}',
    generatedAt: generatedAt,
    compress: compress,
    body: [
      if (r.isEmpty) pw.Text('Nothing recorded this month.'),
      pdfTable(
        ['', 'This month', if (p != null) 'Last month'],
        [
          line('Milk income', r.milkCash, p?.milkCash),
          line('Other income', r.otherIncome, p?.otherIncome),
          line('Total income', r.totalIncome, p?.totalIncome),
          line('Expenses', r.totalExpenses, p?.totalExpenses),
          line('Profit', r.net, p?.net),
        ],
        rightFrom: 1,
      ),
      pdfHeading('Milk'),
      pdfSummaryRow('Litres produced', '${r.litres.toStringAsFixed(1)} L'),
      pdfSummaryRow(
        'Cost per litre',
        cost == null ? 'no milk logged' : amount(cost),
      ),
      pdfHeading('Where the money went'),
      if (r.categoriesBySpend.isEmpty)
        pw.Text('No expenses recorded this month.')
      else
        pdfTable(
          ['Category', 'Amount', 'Share'],
          [
            for (final e in r.categoriesBySpend)
              [
                ExpenseCategory.label(e.key),
                amount(e.value),
                _pct(e.value, r.totalExpenses),
              ],
          ],
          rightFrom: 1,
        ),
      if (r.hasBuyers) ...[
        pdfHeading('Earnings per buyer'),
        pdfTable(
          ['Buyer', 'Litres', 'Amount', 'Share of milk income'],
          [
            for (final b in r.earningsByBuyer)
              [
                b.buyer ?? 'Not recorded',
                b.litres.toStringAsFixed(1),
                amount(b.cash),
                _pct(b.cash, r.milkCash),
              ],
          ],
          rightFrom: 1,
        ),
      ],
    ],
  );
}
