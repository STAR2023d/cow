import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/breeding/breeding_status_card.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// One cow's breeding page: where she is now, plus her past cycles.
class BreedingScreen extends StatelessWidget {
  final int cowId;
  final String cowName;

  const BreedingScreen({super.key, required this.cowId, required this.cowName});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cowBreeding(cowName))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BreedingStatusCard(db: db, cowId: cowId),
          const SizedBox(height: 24),
          Text(
            context.l10n.history,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<BreedingCycle>>(
            stream: db.watchBreedingHistory(cowId),
            builder: (context, snapshot) {
              final past = (snapshot.data ?? [])
                  .where((c) => !c.isActive)
                  .toList();
              if (past.isEmpty) {
                return Text(
                  context.l10n.noPastCycles,
                  style: TextStyle(color: context.farm.muted),
                );
              }
              return Column(
                children: past.map((c) => _HistoryTile(cycle: c)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final BreedingCycle cycle;

  const _HistoryTile({required this.cycle});

  String _outcome(BuildContext context) {
    switch (cycle.stage) {
      case BreedingStage.failed:
        return context.l10n.outcomeReturnedToHeat;
      case BreedingStage.keptAsHeifer:
        return context.l10n.outcomeHeiferKept;
      case BreedingStage.soldCalf:
        return context.l10n.outcomeCalfSold;
      default:
        return context.l10n.outcomeClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = <String>[
      context.l10n.heatOn(shortDate(cycle.heatDate)),
      if (cycle.serviceDate != null)
        context.l10n.servedOn(shortDate(cycle.serviceDate!)),
      if (cycle.actualCalvingDate != null)
        context.l10n.calvedOn(shortDate(cycle.actualCalvingDate!)),
      if (cycle.saleAmount != null)
        context.l10n.calfSoldFor(ksh(cycle.saleAmount!)),
    ];

    return Card(
      child: ListTile(
        title: Text(_outcome(context)),
        subtitle: Text(lines.join('\n')),
        isThreeLine: lines.length > 2,
      ),
    );
  }
}
