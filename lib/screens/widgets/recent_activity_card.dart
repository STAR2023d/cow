import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' show TypedResult;
import 'package:flutter/material.dart';

/// Live "Recent Activity" feed: the most recent milk entries, joined
/// with the cow's name.
class RecentActivityCard extends StatelessWidget {
  final AppDatabase db;

  const RecentActivityCard({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
                return const Text(
                  'No recent activity',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
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
                        const Icon(
                          Icons.opacity,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${cowData.name} • ${entry.session} • ${entry.amount.toStringAsFixed(1)} L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '${entry.entryDate.day}/${entry.entryDate.month}',
                          style: const TextStyle(
                            color: Colors.white38,
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
