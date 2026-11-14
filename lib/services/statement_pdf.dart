import 'dart:typed_data';

import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/models/period_runner.dart';
import 'package:cow/services/pdf_layout.dart';
import 'package:cow/utils/format.dart';
import 'package:pdf/widgets.dart' as pw;

String _money(double v) => amount(v);

/// File name for a statement. Periods are half months, so both dates are
/// in it, e.g. `statement-2026-11-01-to-2026-11-15.pdf`.
String statementFileName(PeriodStatement s) =>
    'statement-${pdfDate(s.periodStart)}-to-${pdfDate(s.periodEnd)}.pdf';

/// Builds the Financial Statement as a PDF, with the same figures and
/// lists as the screen, in the language of [l10n] (English by default).
Future<Uint8List> buildStatementPdf(
  PeriodStatement s, {
  DateTime? generatedAt,
  bool compress = true,
  L10n? l10n,
}) {
  final t = l10n ?? pdfEnglish;
  return buildFarmPdf(
    title: t.statementTitle(shortDate(s.periodStart), shortDate(s.periodEnd)),
    generatedAt: generatedAt,
    compress: compress,
    l10n: t,
    body: [
      pdfSummaryRow(t.openingBalance, _money(s.openingBalance)),
      pdfSummaryRow(
        t.milkCashRecords(s.milkRecords.length),
        _money(s.totalMilkCash),
      ),
      pdfSummaryRow(
        t.otherIncomeEntries(s.incomeRecords.length),
        _money(s.otherIncome),
      ),
      pdfSummaryRow(
        t.expensesEntries(s.expenseRecords.length),
        _money(-s.totalExpenses),
      ),
      pw.Divider(),
      pdfSummaryRow(t.closingBalance, _money(s.closingBalance), strong: true),
      pdfHeading(t.milkRecords),
      if (s.milkRecords.isEmpty)
        pw.Text(t.none)
      else
        pdfTable(
          [t.colDate, t.colSession, t.colLitres, t.colCash],
          [
            for (final r in s.milkRecords)
              [
                shortDate(r.entryDate),
                sessionLabel(t, r.session),
                r.amount.toStringAsFixed(2),
                _money(s.cashFor(r)),
              ],
          ],
          rightFrom: 2,
        ),
      if (s.incomeRecords.isNotEmpty) ...[
        pdfHeading(t.otherIncome),
        pdfTable(
          [t.colDate, t.colType, t.colNote, t.colAmount],
          [
            for (final i in s.incomeRecords)
              [
                shortDate(i.date),
                incomeCategoryLabel(t, i.category),
                i.note ?? '',
                _money(i.amount),
              ],
          ],
        ),
      ],
      pdfHeading(t.navExpenses),
      if (s.expenseRecords.isEmpty)
        pw.Text(t.none)
      else
        pdfTable(
          [t.colDate, t.colCategory, t.colDescription, t.colAmount],
          [
            for (final e in s.expenseRecords)
              [
                shortDate(e.date),
                expenseCategoryLabel(t, e.category),
                e.description,
                _money(e.amount),
              ],
          ],
        ),
    ],
  );
}
