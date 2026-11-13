import 'package:cow/database/app_database.dart';

DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

/// Milk that must not be sold after a cow was treated with a medicine.
///
/// The number of days comes from the medicine label or the vet. The app
/// only counts days, it does not know what is safe.
class MilkWithdrawal {
  /// The day of treatment (time of day is ignored).
  final DateTime treatedOn;
  final int days;
  final String? medicine;

  MilkWithdrawal({
    required DateTime treatedOn,
    required this.days,
    this.medicine,
  }) : treatedOn = _dayOf(treatedOn);

  /// The last day the milk must be held back. The treatment day counts as
  /// day 0, so a 3-day withdrawal from the 5th runs through the 8th. This
  /// errs on the side of caution, because the app does not know what time
  /// of day the treatment was given.
  DateTime get lastWithheldDay =>
      DateTime(treatedOn.year, treatedOn.month, treatedOn.day + days);

  /// The first day the milk can go back on sale.
  DateTime get safeFrom =>
      DateTime(treatedOn.year, treatedOn.month, treatedOn.day + days + 1);

  /// True from the day of treatment through [lastWithheldDay].
  bool isActiveOn(DateTime now) {
    final today = _dayOf(now);
    return !today.isBefore(treatedOn) && !today.isAfter(lastWithheldDay);
  }

  /// Days still to go, counting today. Zero when the hold is over.
  int daysLeft(DateTime now) {
    if (!isActiveOn(now)) return 0;
    final today = _dayOf(now);
    return DateTime.utc(
          lastWithheldDay.year,
          lastWithheldDay.month,
          lastWithheldDay.day,
        )
            .difference(DateTime.utc(today.year, today.month, today.day))
            .inDays +
        1;
  }
}

/// The milk hold for a health record, or null when it has no withdrawal
/// days.
MilkWithdrawal? milkWithdrawalOf(HealthRecordData record) {
  final days = record.milkWithdrawalDays;
  if (days == null || days < 1) return null;
  return MilkWithdrawal(
    treatedOn: record.date,
    days: days,
    medicine: record.medicine,
  );
}
/// A cow whose milk is on hold today.
class MilkHold {
  final int cowId;
  final MilkWithdrawal withdrawal;

  const MilkHold(this.cowId, this.withdrawal);
}

/// The holds still running on [now], one per cow (the one that ends last),
/// soonest to end first.
List<MilkHold> activeHolds(List<HealthRecordData> records, DateTime now) {
  final byCow = <int, MilkWithdrawal>{};
  for (final r in records) {
    final w = milkWithdrawalOf(r);
    if (w == null || !w.isActiveOn(now)) continue;
    final existing = byCow[r.cowId];
    if (existing == null || w.safeFrom.isAfter(existing.safeFrom)) {
      byCow[r.cowId] = w;
    }
  }
  return [for (final e in byCow.entries) MilkHold(e.key, e.value)]
    ..sort((a, b) => a.withdrawal.safeFrom.compareTo(b.withdrawal.safeFrom));
}
