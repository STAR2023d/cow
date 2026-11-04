import 'package:cow/database/app_database.dart';
import 'package:cow/screens/main_dashboard.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

const List<String> healthRecordTypes = [
  'Vaccination',
  'Illness',
  'Checkup',
  'Treatment',
  'Deworming',
  'Other',
];

class HealthScreen extends StatelessWidget {
  final AppDatabase db;

  const HealthScreen({super.key, required this.db});

  Future<void> _openAddDialog(BuildContext context) async {
    final cows = await db.select(db.cow).get();
    if (!context.mounted) return;

    if (cows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a cow before logging a health record.'),
        ),
      );
      return;
    }

    final cowController = ValueNotifier<int>(cows.first.id);
    final typeController = ValueNotifier<String>(healthRecordTypes.first);
    final followUpController = ValueNotifier<DateTime?>(null);
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: MainDashboard.cardNavy,
          title: const Text(
            'Log Health Record',
            style: TextStyle(color: Colors.white),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: cowController,
                    builder: (context, value, _) =>
                        DropdownButtonFormField<int>(
                          initialValue: value,
                          dropdownColor: MainDashboard.cardNavy,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Cow'),
                          items: cows
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => cowController.value = v!,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<String>(
                    valueListenable: typeController,
                    builder: (context, value, _) =>
                        DropdownButtonFormField<String>(
                          initialValue: value,
                          dropdownColor: MainDashboard.cardNavy,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Record Type',
                          ),
                          items: healthRecordTypes
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (v) => typeController.value = v!,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter a description' : null,
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: followUpController,
                    builder: (context, value, _) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        value == null
                            ? 'No follow-up date'
                            : 'Follow-up: ${value.day}/${value.month}/${value.year}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(
                            const Duration(days: 7),
                          ),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) followUpController.value = picked;
                      },
                    ),
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
                await db.insertHealthRecord(
                  HealthRecordCompanion.insert(
                    date: DateTime.now(),
                    cowId: cowController.value,
                    recordType: typeController.value,
                    description: descriptionController.text,
                    followUpDate: drift.Value(followUpController.value),
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
      backgroundColor: MainDashboard.primaryNavy,
      appBar: AppBar(title: const Text('Health'), centerTitle: true),
      body: StreamBuilder<List<HealthRecordData>>(
        stream: db.watchHealthRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.health_and_safety, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No health records yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final r = records[index];
                  final cowName = cowsById[r.cowId] ?? 'Unknown cow';
                  return Card(
                    color: MainDashboard.cardNavy,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black26,
                        child: Icon(
                          _iconFor(r.recordType),
                          color: Colors.orangeAccent,
                        ),
                      ),
                      title: Text(
                        '$cowName • ${r.recordType}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${r.description}\n${r.date.day}/${r.date.month}/${r.date.year}'
                        '${r.followUpDate != null ? '  •  Follow-up: ${r.followUpDate!.day}/${r.followUpDate!.month}/${r.followUpDate!.year}' : ''}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => db.deleteHealthRecord(r.id),
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
        label: const Text('Log Record'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  IconData _iconFor(String recordType) {
    switch (recordType) {
      case 'Vaccination':
        return Icons.vaccines;
      case 'Illness':
        return Icons.sick;
      case 'Checkup':
        return Icons.medical_services;
      case 'Treatment':
        return Icons.healing;
      case 'Deworming':
        return Icons.bug_report;
      default:
        return Icons.health_and_safety;
    }
  }
}
