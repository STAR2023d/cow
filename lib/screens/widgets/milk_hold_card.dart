import 'package:cow/database/app_database.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Dashboard card listing cows whose milk is on hold after treatment.
/// Shows nothing when no cow is on hold.
class MilkHoldCard extends StatefulWidget {
  final AppDatabase? db;

  /// Test hooks; default to the database streams.
  final Stream<List<CowData>>? cows;
  final Stream<List<HealthRecordData>>? records;

  const MilkHoldCard({super.key, this.db, this.cows, this.records});

  @override
  State<MilkHoldCard> createState() => _MilkHoldCardState();
}

class _MilkHoldCardState extends State<MilkHoldCard> {
  late final _cows = widget.cows ?? widget.db!.watchAllCow();
  late final _records = widget.records ?? widget.db!.watchWithdrawalRecords();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CowData>>(
      stream: _cows,
      builder: (context, cowSnap) {
        return StreamBuilder<List<HealthRecordData>>(
          stream: _records,
          builder: (context, recSnap) {
            if (!cowSnap.hasData || !recSnap.hasData) {
              return const SizedBox.shrink();
            }
            final now = DateTime.now();
            final holds = activeHolds(recSnap.data!, now);
            if (holds.isEmpty) return const SizedBox.shrink();

            final names = {for (final c in cowSnap.data!) c.id: c.name};
            final fmt = DateFormat('EEE d MMM');

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: context.farm.warning.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: context.farm.warning,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Milk on hold (${holds.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final h in holds)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            '${names[h.cowId] ?? 'Cow #${h.cowId}'}: '
                            'do not sell until '
                            '${fmt.format(h.withdrawal.safeFrom)} '
                            '(${_daysLeft(h.withdrawal.daysLeft(now))})',
                            style: TextStyle(color: context.farm.muted),
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

  String _daysLeft(int d) => d == 1 ? '1 day left' : '$d days left';
}
