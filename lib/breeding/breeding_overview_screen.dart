import 'package:cow/l10n/labels.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/breeding/breeding_rows.dart';
import 'package:cow/breeding/breeding_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Herd-wide breeding view: every cow, her current stage, and what is
/// due next. The most urgent dates come first.
class BreedingOverviewScreen extends StatelessWidget {
  const BreedingOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.herdBreeding)),
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
                return Center(
                  child: Text(
                    context.l10n.noCowsYet,
                    style: TextStyle(color: context.farm.muted),
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

  @override
  Widget build(BuildContext context) {
    final milestone = row.milestone;
    final due = milestone?.date;
    final days = row.daysUntilDue(DateTime.now());

    String? msText;
    var milestoneColor = context.farm.muted;

    if (milestone != null) {
      if (due == null || days == null) {
        msText = milestoneText(context.l10n, milestone);
      } else {
        msText = context.l10n.milestoneDue(
          milestoneText(context.l10n, milestone),
          shortDate(due),
          dueText(context.l10n, days),
        );
        if (days < 0) {
          milestoneColor = context.farm.danger;
        } else if (days <= 7) {
          milestoneColor = context.farm.warning;
        }
      }
    }

    return Card(
      child: ListTile(
        leading: Icon(Icons.favorite_border, color: context.farm.danger),
        title: Text(row.cow.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              row.stage == null
                  ? context.l10n.noActiveCycle
                  : stageText(context.l10n, row.stage!),
            ),
            if (msText != null)
              Text(msText, style: TextStyle(color: milestoneColor)),
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
