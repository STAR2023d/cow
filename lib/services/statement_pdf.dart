import 'dart:typed_data';

import 'package:cow/models/expense_category.dart';
import 'package:cow/models/period_runner.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const farmName = "Mwaura's Farm";

String _date(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
String _money(double v) => v.toStringAsFixed(2);

/// File name for a statement. Periods are half months, so both dates are
/// in it, e.g. `statement-2026-11-01-to-2026-11-15.pdf`.
String statementFileName(PeriodStatement s) =>
    'statement-${_date(s.periodStart)}-to-${_date(s.periodEnd)}.pdf';

/// Builds the Financial Statement as a PDF, with the same figures and
/// lists as the screen. Amounts are in Kenyan shillings. [compress] is
/// turned off in tests so the text can be checked.
Future<Uint8List> buildStatementPdf(
  PeriodStatement s, {
  DateTime? generatedAt,
  bool compress = true,
}) {
  final doc = pw.Document(
    compress: compress,
    title: 'Financial Statement ${_date(s.periodStart)}',
    author: farmName,
  );
  final made = generatedAt ?? DateTime.now();
  final bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);

  pw.Widget summaryRow(String label, double value, {bool strong = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: strong ? bold : null),
            pw.Text(_money(value), style: strong ? bold : null),
          ],
        ),
      );

  pw.Widget table(List<String> headers, List<List<String>> rows) =>
      pw.TableHelper.fromTextArray(
        headers: headers,
        data: rows,
        headerStyle: bold.copyWith(fontSize: 10),
        cellStyle: const pw.TextStyle(fontSize: 10),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
        cellAlignments: {headers.length - 1: pw.Alignment.centerRight},
      );

  pw.Widget heading(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
    child: pw.Text(text, style: bold.copyWith(fontSize: 13)),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      header: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(farmName, style: bold.copyWith(fontSize: 18)),
          pw.Text(
            'Financial Statement: ${_date(s.periodStart)} to '
            '${_date(s.periodEnd)}',
          ),
          pw.Text(
            'Amounts in KES. Generated ${_date(made)}.',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.Divider(),
        ],
      ),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
      ),
      build: (_) => [
        summaryRow('Opening balance', s.openingBalance),
        summaryRow(
          'Milk cash (${s.milkRecords.length} records)',
          s.totalMilkCash,
        ),
        summaryRow(
          'Other income (${s.incomeRecords.length} entries)',
          s.otherIncome,
        ),
        summaryRow(
          'Expenses (${s.expenseRecords.length} entries)',
          -s.totalExpenses,
        ),
        pw.Divider(),
        summaryRow('Closing balance', s.closingBalance, strong: true),
        heading('Milk records'),
        if (s.milkRecords.isEmpty)
          pw.Text('None')
        else
          table(
            ['Date', 'Session', 'Litres', 'Cash'],
            [
              for (final r in s.milkRecords)
                [
                  _date(r.entryDate),
                  r.session,
                  r.amount.toStringAsFixed(2),
                  _money(s.cashFor(r)),
                ],
            ],
          ),
        if (s.incomeRecords.isNotEmpty) ...[
          heading('Other income'),
          table(
            ['Date', 'Type', 'Note', 'Amount'],
            [
              for (final i in s.incomeRecords)
                [
                  _date(i.date),
                  incomeLabel(i.category),
                  i.note ?? '',
                  _money(i.amount),
                ],
            ],
          ),
        ],
        heading('Expenses'),
        if (s.expenseRecords.isEmpty)
          pw.Text('None')
        else
          table(
            ['Date', 'Category', 'Description', 'Amount'],
            [
              for (final e in s.expenseRecords)
                [
                  _date(e.date),
                  ExpenseCategory.label(e.category),
                  e.description,
                  _money(e.amount),
                ],
            ],
          ),
      ],
    ),
  );
  return doc.save();
}
