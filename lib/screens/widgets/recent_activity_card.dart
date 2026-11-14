import 'package:cow/l10n/language_controller.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' show TypedResult;
import 'package:flutter/material.dart';

/// Live context.l10n.recentActivity feed: the most recent milk entries, joined
/// with the cow's name.
class RecentActivityCard extends StatelessWidget {
  final AppDatabase db;

  const RecentActivityCard({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: context.farm.faint),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.recentActivity,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12.0),
          StreamBuilder<List<TypedResult>>(
            stream: db.watchRecentEntries(limit: 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              final rows = snapshot.data ?? [];
              if (rows.isEmpty) {
                return Text(
                  context.l10n.noRecentActivity,
                  style: TextStyle(fontSize: 14, color: context.farm.muted),
                );
              }
              return Column(
                children: rows.map((row) {
                  final entry = row.readTable(db.milkTable);
                  final cowData = row.readTable(db.cow);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Icon(Icons.opacity, color: context.farm.info, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${cowData.name} • ${sessionLabel(context.l10n, entry.session)} • ${litres(entry.amount)}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          dayMonth(entry.entryDate),
                          style: TextStyle(
                            color: context.farm.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
