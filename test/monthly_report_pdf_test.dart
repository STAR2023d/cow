import 'dart:convert';

import 'package:cow/models/buyer_earnings.dart';
import 'package:cow/models/monthly_report.dart';
import 'package:cow/services/monthly_report_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final november = MonthlyReport(
    month: DateTime(2026, 11),
    litres: 300,
    milkCash: 18000,
    otherIncome: 5000,
    totalExpenses: 4000,
    expensesByCategory: const {'feed': 3000, 'vet': 1000},
    earningsByBuyer: const [
      BuyerEarnings(buyer: 'Brookside', litres: 200, cash: 12000),
      BuyerEarnings(buyer: null, litres: 100, cash: 6000),
    ],
  );

  Future<String> pdfText(MonthlyReport r, {MonthlyReport? previous}) async =>
      latin1.decode(
        await buildMonthlyReportPdf(
          r,
          previous: previous,
          generatedAt: DateTime(2026, 12, 1),
          compress: false,
        ),
      );

  test('holds the totals, spending and buyers', () async {
    final text = await pdfText(
      november,
      previous: MonthlyReport(
        month: DateTime(2026, 10),
        litres: 280,
        milkCash: 16800,
        otherIncome: 0,
        totalExpenses: 3500,
        expensesByCategory: const {'feed': 3500},
      ),
    );

    expect(text, startsWith('%PDF'));
    // The PDF stores words one by one, so check single words.
    for (final expected in [
      'November',
      '23,000.00', // total income
      '19,000.00', // profit
      '13,300.00', // last month's profit
      '75%', // feed share
      'Brookside',
      '67%', // Brookside share of milk income
      'recorded', // "Not recorded" buyer
    ]) {
      expect(text, contains(expected), reason: expected);
    }
  });

  test('names the file by month and marks a month in progress', () {
    expect(monthlyReportFileName(november), 'monthly-report-2026-11.pdf');
    expect(monthlyReportPeriod(november), 'November 2026');

    final soFar = MonthlyReport(
      month: DateTime(2026, 11),
      throughDay: 14,
      litres: 0,
      milkCash: 0,
      otherIncome: 0,
      totalExpenses: 0,
      expensesByCategory: const {},
    );
    expect(
      monthlyReportPeriod(soFar),
      'November 2026, 1 to 14 (month in progress)',
    );
  });

  test('an empty month still makes a PDF', () async {
    final text = await pdfText(
      MonthlyReport(
        month: DateTime(2026, 3),
        litres: 0,
        milkCash: 0,
        otherIncome: 0,
        totalExpenses: 0,
        expensesByCategory: const {},
      ),
    );
    expect(text, contains('Nothing'));
  });
}
