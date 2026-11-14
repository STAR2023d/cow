import 'package:cow/breeding/breeding_overview_screen.dart';
import 'package:cow/breeding/breeding_rows.dart';
import 'package:cow/breeding/breeding_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Dashboard strip listing cows that need breeding attention soon
/// (overdue, due within 7 days, or calved and awaiting an outcome).
/// Shows nothing at all when there is nothing to act on.
class BreedingAlertsCard extends StatelessWidget {
  final AppDatabase db;

  const BreedingAlertsCard({super.key, required this.db});

  static const _maxShown = 3;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CowData>>(
      stream: db.watchAllCow(),
      builder: (context, cowSnap) {
        return StreamBuilder<List<BreedingCycle>>(
          stream: db.watchAllActiveBreedingCycles(),
          builder: (context, cycleSnap) {
            if (!cowSnap.hasData || !cycleSnap.hasData) {
              return const SizedBox.shrink();
            }

            final now = DateTime.now();
            final alerts = buildBreedingRows(
              cowSnap.data!,
              cycleSnap.data!,
              now: now,
            ).where((r) => r.needsAttention(now)).toList();

            if (alerts.isEmpty) return const SizedBox.shrink();

            final shown = alerts.take(_maxShown).toList();

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: context.farm.warning.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: context.farm.warning,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Breeding Alerts (${alerts.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...shown.map((r) => _AlertRow(row: r, now: now)),
                      if (alerts.length > _maxShown)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${alerts.length - _maxShown} more',
                            style: TextStyle(
                              color: context.farm.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BreedingOverviewScreen(),
                            ),
                          ),
                          child: const Text('View all'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            );
          },
        );
      },
    );
  }
}

class _AlertRow extends StatelessWidget {
  final BreedingRow row;
  final DateTime now;

  const _AlertRow({required this.row, required this.now});

  @override
  Widget build(BuildContext context) {
    final milestone = row.milestone;
    final days = row.daysUntilDue(now);

    var text = row.cow.name;
    if (milestone != null) text += ' — ${milestone.label}';
    if (days != null) text += ' (${dueLabel(days)})';

    final color = (days != null && days < 0)
        ? context.farm.danger
        : context.farm.warning;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BreedingScreen(cowId: row.cow.id, cowName: row.cow.name),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: context.farm.muted),
          ],
        ),
      ),
    );
  }
}
