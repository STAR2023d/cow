import 'package:cow/utils/format.dart';
import 'dart:typed_data';

import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/l10n/labels.dart';
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
String monthlyReportPeriod(MonthlyReport r, {L10n? l10n}) {
  final t = l10n ?? pdfEnglish;
  final name = monthYear(r.month);
  final lastDay = DateTime(r.month.year, r.month.month + 1, 0).day;
  final through = r.throughDay;
  if (through == null || through >= lastDay) return name;
  return t.monthInProgress(name, through);
}

/// Builds the Monthly Report as a PDF: totals, milk, income, spending by
/// category and earnings per buyer, in the language of [l10n] (English by
/// default). With [previous], a "Last month" column is added (cut at the
/// same day when the month is in progress).
Future<Uint8List> buildMonthlyReportPdf(
  MonthlyReport r, {
  MonthlyReport? previous,
  DateTime? generatedAt,
  bool compress = true,
  L10n? l10n,
}) {
  final t = l10n ?? pdfEnglish;
  final p = previous;
  List<String> line(String label, double now, double? before) => [
    label,
    amount(now),
    if (p != null) before == null ? '-' : amount(before),
  ];
  final cost = r.costPerLitre;

  return buildFarmPdf(
    title: t.monthlyReportTitle(monthlyReportPeriod(r, l10n: t)),
    generatedAt: generatedAt,
    compress: compress,
    l10n: t,
    body: [
      if (r.isEmpty) pw.Text(t.nothingThisMonth),
      pdfTable(
        ['', t.thisMonth, if (p != null) t.lastMonth],
        [
          line(t.milkIncome, r.milkCash, p?.milkCash),
          line(t.otherIncome, r.otherIncome, p?.otherIncome),
          line(t.totalIncome, r.totalIncome, p?.totalIncome),
          line(t.navExpenses, r.totalExpenses, p?.totalExpenses),
          line(t.profit, r.net, p?.net),
        ],
        rightFrom: 1,
      ),
      pdfHeading(t.milk),
      pdfSummaryRow(t.litresProducedLabel, litres(r.litres)),
      pdfSummaryRow(
        t.costPerLitreLabel,
        cost == null ? t.noMilkLogged : amount(cost),
      ),
      pdfHeading(t.whereMoneyWent),
      if (r.categoriesBySpend.isEmpty)
        pw.Text(t.noExpensesMonth)
      else
        pdfTable(
          [t.colCategory, t.colAmount, t.colShare],
          [
            for (final e in r.categoriesBySpend)
              [
                expenseCategoryLabel(t, e.key),
                amount(e.value),
                _pct(e.value, r.totalExpenses),
              ],
          ],
          rightFrom: 1,
        ),
      if (r.hasBuyers) ...[
        pdfHeading(t.earningsPerBuyer),
        pdfTable(
          [t.colBuyer, t.colLitres, t.colAmount, t.colShareMilk],
          [
            for (final b in r.earningsByBuyer)
              [
                b.buyer ?? t.notRecorded,
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
