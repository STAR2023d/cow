import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/breeding/breeding_status_card.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(title: Text('$cowName • Breeding')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BreedingStatusCard(db: db, cowId: cowId),
          const SizedBox(height: 24),
          const Text(
            'History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<BreedingCycle>>(
            stream: db.watchBreedingHistory(cowId),
            builder: (context, snapshot) {
              final past = (snapshot.data ?? [])
                  .where((c) => !c.isActive)
                  .toList();
              if (past.isEmpty) {
                return const Text(
                  'No past cycles yet',
                  style: TextStyle(color: Colors.white54),
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

  static final _fmt = DateFormat('d MMM yyyy');

  String get _outcome {
    switch (cycle.stage) {
      case BreedingStage.failed:
        return 'Returned to heat';
      case BreedingStage.keptAsHeifer:
        return 'Calved — heifer kept';
      case BreedingStage.soldCalf:
        return 'Calved — calf sold';
      default:
        return 'Closed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = <String>[
      'Heat: ${_fmt.format(cycle.heatDate)}',
      if (cycle.serviceDate != null)
        'Served: ${_fmt.format(cycle.serviceDate!)}',
      if (cycle.actualCalvingDate != null)
        'Calved: ${_fmt.format(cycle.actualCalvingDate!)}',
      if (cycle.saleAmount != null)
        'Calf sold for ${cycle.saleAmount!.toStringAsFixed(0)}',
    ];

    return Card(
      child: ListTile(
        title: Text(_outcome),
        subtitle: Text(lines.join('\n')),
        isThreeLine: lines.length > 2,
      ),
    );
  }
}
