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
          return const Card(
            child: ListTile(title: Text('Loading breeding status...')),
          );
        }

        final cycle = snapshot.data;
        if (cycle == null) {
          return Card(
            child: ListTile(
              title: const Text('No active breeding cycle'),
              subtitle: const Text('Log heat signs to start one'),
              trailing: FilledButton(
                onPressed: () => db.startBreedingCycle(
                  cowId: cowId,
                  heatDate: DateTime.now(),
                ),
                child: const Text('Log heat'),
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
                  _stageLabel(displayStage),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (cycle.expectedCalvingDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Expected calving: ${_formatDate(cycle.expectedCalvingDate!)}',
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
          onPressed: () => db.recordService(cycle.id, DateTime.now()),
          child: const Text('Log service date'),
        );
      case BreedingStage.awaitingCheck1:
        return _checkButtons(1, cycle.id);
      case BreedingStage.awaitingCheck2:
        return _checkButtons(2, cycle.id);
      case BreedingStage.awaitingCheck3:
        return _checkButtons(3, cycle.id);
      case BreedingStage.confirmedPregnant:
      case BreedingStage.dryOff:
      case BreedingStage.prep4Weeks:
      case BreedingStage.prep2Weeks:
      case BreedingStage.prep1Week:
        return FilledButton(
          onPressed: () => db.recordCalving(cycle.id, DateTime.now()),
          child: const Text('Log calving'),
        );
      case BreedingStage.calved:
        return Row(
          children: [
            FilledButton(
              onPressed: () => _promptFemale(context, cycle),
              child: const Text('Female — keep'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _promptSell(context, cycle),
              child: const Text('Male — sell'),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _checkButtons(int checkNumber, int cycleId) {
    return Row(
      children: [
        FilledButton(
          onPressed: () => db.recordPregnancyCheck(
            cycleId: cycleId,
            checkNumber: checkNumber,
            passed: true,
            checkDate: DateTime.now(),
          ),
          child: Text('Check $checkNumber: success'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => db.recordPregnancyCheck(
            cycleId: cycleId,
            checkNumber: checkNumber,
            passed: false,
            checkDate: DateTime.now(),
          ),
          child: const Text('Returned to heat'),
        ),
      ],
    );
  }

  Future<void> _promptFemale(BuildContext context, BreedingCycle cycle) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Name the calf'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Add'),
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
        title: const Text('Sale amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Sell'),
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

  String _stageLabel(BreedingStage stage) {
    return switch (stage) {
      BreedingStage.awaitingService => 'Heat detected — awaiting service',
      BreedingStage.awaitingCheck1 => 'Awaiting 21-day pregnancy check',
      BreedingStage.awaitingCheck2 => 'Awaiting 42-day pregnancy check',
      BreedingStage.awaitingCheck3 => 'Awaiting 63-day pregnancy check',
      BreedingStage.confirmedPregnant =>
        'Pregnancy confirmed — counting down to calving',
      BreedingStage.dryOff => 'Dry-off period (8 weeks to calving)',
      BreedingStage.prep4Weeks => '4 weeks to calving — preparation',
      BreedingStage.prep2Weeks => '2 weeks to calving — preparation',
      BreedingStage.prep1Week => '1 week to calving — final preparation',
      BreedingStage.calved => 'Calved — awaiting outcome',
      BreedingStage.keptAsHeifer => 'Calf kept as heifer',
      BreedingStage.soldCalf => 'Calf sold',
      BreedingStage.failed => 'Returned to heat — re-service needed',
    };
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
