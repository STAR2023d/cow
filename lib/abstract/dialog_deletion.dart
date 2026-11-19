// Removing a cow: she either left the farm (records stay) or was added by
// mistake (she and all her records are deleted).

import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// The word shown for a stored [cowLeftReasons] value.
String cowLeftReasonLabel(BuildContext context, String? reason) =>
    switch (reason) {
      'sold' => context.l10n.leftReasonSold,
      'died' => context.l10n.leftReasonDied,
      'culled' => context.l10n.leftReasonCulled,
      'given_away' => context.l10n.leftReasonGivenAway,
      _ => context.l10n.leftTheHerd,
    };

enum _Stage { choose, leave, delete, working }

class CowRemoveDialog extends StatefulWidget {
  final CowData cow;
  final Future<int> Function() recordCount;
  final Future<void> Function(String reason, DateTime on) onLeft;
  final Future<void> Function() onDelete;

  const CowRemoveDialog({
    super.key,
    required this.cow,
    required this.recordCount,
    required this.onLeft,
    required this.onDelete,
  });

  @override
  State<CowRemoveDialog> createState() => _CowRemoveDialogState();
}

class _CowRemoveDialogState extends State<CowRemoveDialog> {
  _Stage _stage = _Stage.choose;
  String _reason = cowLeftReasons.first;
  DateTime _on = DateTime.now();
  int? _count;

  Future<void> _openDelete() async {
    setState(() => _stage = _Stage.delete);
    final n = await widget.recordCount();
    if (mounted) setState(() => _count = n);
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _stage = _Stage.working);
    await action();
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _on,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _on = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final name = widget.cow.name;
    final cancel = TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: Text(l.cancel, style: TextStyle(color: context.farm.muted)),
    );

    return switch (_stage) {
      _Stage.choose => AlertDialog(
        icon: Icon(Icons.logout_rounded, color: context.farm.warning, size: 48),
        title: Text(l.removeCowTitle),
        content: Text(l.removeCowQuestion(name), textAlign: TextAlign.center),
        actionsOverflowDirection: VerticalDirection.up,
        actions: [
          cancel,
          TextButton(
            onPressed: _openDelete,
            child: Text(
              l.addedByMistakeButton,
              style: TextStyle(color: context.farm.danger),
            ),
          ),
          FilledButton(
            onPressed: () => setState(() => _stage = _Stage.leave),
            child: Text(l.leftFarmButton),
          ),
        ],
      ),
      _Stage.leave => AlertDialog(
        title: Text(l.leftReasonQuestion(name)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in cowLeftReasons)
                  ChoiceChip(
                    label: Text(cowLeftReasonLabel(context, r)),
                    selected: _reason == r,
                    onSelected: (_) => setState(() => _reason = r),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_rounded, size: 18),
              label: Text(l.leftOnDate(shortDate(_on))),
            ),
            const SizedBox(height: 12),
            Text(
              l.leftKeepsRecords,
              style: TextStyle(color: context.farm.muted, fontSize: 13),
            ),
          ],
        ),
        actions: [
          cancel,
          FilledButton(
            onPressed: () => _run(() => widget.onLeft(_reason, _on)),
            child: Text(l.save),
          ),
        ],
      ),
      _Stage.delete => AlertDialog(
        icon: Icon(
          Icons.report_problem_rounded,
          color: context.farm.danger,
          size: 48,
        ),
        title: Text(
          l.cannotBeUndoneTitle,
          style: TextStyle(color: context.farm.danger),
        ),
        content: _count == null
            ? const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator()),
              )
            : Text(
                l.deleteCowWarning(name, _count!),
                textAlign: TextAlign.center,
              ),
        actions: [
          cancel,
          FilledButton(
            onPressed: _count == null ? null : () => _run(widget.onDelete),
            style: FilledButton.styleFrom(
              backgroundColor: context.farm.danger,
              foregroundColor: Colors.white,
            ),
            child: Text(l.deletePermanently),
          ),
        ],
      ),
      _Stage.working => const AlertDialog(content: LinearProgressIndicator()),
    };
  }
}
