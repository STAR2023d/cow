import 'package:cow/database/app_database.dart';
import 'package:cow/models/expense_category.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseCategory', () {
    test('every category has a readable label', () {
      expect(ExpenseCategory.all.length, 5);
      expect(ExpenseCategory.label(ExpenseCategory.feed), 'Feed');
      expect(ExpenseCategory.label(ExpenseCategory.vet), 'Vet & medicine');
      expect(ExpenseCategory.label(ExpenseCategory.labour), 'Labour');
      expect(ExpenseCategory.label(ExpenseCategory.transport), 'Transport');
      expect(ExpenseCategory.label(ExpenseCategory.other), 'Other');
    });

    test('an unknown key reads as Other', () {
      expect(ExpenseCategory.label('something-else'), 'Other');
    });
  });

  group('expenses in the database', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('a category is saved and read back', () async {
      await db.insertExpense(
        ExpensesCompanion.insert(
          date: DateTime(2026, 11, 6),
          description: 'Dairy meal',
          amount: 1200,
          category: const Value(ExpenseCategory.feed),
        ),
      );

      final saved = await db.watchExpenses().first;
      expect(saved.single.category, 'feed');
    });

    test('an expense saved without a category is Other', () async {
      await db.insertExpense(
        ExpensesCompanion.insert(
          date: DateTime(2026, 11, 6),
          description: 'Old style entry',
          amount: 300,
        ),
      );

      final saved = await db.watchExpenses().first;
      expect(saved.single.category, ExpenseCategory.other);
    });
  });
}
