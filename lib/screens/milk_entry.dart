import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/edit_milk_entry_dialog.dart';
import 'package:cow/screens/widgets/milk_hold_banner.dart';
import 'package:cow/screens/widgets/milk_log_form.dart';
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// One cow's milk: the same form as the Log milk sheet (for her alone),
/// and her saved entries below, which can be changed or deleted.
class MilkData extends StatelessWidget {
  final int cowId;
  final String cowName;

  /// The current time; replaced in tests.
  final DateTime Function() clock;

  const MilkData({
    super.key,
    required this.cowId,
    required this.cowName,
    this.clock = _now,
  });

  static DateTime _now() => DateTime.now();

  @override
  Widget build(BuildContext context) {
    final database = context.read<AppDatabase>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.milkEntryFor(cowName))),
      body: ListView(
        children: [
          MilkHoldBanner(cowId: cowId),
          MilkLogForm(
            db: database,
            cowId: cowId,
            clock: clock,
            onSaved: (_, _, total) =>
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.savedAmount(litres(total))),
                  ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Icon(Icons.history, color: context.farm.muted),
                const SizedBox(width: 8),
                Text(
                  context.l10n.historyLog,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.farm.muted,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<List<MilkTableData>>(
            stream: database.watchEntriesForCow(cowId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final history = snapshot.data ?? [];
              if (history.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      context.l10n.noMilkEntriesForCow,
                      style: TextStyle(color: context.farm.muted),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (final entry in history)
                    _HistoryCard(database: database, entry: entry),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// One saved milk entry; tap or the pencil to change it, bin to delete.
class _HistoryCard extends StatelessWidget {
  final AppDatabase database;
  final MilkTableData entry;

  const _HistoryCard({required this.database, required this.entry});

  @override
  Widget build(BuildContext context) {
    final formattedDate = dateTime(entry.entryDate);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        onTap: () => _edit(context, formattedDate),
        leading: CircleAvatar(
          backgroundColor: context.farm.info.withValues(alpha: 0.15),
          child: Icon(Icons.opacity, color: context.farm.info),
        ),
        title: Text(
          litres(entry.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          entry.buyer == null
              ? formattedDate
              : '$formattedDate • ${entry.buyer}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                sessionLabel(context.l10n, entry.session).toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              tooltip: context.l10n.editEntry,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _edit(context, formattedDate),
            ),
            IconButton(
              tooltip: context.l10n.deleteEntry,
              icon: Icon(Icons.delete_outline, color: context.farm.danger),
              onPressed: () => deleteWithUndo(
                context,
                what: context.l10n.milkEntryWhat,
                delete: () => database.deleteMilkEntry(entry.id),
                restore: () => database.restoreMilkEntry(entry),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, String when) async {
    final edit = await showDialog<MilkEntryEdit>(
      context: context,
      builder: (_) => EditMilkEntryDialog(
        amount: entry.amount,
        buyer: entry.buyer,
        label:
            '${sessionLabel(context.l10n, entry.session).toUpperCase()} • $when',
      ),
    );
    if (edit == null) return;
    await database.updateMilkEntry(
      entry.id,
      amount: edit.amount,
      buyer: edit.buyer,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.milkEntryUpdated)));
  }
}
