import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'breeding_schema.dart';
import 'breeding_logic.dart';

/// Drop this into a cow's detail screen. Shows where she is in the cycle
/// and exposes only the one action that's relevant right now.
class BreedingStatusCard extends StatelessWidget {
  final AppDatabase db;
  final int cowId;

  const BreedingStatusCard({super.key, required this.db, required this.cowId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BreedingCycle?>(
      stream: db.watchActiveBreedingCycle(cowId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: ListTile(title: Text(context.l10n.loadingBreeding)),
          );
        }

        final cycle = snapshot.data;
        if (cycle == null) {
          return Card(
            child: ListTile(
              title: Text(context.l10n.noActiveCycle),
              subtitle: Text(context.l10n.logHeatToStart),
              trailing: FilledButton(
                onPressed: () => _logHeat(context),
                child: Text(context.l10n.logHeat),
              ),
            ),
          );
        }

        final displayStage = deriveDisplayStage(
          now: DateTime.now(),
          serviceDate: cycle.serviceDate,
          check1Result: cycle.check1Result,
          check2Result: cycle.check2Result,
          check3Result: cycle.check3Result,
          actualCalvingDate: cycle.actualCalvingDate,
          gestationDays: cycle.gestationDays,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stageText(context.l10n, displayStage),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (cycle.expectedCalvingDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.expectedCalving(
                      _formatDate(cycle.expectedCalvingDate!),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                _buildActionRow(context, cycle, displayStage),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    BreedingCycle cycle,
    BreedingStage stage,
  ) {
    switch (stage) {
      case BreedingStage.awaitingService:
        return FilledButton(
          onPressed: () => _logService(context, cycle),
          child: Text(context.l10n.logServiceDate),
        );
      case BreedingStage.awaitingCheck1:
        return _checkButtons(context, cycle, 1);
      case BreedingStage.awaitingCheck2:
        return _checkButtons(context, cycle, 2);
      case BreedingStage.awaitingCheck3:
        return _checkButtons(context, cycle, 3);
      case BreedingStage.confirmedPregnant:
      case BreedingStage.dryOff:
      case BreedingStage.prep4Weeks:
      case BreedingStage.prep2Weeks:
      case BreedingStage.prep1Week:
        return FilledButton(
          onPressed: () => _logCalving(context, cycle),
          child: Text(context.l10n.logCalving),
        );
      case BreedingStage.calved:
        return Row(
          children: [
            FilledButton(
              onPressed: () => _promptFemale(context, cycle),
              child: Text(context.l10n.femaleKeep),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _promptSell(context, cycle),
              child: Text(context.l10n.maleSell),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _checkButtons(BuildContext context, BreedingCycle cycle, int n) {
    return Row(
      children: [
        FilledButton(
          onPressed: () => _logCheck(context, cycle, n, passed: true),
          child: Text(context.l10n.checkSuccess(n)),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => _logCheck(context, cycle, n, passed: false),
          child: Text(context.l10n.outcomeReturnedToHeat),
        ),
      ],
    );
  }

  /// Asks the farmer for the date (defaults to today, never in the future).
  /// [earliest] stops dates that come before the previous step. Returns
  /// null when the farmer cancels.
  Future<DateTime?> _pickDate(
    BuildContext context, {
    required String help,
    DateTime? earliest,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var first = earliest == null
        ? today.subtract(const Duration(days: 365))
        : DateTime(earliest.year, earliest.month, earliest.day);
    if (first.isAfter(today)) first = today;

    return showDatePicker(
      context: context,
      initialDate: today,
      firstDate: first,
      lastDate: today,
      helpText: help,
    );
  }

  Future<void> _logHeat(BuildContext context) async {
    final date = await _pickDate(context, help: context.l10n.dateHeatSeen);
    if (date == null) return;
    await db.startBreedingCycle(cowId: cowId, heatDate: date);
  }

  Future<void> _logService(BuildContext context, BreedingCycle cycle) async {
    final date = await _pickDate(
      context,
      help: context.l10n.dateOfService,
      earliest: cycle.heatDate,
    );
    if (date == null) return;
    await db.recordService(cycle.id, date);
  }

  Future<void> _logCheck(
    BuildContext context,
    BreedingCycle cycle,
    int n, {
    required bool passed,
  }) async {
    final date = await _pickDate(
      context,
      help: context.l10n.dateOfCheck(n),
      earliest: cycle.serviceDate,
    );
    if (date == null) return;
    await db.recordPregnancyCheck(
      cycleId: cycle.id,
      checkNumber: n,
      passed: passed,
      checkDate: date,
    );
  }

  Future<void> _logCalving(BuildContext context, BreedingCycle cycle) async {
    final date = await _pickDate(
      context,
      help: context.l10n.calvingDate,
      earliest: cycle.serviceDate,
    );
    if (date == null) return;
    await db.recordCalving(cycle.id, date);
  }

  Future<void> _promptFemale(BuildContext context, BreedingCycle cycle) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.nameTheCalf),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(context.l10n.add),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await db.keepFemaleCalf(
        cycleId: cycle.id,
        damCowId: cycle.cowId,
        calfName: name,
      );
    }
  }

  Future<void> _promptSell(BuildContext context, BreedingCycle cycle) async {
    final controller = TextEditingController();
    final amountStr = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.saleAmount),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(context.l10n.sell),
          ),
        ],
      ),
    );
    final amount = double.tryParse(amountStr ?? '');
    if (amount != null) {
      await db.sellCalf(
        cycleId: cycle.id,
        cowId: cycle.cowId,
        amount: amount,
        saleDate: DateTime.now(),
      );
    }
  }

  String _formatDate(DateTime d) => shortDate(d);
}
