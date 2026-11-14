import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/health/health_presets.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' as drift;
import 'package:cow/screens/widgets/undo_delete.dart';
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

String _fmt(DateTime d) => shortDate(d);

class HealthScreen extends StatelessWidget {
  final AppDatabase db;

  const HealthScreen({super.key, required this.db});

  Future<void> _openAddDialog(BuildContext context) async {
    final cows = await db.select(db.cow).get();
    if (!context.mounted) return;

    if (cows.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.addCowFirstHealth)));
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
        descriptionController.text = presetDescription(context.l10n, p);
      }
      followUpController.value = p.followUpFrom(dateController.value);
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.logHealthRecord, style: TextStyle()),
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
                          label: Text(presetLabel(context.l10n, p)),
                          onPressed: () => applyPreset(p),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.presetsNote,
                    style: TextStyle(color: context.farm.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: cowController,
                    builder: (context, value, _) =>
                        DropdownButtonFormField<int>(
                          initialValue: value,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            labelText: context.l10n.cow,
                          ),
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
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            labelText: context.l10n.recordType,
                          ),
                          items: healthRecordTypes
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(recordTypeLabel(context.l10n, t)),
                                ),
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
                        context.l10n.dateLine(_fmt(value)),
                        style: TextStyle(color: context.farm.muted),
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                        color: context.farm.muted,
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
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      labelText: context.l10n.description,
                    ),
                    maxLines: 2,
                    maxLength: 300,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? context.l10n.enterDescription
                        : null,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: medicineController,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      labelText: context.l10n.medicineOptional,
                    ),
                    maxLength: 80,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: withdrawalController,
                    style: const TextStyle(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.withdrawalDaysOptional,
                      helperText: context.l10n.withdrawalHelper,
                      helperMaxLines: 2,
                      helperStyle: TextStyle(color: context.farm.muted),
                    ),
                    validator: (v) {
                      final text = v?.trim() ?? '';
                      if (text.isEmpty) return null;
                      final days = int.tryParse(text);
                      if (days == null || days < 1 || days > 60) {
                        return context.l10n.enter1to60;
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
                            ? context.l10n.noFollowUp
                            : context.l10n.followUpOn(_fmt(value)),
                        style: TextStyle(color: context.farm.muted),
                      ),
                      trailing: value == null
                          ? Icon(
                              Icons.calendar_today,
                              color: context.farm.muted,
                            )
                          : IconButton(
                              tooltip: context.l10n.removeFollowUp,
                              icon: Icon(
                                Icons.close,
                                color: context.farm.muted,
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
              child: Text(context.l10n.cancel),
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
      appBar: AppBar(title: Text(context.l10n.navHealth), centerTitle: true),
      body: StreamBuilder<List<HealthRecordData>>(
        stream: db.watchHealthRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 64,
                    color: context.farm.muted,
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noHealthRecords,
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
                  final cowName = cowsById[r.cowId] ?? context.l10n.unknownCow;
                  final withdrawal = milkWithdrawalOf(r);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black26,
                        child: Icon(
                          _iconFor(r.recordType),
                          color: context.farm.warning,
                        ),
                      ),
                      title: Text(
                        '$cowName • ${recordTypeLabel(context.l10n, r.recordType)}',
                        style: const TextStyle(),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.description,
                            style: TextStyle(color: context.farm.muted),
                          ),
                          if (r.medicine != null && r.medicine!.isNotEmpty)
                            Text(
                              context.l10n.medicineLine(r.medicine!),
                              style: TextStyle(color: context.farm.muted),
                            ),
                          Text(
                            _fmt(r.date) +
                                (r.followUpDate != null
                                    ? '  •  ${context.l10n.followUpOn(_fmt(r.followUpDate!))}'
                                    : ''),
                            style: TextStyle(color: context.farm.muted),
                          ),
                          if (withdrawal != null)
                            _WithdrawalLine(withdrawal: withdrawal, now: now),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: context.farm.danger,
                        ),
                        tooltip: context.l10n.delete,
                        onPressed: () => deleteWithUndo(
                          context,
                          what: context.l10n.healthRecordWhat,
                          delete: () => db.deleteHealthRecord(r.id),
                          restore: () => db.restoreHealthRecord(r),
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
        label: Text(context.l10n.logRecord),
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
          context.l10n.milkHoldEnded(_fmt(withdrawal.lastWithheldDay)),
          style: TextStyle(color: context.farm.muted),
        ),
      );
    }

    final left = withdrawal.daysLeft(now);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(Icons.block, size: 16, color: context.farm.warning),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              context.l10n.milkOnHoldSafeFrom(left, _fmt(withdrawal.safeFrom)),
              style: TextStyle(
                color: context.farm.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
