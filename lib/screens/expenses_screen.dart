import 'package:drift/drift.dart' show Value;
import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/models/expense_category.dart';
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// Log an expense, and see, change or delete the ones already saved.
/// Tapping a saved expense loads it into the form for editing.
class ExpenseEntryScreen extends StatefulWidget {
  final AppDatabase db;
  const ExpenseEntryScreen({super.key, required this.db});

  @override
  State<ExpenseEntryScreen> createState() => _ExpenseEntryScreenState();
}

class _ExpenseEntryScreenState extends State<ExpenseEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  late final _expenses = widget.db.watchExpenses();
  DateTime _selectedDate = DateTime.now();
  String _category = ExpenseCategory.feed;

  /// The saved expense being changed, or null when logging a new one.
  Expense? _editing;

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _startEdit(Expense e) {
    setState(() {
      _editing = e;
      _selectedDate = e.date;
      _category = ExpenseCategory.all.contains(e.category)
          ? e.category
          : ExpenseCategory.other;
      _descController.text = e.description;
      _amountController.text = e.amount == e.amount.roundToDouble()
          ? e.amount.toStringAsFixed(0)
          : e.amount.toString();
    });
  }

  void _resetForm() {
    _descController.clear();
    _amountController.clear();
    setState(() {
      _editing = null;
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final description = _descController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final editing = _editing;
    if (editing == null) {
      await widget.db.insertExpense(
        ExpensesCompanion.insert(
          date: _selectedDate,
          description: description,
          amount: amount,
          category: Value(_category),
        ),
      );
    } else {
      await widget.db.updateExpense(
        editing.copyWith(
          date: _selectedDate,
          description: description,
          amount: amount,
          category: _category,
        ),
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          editing == null
              ? context.l10n.expenseSaved
              : context.l10n.expenseUpdated,
        ),
      ),
    );
    _resetForm();
  }

  Future<void> _delete(Expense e) async {
    if (_editing?.id == e.id) _resetForm();
    await deleteWithUndo(
      context,
      what: e.description,
      delete: () => widget.db.deleteExpense(e.id),
      restore: () => widget.db.restoreExpense(e),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.expenseTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_editing != null)
                  Text(
                    l.editingExpense,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.farm.warning,
                    ),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.dateLine(shortDate(_selectedDate))),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  key: ValueKey('category-${_editing?.id}-$_category'),
                  decoration: InputDecoration(labelText: l.category),
                  items: [
                    for (final c in ExpenseCategory.all)
                      DropdownMenuItem(
                        value: c,
                        child: Text(expenseCategoryLabel(l, c)),
                      ),
                  ],
                  onChanged: (c) => setState(() => _category = c!),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: l.description),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: l.amount),
                  validator: (v) {
                    final n = double.tryParse(v?.trim() ?? '');
                    return n == null || n <= 0 ? l.enterValidNumberShort : null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: Text(_editing == null ? l.saveExpense : l.saveChanges),
                ),
                if (_editing != null)
                  TextButton(onPressed: _resetForm, child: Text(l.cancel)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.savedExpenses,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            l.tapExpenseToEdit,
            style: TextStyle(color: context.farm.muted, fontSize: 13),
          ),
          StreamBuilder<List<Expense>>(
            stream: _expenses,
            builder: (context, snapshot) {
              final rows = snapshot.data;
              if (rows == null) return const SizedBox.shrink();
              if (rows.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l.noExpensesYet,
                    style: TextStyle(color: context.farm.muted),
                  ),
                );
              }
              return Column(
                children: [
                  for (final e in rows)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      selected: _editing?.id == e.id,
                      title: Text(e.description),
                      subtitle: Text(
                        '${shortDate(e.date)} · '
                        '${expenseCategoryLabel(l, e.category)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(ksh(e.amount)),
                          IconButton(
                            tooltip: l.delete,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(e),
                          ),
                        ],
                      ),
                      onTap: () => _startEdit(e),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
