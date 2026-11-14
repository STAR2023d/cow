import 'package:cow/utils/format.dart';
import 'dart:typed_data';

import 'package:cow/models/expense_category.dart';
import 'package:cow/models/period_runner.dart';
import 'package:cow/services/pdf_layout.dart';
import 'package:pdf/widgets.dart' as pw;

String _money(double v) => amount(v);

/// File name for a statement. Periods are half months, so both dates are
/// in it, e.g. `statement-2026-11-01-to-2026-11-15.pdf`.
String statementFileName(PeriodStatement s) =>
    'statement-${pdfDate(s.periodStart)}-to-${pdfDate(s.periodEnd)}.pdf';

/// Builds the Financial Statement as a PDF, with the same figures and
/// lists as the screen.
Future<Uint8List> buildStatementPdf(
  PeriodStatement s, {
  DateTime? generatedAt,
  bool compress = true,
}) => buildFarmPdf(
  title:
      'Financial Statement: ${shortDate(s.periodStart)} to '
      '${shortDate(s.periodEnd)}',
  generatedAt: generatedAt,
  compress: compress,
  body: [
    pdfSummaryRow('Opening balance', _money(s.openingBalance)),
    pdfSummaryRow(
      'Milk cash (${s.milkRecords.length} records)',
      _money(s.totalMilkCash),
    ),
    pdfSummaryRow(
      'Other income (${s.incomeRecords.length} entries)',
      _money(s.otherIncome),
    ),
    pdfSummaryRow(
      'Expenses (${s.expenseRecords.length} entries)',
      _money(-s.totalExpenses),
    ),
    pw.Divider(),
    pdfSummaryRow('Closing balance', _money(s.closingBalance), strong: true),
    pdfHeading('Milk records'),
    if (s.milkRecords.isEmpty)
      pw.Text('None')
    else
      pdfTable(
        ['Date', 'Session', 'Litres', 'Cash'],
        [
          for (final r in s.milkRecords)
            [
              shortDate(r.entryDate),
              r.session,
              r.amount.toStringAsFixed(2),
              _money(s.cashFor(r)),
            ],
        ],
        rightFrom: 2,
      ),
    if (s.incomeRecords.isNotEmpty) ...[
      pdfHeading('Other income'),
      pdfTable(
        ['Date', 'Type', 'Note', 'Amount'],
        [
          for (final i in s.incomeRecords)
            [
              shortDate(i.date),
              incomeLabel(i.category),
              i.note ?? '',
              _money(i.amount),
            ],
        ],
      ),
    ],
    pdfHeading('Expenses'),
    if (s.expenseRecords.isEmpty)
      pw.Text('None')
    else
      pdfTable(
        ['Date', 'Category', 'Description', 'Amount'],
        [
          for (final e in s.expenseRecords)
            [
              shortDate(e.date),
              ExpenseCategory.label(e.category),
              e.description,
              _money(e.amount),
            ],
        ],
      ),
  ],
);
