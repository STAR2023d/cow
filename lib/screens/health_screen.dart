import 'package:cow/database/app_database.dart';
import 'package:cow/health/health_presets.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

const List<String> healthRecordTypes = [
  'Vaccination',
  'Illness',
  'Checkup',
  'Treatment',
  'Deworming',
  'Tick control',
  'Hoof care',
  'Other',
];

String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

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
    final dateController = ValueNotifier<DateTime>(DateTime.now());
    final followUpController = ValueNotifier<DateTime?>(null);
    final descriptionController = TextEditingController();
    final medicineController = TextEditingController();
    final withdrawalController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Fills type, description and a suggested follow-up. A description the
    // farmer typed is kept; only an empty one or an earlier preset's is
    // replaced.
    void applyPreset(HealthPreset p) {
      typeController.value = p.recordType;
      final current = descriptionController.text.trim();
      if (current.isEmpty ||
          healthPresets.any((x) => x.description == current)) {
        descriptionController.text = p.description;
      }
      followUpController.value = p.followUpFrom(dateController.value);
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
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
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final p in healthPresets)
                        ActionChip(
                          label: Text(p.label),
                          onPressed: () => applyPreset(p),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Presets only suggest a follow-up date. Change it as '
                    'needed: your vet\'s advice comes first.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: cowController,
                    builder: (context, value, _) =>
                        DropdownButtonFormField<int>(
                          initialValue: value,
                          dropdownColor: AppColors.card,
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
                          key: ValueKey(value),
                          initialValue: value,
                          dropdownColor: AppColors.card,
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
                  ValueListenableBuilder<DateTime>(
                    valueListenable: dateController,
                    builder: (context, value, _) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Date: ${_fmt(value)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) dateController.value = picked;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                    maxLength: 300,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter a description'
                        : null,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: medicineController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Medicine (optional)',
                    ),
                    maxLength: 80,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: withdrawalController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Milk withdrawal days (optional)',
                      helperText:
                          'From the medicine label or your vet. The app only '
                          'counts the days you enter.',
                      helperMaxLines: 2,
                      helperStyle: TextStyle(color: Colors.white38),
                    ),
                    validator: (v) {
                      final text = v?.trim() ?? '';
                      if (text.isEmpty) return null;
                      final days = int.tryParse(text);
                      if (days == null || days < 1 || days > 60) {
                        return 'Enter 1 to 60 days';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: followUpController,
                    builder: (context, value, _) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        value == null
                            ? 'No follow-up date'
                            : 'Follow-up: ${_fmt(value)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: value == null
                          ? const Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                            )
                          : IconButton(
                              tooltip: 'Remove follow-up',
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                              ),
                              onPressed: () => followUpController.value = null,
                            ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              value ??
                              DateTime.now().add(const Duration(days: 7)),
                          // Past dates allowed: a backdated record's
                          // follow-up may already be due.
                          firstDate: DateTime(2020),
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
                final medicine = medicineController.text.trim();
                await db.insertHealthRecord(
                  HealthRecordCompanion.insert(
                    date: dateController.value,
                    cowId: cowController.value,
                    recordType: typeController.value,
                    description: descriptionController.text.trim(),
                    followUpDate: drift.Value(followUpController.value),
                    medicine: drift.Value(medicine.isEmpty ? null : medicine),
                    milkWithdrawalDays: drift.Value(
                      int.tryParse(withdrawalController.text.trim()),
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
      backgroundColor: AppColors.background,
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
              final now = DateTime.now();
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
                  final withdrawal = milkWithdrawalOf(r);
                  return Card(
                    color: AppColors.card,
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.description,
                            style: const TextStyle(color: Colors.white60),
                          ),
                          if (r.medicine != null && r.medicine!.isNotEmpty)
                            Text(
                              'Medicine: ${r.medicine}',
                              style: const TextStyle(color: Colors.white60),
                            ),
                          Text(
                            _fmt(r.date) +
                                (r.followUpDate != null
                                    ? '  •  Follow-up: ${_fmt(r.followUpDate!)}'
                                    : ''),
                            style: const TextStyle(color: Colors.white60),
                          ),
                          if (withdrawal != null)
                            _WithdrawalLine(withdrawal: withdrawal, now: now),
                        ],
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
      case 'Tick control':
        return Icons.pest_control;
      case 'Hoof care':
        return Icons.content_cut;
      default:
        return Icons.health_and_safety;
    }
  }
}

class _WithdrawalLine extends StatelessWidget {
  final MilkWithdrawal withdrawal;
  final DateTime now;

  const _WithdrawalLine({required this.withdrawal, required this.now});

  @override
  Widget build(BuildContext context) {
    if (!withdrawal.isActiveOn(now)) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'Milk hold ended ${_fmt(withdrawal.lastWithheldDay)}',
          style: const TextStyle(color: Colors.white38),
        ),
      );
    }

    final left = withdrawal.daysLeft(now);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.block, size: 16, color: Colors.orangeAccent),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Milk on hold: safe from ${_fmt(withdrawal.safeFrom)} '
              '($left ${left == 1 ? 'day' : 'days'} left)',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
