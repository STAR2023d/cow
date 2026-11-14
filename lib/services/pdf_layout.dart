import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Shared look for the farm's PDF reports: a heading with the farm name,
/// title and date made, page numbers, tables and summary rows.

const farmName = "Mwaura's Farm";

String pdfDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

final _bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
const _small = pw.TextStyle(fontSize: 9, color: PdfColors.grey700);

/// One A4 report, possibly several pages. [compress] is turned off in
/// tests so the text can be checked.
Future<Uint8List> buildFarmPdf({
  required String title,
  required List<pw.Widget> body,
  DateTime? generatedAt,
  bool compress = true,
}) {
  final doc = pw.Document(compress: compress, title: title, author: farmName);
  final made = generatedAt ?? DateTime.now();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      header: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(farmName, style: _bold.copyWith(fontSize: 18)),
          pw.Text(title),
          pw.Text('Amounts in KES. Generated ${pdfDate(made)}.', style: _small),
          pw.Divider(),
        ],
      ),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: _small,
        ),
      ),
      build: (_) => body,
    ),
  );
  return doc.save();
}

pw.Widget pdfHeading(String text) => pw.Padding(
  padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
  child: pw.Text(text, style: _bold.copyWith(fontSize: 13)),
);

/// A label on the left and an amount on the right.
pw.Widget pdfSummaryRow(String label, String value, {bool strong = false}) =>
    pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: strong ? _bold : null),
          pw.Text(value, style: strong ? _bold : null),
        ],
      ),
    );

/// A table with a grey header row. Columns from [rightFrom] onwards are
/// right-aligned (numbers); by default only the last one.
pw.Widget pdfTable(
  List<String> headers,
  List<List<String>> rows, {
  int? rightFrom,
}) {
  final first = rightFrom ?? headers.length - 1;
  return pw.TableHelper.fromTextArray(
    headers: headers,
    data: rows,
    headerStyle: _bold.copyWith(fontSize: 10),
    cellStyle: const pw.TextStyle(fontSize: 10),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    cellAlignments: {
      for (var i = first; i < headers.length; i++) i: pw.Alignment.centerRight,
    },
    headerAlignments: {
      for (var i = first; i < headers.length; i++) i: pw.Alignment.centerRight,
    },
  );
}
