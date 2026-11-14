import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' as drift;
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
          title: const Text(
            'Log Feeding',
            style: TextStyle(),
          ),
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
                          decoration: const InputDecoration(
                            labelText: 'Feed Type',
                          ),
                          items: feedTypes
                              .map(
                                (f) =>
                                    DropdownMenuItem(value: f, child: Text(f)),
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
                          decoration: const InputDecoration(
                            labelText: 'Cow (optional)',
                            hintText: 'Whole herd',
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Whole herd'),
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
                    decoration: const InputDecoration(
                      labelText: 'Quantity (kg)',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter a quantity';
                      if (double.tryParse(v) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesController,
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
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
              child: const Text('Cancel'),
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feeding'), centerTitle: true),
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
                    'No feeding records yet',
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
                      ? (cowsById[log.cowId] ?? 'Unknown cow')
                      : 'Whole herd';
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
                        '${log.feedType} • ${log.quantityKg.toStringAsFixed(1)} kg',
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
                        onPressed: () => db.deleteFeedingLog(log.id),
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
        label: const Text('Log Feeding'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
