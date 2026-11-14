import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// What the farmer chose in [SetPriceDialog].
typedef NewPrice = ({double price, DateTime from});

/// Asks for a new price per litre and the day it applies from (today by
/// default; earlier when the buyer's new rate started on the 1st).
class SetPriceDialog extends StatefulWidget {
  final double? current;

  /// Today; replaced in tests.
  final DateTime today;

  const SetPriceDialog({super.key, this.current, required this.today});

  @override
  State<SetPriceDialog> createState() => _SetPriceDialogState();
}

class _SetPriceDialogState extends State<SetPriceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _price = TextEditingController();
  late DateTime _from = widget.today;

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _from,
      firstDate: widget.today.subtract(const Duration(days: 730)),
      lastDate: widget.today.add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _from = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    Navigator.pop<NewPrice>(context, (price: price, from: _from));
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _from == widget.today;
    return AlertDialog(
      title: Text(context.l10n.changeMilkPrice),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.current != null)
              Text(
                context.l10n.nowPerLitre(ksh(widget.current!, cents: true)),
                style: TextStyle(color: context.farm.muted),
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: context.l10n.newPricePerLitre,
                prefixText: 'KSh ',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final p = double.tryParse(
                  (v ?? '').trim().replaceAll(',', '.'),
                );
                if (p == null || p <= 0) {
                  return context.l10n.enterPriceAboveZero;
                }
                if (p > 1000) return context.l10n.priceTooHigh;
                return null;
              },
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            Text(context.l10n.appliesFrom),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(context.l10n.today),
                  selected: isToday,
                  onSelected: (_) => setState(() => _from = widget.today),
                ),
                ChoiceChip(
                  avatar: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    isToday ? context.l10n.otherDay : shortDate(_from),
                  ),
                  selected: !isToday,
                  onSelected: (_) => _pickDay(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.priceChangeNote(shortDate(_from)),
              style: TextStyle(color: context.farm.muted, fontSize: 13),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(context.l10n.save)),
      ],
    );
  }
}

/// Opens [SetPriceDialog] and saves the result. Returns true when saved.
Future<bool> changeMilkPrice(
  BuildContext context, {
  required Future<void> Function(double price, DateTime from) save,
  double? current,
}) async {
  final now = DateTime.now();
  final result = await showDialog<NewPrice>(
    context: context,
    builder: (_) => SetPriceDialog(
      current: current,
      today: DateTime(now.year, now.month, now.day),
    ),
  );
  if (result == null) return false;
  await save(result.price, result.from);
  return true;
}
