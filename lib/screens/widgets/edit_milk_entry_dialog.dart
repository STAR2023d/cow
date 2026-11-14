import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// What the farmer changed in [EditMilkEntryDialog]. A null [buyer] means
/// the buyer was cleared.
typedef MilkEntryEdit = ({double amount, String? buyer});

/// Lets the farmer correct the litres and buyer of one milk entry. Session
/// and date stay fixed: entries are keyed by cow, day and session.
class EditMilkEntryDialog extends StatefulWidget {
  final double amount;
  final String? buyer;

  /// Shown under the title, e.g. "MORNING • Nov 14, 2026".
  final String label;

  const EditMilkEntryDialog({
    super.key,
    required this.amount,
    required this.buyer,
    required this.label,
  });

  @override
  State<EditMilkEntryDialog> createState() => _EditMilkEntryDialogState();
}

class _EditMilkEntryDialogState extends State<EditMilkEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(text: _trim(widget.amount));
  late final _buyer = TextEditingController(text: widget.buyer ?? '');

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  @override
  void dispose() {
    _amount.dispose();
    _buyer.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final buyer = _buyer.text.trim();
    Navigator.pop<MilkEntryEdit>(context, (
      amount: double.parse(_amount.text.trim()),
      buyer: buyer.isEmpty ? null : buyer,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit milk entry'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: TextStyle(color: context.farm.muted)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Litres'),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                if (amount == null) return 'Please enter a valid number';
                if (amount <= 0) return 'Quantity must be greater than zero';
                return null;
              },
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _buyer,
              decoration: const InputDecoration(
                labelText: 'Buyer (optional)',
                helperText: 'Leave empty to remove the buyer',
              ),
              onFieldSubmitted: (_) => _save(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
