import 'package:cow/l10n/language_controller.dart';
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

bool _badWeight(String? v) => _weight(v ?? '')?.isNaN ?? false;

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
      title: Text(context.l10n.addCalf, style: _textStyle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                style: _textStyle,
                decoration: InputDecoration(
                  labelText: context.l10n.nameOptional,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  context.l10n.bornOn(shortDate(_born)),
                  style: TextStyle(color: context.farm.muted),
                ),
                trailing: Icon(Icons.calendar_today, color: context.farm.muted),
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
                segments: [
                  ButtonSegment(
                    value: 'female',
                    label: Text(context.l10n.female),
                  ),
                  ButtonSegment(value: 'male', label: Text(context.l10n.male)),
                ],
                selected: {_sex},
                onSelectionChanged: (s) => setState(() => _sex = s.first),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                initialValue: _damId,
                style: _textStyle,
                decoration: InputDecoration(
                  labelText: context.l10n.damOptional,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(context.l10n.unknownBreed),
                  ),
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
                decoration: InputDecoration(
                  labelText: context.l10n.birthWeightOptional,
                  suffixText: 'kg',
                ),
                validator: (v) =>
                    _badWeight(v) ? context.l10n.enterKgRange : null,
              ),
              TextFormField(
                controller: _notes,
                style: _textStyle,
                maxLength: 300,
                maxLines: 2,
                decoration: InputDecoration(labelText: context.l10n.notes),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  context.l10n.boughtIn,
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
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(onPressed: _save, child: Text(context.l10n.save)),
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
                decoration: InputDecoration(
                  labelText: context.l10n.birthWeight,
                  suffixText: 'kg',
                ),
                validator: (v) =>
                    _badWeight(v) ? context.l10n.enterKgRange : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _weaned == null
                      ? context.l10n.notWeaned
                      : context.l10n.weanedOn(shortDate(_weaned!)),
                  style: TextStyle(color: context.farm.muted),
                ),
                trailing: _weaned == null
                    ? Icon(Icons.calendar_today, color: context.farm.muted)
                    : IconButton(
                        tooltip: context.l10n.clearWeaning,
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
                decoration: InputDecoration(labelText: context.l10n.notes),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (calf.fromCycle)
          TextButton(
            onPressed: () => Navigator.pop(context, OpenBreedingRecord()),
            child: Text(context.l10n.breedingRecord),
          )
        else
          TextButton(
            onPressed: () => _confirmDelete
                ? Navigator.pop(context, DeleteCalf())
                : setState(() => _confirmDelete = true),
            style: TextButton.styleFrom(foregroundColor: context.farm.danger),
            child: Text(
              _confirmDelete
                  ? context.l10n.tapAgainToDelete
                  : context.l10n.delete,
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(onPressed: _save, child: Text(context.l10n.save)),
      ],
    );
  }
}
