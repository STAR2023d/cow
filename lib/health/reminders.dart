import 'package:cow/database/app_database.dart';

DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whole days from [from] to [to], ignoring time of day and DST shifts.
int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// A health record whose follow-up date falls near today.
///
/// Records have no "done" flag, so a reminder simply shows while its
/// follow-up date is inside the window given to [dueReminders].
class HealthReminder {
  final HealthRecordData record;

  /// The follow-up day (time of day is ignored).
  final DateTime dueOn;

  /// Days from today to [dueOn]: negative when overdue, 0 for today.
  final int daysUntil;

  HealthReminder(this.record, DateTime now)
    : dueOn = _dayOf(record.followUpDate!),
      daysUntil = _daysBetween(now, record.followUpDate!);

  bool get isOverdue => daysUntil < 0;
  bool get isToday => daysUntil == 0;
}

/// Reminders due from [overdueDays] ago through [aheadDays] ahead,
/// most overdue first. Records with no follow-up date are ignored.
List<HealthReminder> dueReminders(
  List<HealthRecordData> records,
  DateTime now, {
  int aheadDays = 14,
  int overdueDays = 14,
}) {
  return [
        for (final r in records)
          if (r.followUpDate != null) HealthReminder(r, now),
      ]
      .where((r) => r.daysUntil >= -overdueDays && r.daysUntil <= aheadDays)
      .toList()
    ..sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
}
