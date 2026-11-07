import 'package:cow/breeding/breeding_labels.dart';
import 'package:cow/breeding/breeding_rows.dart';
import 'package:cow/breeding/breeding_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Herd-wide breeding view: every cow, her current stage, and what is
/// due next. The most urgent dates come first.
class BreedingOverviewScreen extends StatelessWidget {
  const BreedingOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Herd Breeding')),
      body: StreamBuilder<List<CowData>>(
        stream: db.watchAllCow(),
        builder: (context, cowSnap) {
          return StreamBuilder<List<BreedingCycle>>(
            stream: db.watchAllActiveBreedingCycles(),
            builder: (context, cycleSnap) {
              if (!cowSnap.hasData || !cycleSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final rows = buildBreedingRows(cowSnap.data!, cycleSnap.data!);
              if (rows.isEmpty) {
                return const Center(
                  child: Text(
                    'No cows yet',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                itemBuilder: (context, i) => _CowBreedingTile(row: rows[i]),
              );
            },
          );
        },
      ),
    );
  }
}

class _CowBreedingTile extends StatelessWidget {
  final BreedingRow row;

  const _CowBreedingTile({required this.row});

  static final _fmt = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final milestone = row.milestone;
    final due = milestone?.date;
    final days = row.daysUntilDue(DateTime.now());

    String? milestoneText;
    var milestoneColor = Colors.white70;

    if (milestone != null) {
      if (due == null || days == null) {
        milestoneText = milestone.label;
      } else {
        milestoneText =
            '${milestone.label}: ${_fmt.format(due)} • ${dueLabel(days)}';
        if (days < 0) {
          milestoneColor = Colors.redAccent;
        } else if (days <= 7) {
          milestoneColor = Colors.orangeAccent;
        }
      }
    }

    return Card(
      child: ListTile(
        leading: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
        title: Text(row.cow.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(row.stage?.label ?? 'No active breeding cycle'),
            if (milestoneText != null)
              Text(milestoneText, style: TextStyle(color: milestoneColor)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BreedingScreen(cowId: row.cow.id, cowName: row.cow.name),
          ),
        ),
      ),
    );
  }
}
