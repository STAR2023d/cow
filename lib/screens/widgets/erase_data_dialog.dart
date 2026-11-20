import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/services/erase_data.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Asks before erasing all farm data. The Erase button only works once
/// the farmer types the confirm word (ERASE / FUTA), so a stray tap can't
/// wipe the farm. [erase] replaces the real erase in tests.
class EraseDataDialog extends StatefulWidget {
  final AppDatabase db;
  final Future<void> Function()? erase;

  const EraseDataDialog({super.key, required this.db, this.erase});

  @override
  State<EraseDataDialog> createState() => _EraseDataDialogState();
}

class _EraseDataDialogState extends State<EraseDataDialog> {
  final _typed = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  Future<void> _erase() async {
    setState(() => _busy = true);
    final erase = widget.erase ?? () => eraseAllFarmData(widget.db);
    await erase();
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final word = l.eraseConfirmWord;
    final ok = _typed.text.trim().toUpperCase() == word;
    return AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: context.farm.danger),
      title: Text(l.eraseAllData),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.eraseWhatGoes),
          const SizedBox(height: 8),
          Text(l.eraseWhatStays, style: TextStyle(color: context.farm.muted)),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('erase-confirm'),
            controller: _typed,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: l.eraseTypeToConfirm(word),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: context.farm.danger),
          onPressed: ok && !_busy ? _erase : null,
          child: Text(l.eraseButton),
        ),
      ],
    );
  }
}

/// Opens [EraseDataDialog]; after an erase, goes back to the home screen,
/// closes the drawer [context] belongs to, and says a backup was saved.
Future<void> showEraseDataDialog(BuildContext context, AppDatabase db) async {
  final done = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => EraseDataDialog(db: db),
  );
  if (done != true || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final text = context.l10n.eraseDone;
  Navigator.popUntil(context, (r) => r.isFirst);
  Scaffold.maybeOf(context)?.closeDrawer();
  messenger.showSnackBar(SnackBar(content: Text(text)));
}
