import 'dart:convert';

import 'package:cow/database/app_database.dart';
import 'package:cow/models/period_runner.dart';
import 'package:cow/services/statement_pdf.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.setPricePerLitre(60, effectiveDate: DateTime(2026, 11, 1));
    final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    await db.upsertMilkEntry(
      cowId: cowId,
      date: DateTime(2026, 11, 5, 6, 30),
      session: MilkSession.morning,
      amount: 10,
    );
    await db.insertExpense(
      ExpensesCompanion.insert(
        date: DateTime(2026, 11, 6),
        description: 'Dairy meal',
        amount: 100,
      ),
    );
    await db.insertIncome(
      LedgerEntriesCompanion.insert(
        type: 'income',
        category: 'calf_sale',
        amount: 5000,
        date: Value(DateTime(2026, 11, 7)),
      ),
    );
  });

  tearDown(() => db.close());

  test('statement PDF holds the period, totals and records', () async {
    final s = await StatementCalculator(db).statementFor(DateTime(2026, 11, 7));
    final bytes = await buildStatementPdf(
      s,
      generatedAt: DateTime(2026, 11, 14),
      compress: false,
    );
    final text = latin1.decode(bytes);

    expect(text, startsWith('%PDF'));
    for (final expected in [
      // The PDF stores words one by one, so check single words.
      'Statement:',
      '1', 'Nov', '15', // 1 Nov 2026 to 15 Nov 2026
      'Closing',
      '5,500.00',
      '600.00',
      'Dairy',
      'Calf',
    ]) {
      expect(text, contains(expected), reason: expected);
    }
    expect(statementFileName(s), 'statement-2026-11-01-to-2026-11-15.pdf');
  });

  test('a month with no records still makes a PDF', () async {
    final s = await StatementCalculator(db).statementFor(DateTime(2026, 3, 1));
    final bytes = await buildStatementPdf(s, compress: false);
    expect(latin1.decode(bytes), contains('None'));
  });
}
