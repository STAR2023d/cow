import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' as drift;
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:flutter/material.dart';

const List<String> feedTypes = [
  'Hay',
  'Silage',
  'Concentrate',
  'Pasture',
  'Mineral Supplement',
  'Dairy Meal',
  'Other',
];

class FeedingScreen extends StatelessWidget {
  final AppDatabase db;

  const FeedingScreen({super.key, required this.db});

  Future<void> _openAddDialog(BuildContext context) async {
    final cows = await db.select(db.cow).get();
    if (!context.mounted) return;

    final feedTypeController = ValueNotifier<String>(feedTypes.first);
    final cowController = ValueNotifier<int?>(null); // null = whole herd
    final quantityController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.logFeeding, style: TextStyle()),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: feedTypeController,
                    builder: (context, value, _) =>
                        DropdownButtonFormField<String>(
                          initialValue: value,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            labelText: context.l10n.feedType,
                          ),
                          items: feedTypes
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(feedTypeLabel(context.l10n, f)),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => feedTypeController.value = v!,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<int?>(
                    valueListenable: cowController,
                    builder: (context, value, _) =>
                        DropdownButtonFormField<int?>(
                          initialValue: value,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            labelText: context.l10n.cowOptional,
                            hintText: context.l10n.wholeHerd,
                          ),
                          items: [
                            DropdownMenuItem<int?>(
                              value: null,
                              child: Text(context.l10n.wholeHerd),
                            ),
                            ...cows.map(
                              (c) => DropdownMenuItem<int?>(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            ),
                          ],
                          onChanged: (v) => cowController.value = v,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      labelText: context.l10n.quantityKg,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return context.l10n.enterQuantity;
                      }
                      if (double.tryParse(v) == null) {
                        return context.l10n.enterValidNumberShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesController,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      labelText: context.l10n.notesOptional,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await db.insertFeedingLog(
                  FeedingLogCompanion.insert(
                    date: DateTime.now(),
                    feedType: feedTypeController.value,
                    quantityKg: double.parse(quantityController.text),
                    cowId: drift.Value(cowController.value),
                    notes: drift.Value(
                      notesController.text.isEmpty
                          ? null
                          : notesController.text,
                    ),
                  ),
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navFeeding), centerTitle: true),
      body: StreamBuilder<List<FeedingLogData>>(
        stream: db.watchFeedingLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final logs = snapshot.data ?? [];
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grass, size: 64, color: context.farm.muted),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noFeedingRecords,
                    style: TextStyle(fontSize: 18, color: context.farm.muted),
                  ),
                ],
              ),
            );
          }
          return FutureBuilder<List<CowData>>(
            future: db.select(db.cow).get(),
            builder: (context, cowSnapshot) {
              final cowsById = {
                for (final c in cowSnapshot.data ?? <CowData>[]) c.id: c.name,
              };
              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: 84,
                ),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final cowName = log.cowId != null
                      ? (cowsById[log.cowId] ?? context.l10n.unknownCow)
                      : context.l10n.wholeHerd;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black26,
                        child: Icon(Icons.grass, color: context.farm.good),
                      ),
                      title: Text(
                        '${feedTypeLabel(context.l10n, log.feedType)} • ${log.quantityKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(),
                      ),
                      subtitle: Text(
                        '$cowName  •  ${shortDate(log.date)}'
                        '${log.notes != null ? '\n${log.notes}' : ''}',
                        style: TextStyle(color: context.farm.muted),
                      ),
                      isThreeLine: log.notes != null,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: context.farm.danger,
                        ),
                        tooltip: context.l10n.delete,
                        onPressed: () => deleteWithUndo(
                          context,
                          what: context.l10n.feedingRecordWhat,
                          delete: () => db.deleteFeedingLog(log.id),
                          restore: () => db.restoreFeedingLog(log),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddDialog(context),
        label: Text(context.l10n.logFeeding),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
