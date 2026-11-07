import 'package:cow/breeding/breeding_labels.dart';
import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_schema.dart';
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
              final rows = _buildRows(cowSnap.data!, cycleSnap.data!);
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

  List<_Row> _buildRows(List<CowData> cows, List<BreedingCycle> cycles) {
    final now = DateTime.now();

    // Newest open cycle per cow.
    final byCow = <int, BreedingCycle>{};
    for (final c in cycles) {
      final existing = byCow[c.cowId];
      if (existing == null || c.createdAt.isAfter(existing.createdAt)) {
        byCow[c.cowId] = c;
      }
    }

    final rows = cows.map((cow) {
      final cycle = byCow[cow.id];
      if (cycle == null) return _Row(cow);

      final stage = deriveDisplayStage(
        now: now,
        serviceDate: cycle.serviceDate,
        check1Result: cycle.check1Result,
        check2Result: cycle.check2Result,
        check3Result: cycle.check3Result,
        actualCalvingDate: cycle.actualCalvingDate,
        gestationDays: cycle.gestationDays,
      );
      final milestone = nextMilestone(
        stage: stage,
        serviceDate: cycle.serviceDate,
        gestationDays: cycle.gestationDays,
        expectedCalvingDate: cycle.expectedCalvingDate,
      );
      return _Row(cow, stage: stage, milestone: milestone);
    }).toList();

    // 0 = has a dated milestone, 1 = open cycle without a date, 2 = idle.
    int group(_Row r) {
      if (r.stage == null) return 2;
      return r.milestone?.date != null ? 0 : 1;
    }

    rows.sort((a, b) {
      final g = group(a).compareTo(group(b));
      if (g != 0) return g;
      if (group(a) == 0) {
        return a.milestone!.date!.compareTo(b.milestone!.date!);
      }
      return a.cow.name.toLowerCase().compareTo(b.cow.name.toLowerCase());
    });
    return rows;
  }
}

class _Row {
  final CowData cow;
  final BreedingStage? stage;
  final BreedingMilestone? milestone;

  const _Row(this.cow, {this.stage, this.milestone});
}

class _CowBreedingTile extends StatelessWidget {
  final _Row row;

  const _CowBreedingTile({required this.row});

  static final _fmt = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final milestone = row.milestone;
    final due = milestone?.date;

    String? milestoneText;
    var milestoneColor = Colors.white70;

    if (milestone != null) {
      if (due == null) {
        milestoneText = milestone.label;
      } else {
        final now = DateTime.now();
        final days = DateTime.utc(
          due.year,
          due.month,
          due.day,
        ).difference(DateTime.utc(now.year, now.month, now.day)).inDays;
        final when = switch (days) {
          < 0 => '${-days} ${-days == 1 ? 'day' : 'days'} overdue',
          0 => 'today',
          1 => 'tomorrow',
          _ => 'in $days days',
        };
        milestoneText = '${milestone.label}: ${_fmt.format(due)} • $when';
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
