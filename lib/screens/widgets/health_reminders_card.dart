import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/health/reminders.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Dashboard card listing health follow-ups that are overdue, due today or
/// coming up soon. Shows nothing when there are none.
class HealthRemindersCard extends StatefulWidget {
  final AppDatabase? db;

  /// Test hooks; default to the database streams.
  final Stream<List<CowData>>? cows;
  final Stream<List<HealthRecordData>>? records;

  const HealthRemindersCard({super.key, this.db, this.cows, this.records});

  @override
  State<HealthRemindersCard> createState() => _HealthRemindersCardState();
}

class _HealthRemindersCardState extends State<HealthRemindersCard> {
  static const _maxShown = 5;

  late final _cows = widget.cows ?? widget.db!.watchAllCow();
  late final _records = widget.records ?? widget.db!.watchFollowUpRecords();

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
            final reminders = dueReminders(recSnap.data!, DateTime.now());
            if (reminders.isEmpty) return const SizedBox.shrink();

            final names = {for (final c in cowSnap.data!) c.id: c.name};
            final shown = reminders.take(_maxShown);

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: context.farm.info.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            color: context.farm.info,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Health reminders (${reminders.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final r in shown)
                        _ReminderRow(
                          reminder: r,
                          cowName:
                              names[r.record.cowId] ?? 'Cow #${r.record.cowId}',
                        ),
                      if (reminders.length > _maxShown)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${reminders.length - _maxShown} more',
                            style: TextStyle(
                              color: context.farm.muted,
                              fontSize: 12,
                            ),
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

class _ReminderRow extends StatelessWidget {
  final HealthReminder reminder;
  final String cowName;

  const _ReminderRow({required this.reminder, required this.cowName});

  (String, Color) _label(BuildContext context) {
    final d = reminder.daysUntil;
    if (d < 0) {
      return (
        d == -1 ? 'Overdue by 1 day' : 'Overdue by ${-d} days',
        context.farm.danger,
      );
    }
    if (d == 0) return ('Today', context.farm.warning);
    if (d == 1) return ('Tomorrow', Theme.of(context).colorScheme.onSurface);
    return ('In $d days', context.farm.muted);
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _label(context);
    final rec = reminder.record;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$cowName · ${rec.recordType}: ${rec.description}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.farm.muted),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              Text(
                weekdayDate(reminder.dueOn),
                style: TextStyle(color: context.farm.muted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
