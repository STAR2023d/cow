import 'package:cow/utils/format.dart';
import 'package:cow/breeding/calf_register.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

/// Parses an optional weight; null when empty, NaN when not a number.
double? _weight(String text) {
  final t = text.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  final v = double.tryParse(t);
  return v == null || v <= 0 || v > 200 ? double.nan : v;
}

String? _weightError(String? v) =>
    (_weight(v ?? '')?.isNaN ?? false) ? 'Enter kg between 0 and 200' : null;

const _textStyle = TextStyle();

/// Dialog to add a calf that has no breeding cycle (bought in, or born
/// before the app was used). Returns the row to insert, or null.
class AddCalfDialog extends StatefulWidget {
  final List<CowData> cows;

  const AddCalfDialog({super.key, required this.cows});

  @override
  State<AddCalfDialog> createState() => _AddCalfDialogState();
}

class _AddCalfDialogState extends State<AddCalfDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _weightCtl = TextEditingController();
  final _notes = TextEditingController();
  DateTime _born = DateTime.now();
  String _sex = 'female';
  int? _damId;
  bool _boughtIn = false;

  @override
  void dispose() {
    _name.dispose();
    _weightCtl.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final name = _name.text.trim();
    final notes = _notes.text.trim();
    Navigator.pop(
      context,
      CalvesCompanion.insert(
        name: Value(name.isEmpty ? null : name),
        dateOfBirth: _born,
        sex: _sex,
        damCowId: Value(_damId),
        birthWeightKg: Value(_weight(_weightCtl.text)),
        notes: Value(notes.isEmpty ? null : notes),
        boughtIn: Value(_boughtIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add calf', style: _textStyle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                style: _textStyle,
                decoration: const InputDecoration(labelText: 'Name (optional)'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Born: ${shortDate(_born)}',
                  style: TextStyle(color: context.farm.muted),
                ),
                trailing: Icon(
                  Icons.calendar_today,
                  color: context.farm.muted,
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _born,
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _born = picked);
                },
              ),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'female', label: Text('Female')),
                  ButtonSegment(value: 'male', label: Text('Male')),
                ],
                selected: {_sex},
                onSelectionChanged: (s) => setState(() => _sex = s.first),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                initialValue: _damId,
                style: _textStyle,
                decoration: const InputDecoration(labelText: 'Dam (optional)'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Unknown')),
                  for (final c in widget.cows)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => _damId = v),
              ),
              TextFormField(
                controller: _weightCtl,
                style: _textStyle,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Birth weight (optional)',
                  suffixText: 'kg',
                ),
                validator: _weightError,
              ),
              TextFormField(
                controller: _notes,
                style: _textStyle,
                maxLength: 300,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Bought in',
                  style: TextStyle(color: context.farm.muted),
                ),
                value: _boughtIn,
                onChanged: (v) => setState(() => _boughtIn = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

/// What the farmer chose in [CalfDetailsDialog].
sealed class CalfDetailsResult {}

class SaveCalfDetails extends CalfDetailsResult {
  final double? birthWeightKg;
  final DateTime? weanedOn;
  final String? notes;

  SaveCalfDetails(this.birthWeightKg, this.weanedOn, this.notes);
}

class DeleteCalf extends CalfDetailsResult {}

class OpenBreedingRecord extends CalfDetailsResult {}

/// Dialog to add or edit a calf's birth weight, weaning date and notes.
/// Cycle calves can also jump to the dam's breeding record; hand-entered
/// calves can be deleted.
class CalfDetailsDialog extends StatefulWidget {
  final CalfEntry calf;
  final String title;

  const CalfDetailsDialog({super.key, required this.calf, required this.title});

  @override
  State<CalfDetailsDialog> createState() => _CalfDetailsDialogState();
}

class _CalfDetailsDialogState extends State<CalfDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _weightCtl = TextEditingController(
    text: widget.calf.birthWeightKg?.toString() ?? '',
  );
  late final _notes = TextEditingController(text: widget.calf.notes ?? '');
  late DateTime? _weaned = widget.calf.weanedOn;
  bool _confirmDelete = false;

  @override
  void dispose() {
    _weightCtl.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notes = _notes.text.trim();
    Navigator.pop(
      context,
      SaveCalfDetails(
        _weight(_weightCtl.text),
        _weaned,
        notes.isEmpty ? null : notes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calf = widget.calf;
    return AlertDialog(
      title: Text(widget.title, style: _textStyle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _weightCtl,
                style: _textStyle,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Birth weight',
                  suffixText: 'kg',
                ),
                validator: _weightError,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _weaned == null
                      ? 'Not weaned'
                      : 'Weaned on ${shortDate(_weaned!)}',
                  style: TextStyle(color: context.farm.muted),
                ),
                trailing: _weaned == null
                    ? Icon(Icons.calendar_today, color: context.farm.muted)
                    : IconButton(
                        tooltip: 'Clear weaning date',
                        icon: Icon(Icons.close, color: context.farm.muted),
                        onPressed: () => setState(() => _weaned = null),
                      ),
                onTap: () async {
                  final born = calf.bornOn;
                  final now = DateTime.now();
                  final first = DateTime(born.year, born.month, born.day);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _weaned ?? now,
                    firstDate: first.isAfter(now) ? now : first,
                    lastDate: now,
                  );
                  if (picked != null) setState(() => _weaned = picked);
                },
              ),
              TextFormField(
                controller: _notes,
                style: _textStyle,
                maxLength: 300,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (calf.fromCycle)
          TextButton(
            onPressed: () => Navigator.pop(context, OpenBreedingRecord()),
            child: const Text('Breeding record'),
          )
        else
          TextButton(
            onPressed: () => _confirmDelete
                ? Navigator.pop(context, DeleteCalf())
                : setState(() => _confirmDelete = true),
            style: TextButton.styleFrom(foregroundColor: context.farm.danger),
            child: Text(_confirmDelete ? 'Tap again to delete' : 'Delete'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
