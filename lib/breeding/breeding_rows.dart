import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/database/app_database.dart';

/// One cow's breeding situation, ready to show in a list.
class BreedingRow {
  final CowData cow;

  /// Null when the cow has no active breeding cycle.
  final BreedingStage? stage;

  /// What she is waiting for next, if anything.
  final BreedingMilestone? milestone;

  const BreedingRow(this.cow, {this.stage, this.milestone});

  /// Whole days from [now] until the milestone date. Negative means overdue.
  /// Null when there is no date to count to.
  int? daysUntilDue(DateTime now) {
    final due = milestone?.date;
    if (due == null) return null;
    return DateTime.utc(
      due.year,
      due.month,
      due.day,
    ).difference(DateTime.utc(now.year, now.month, now.day)).inDays;
  }

  /// True when the farmer should act soon: something is overdue or due
  /// within 7 days, or a calving still needs its outcome recorded.
  bool needsAttention(DateTime now) {
    if (stage == BreedingStage.calved) return true;
    final days = daysUntilDue(now);
    return days != null && days <= 7;
  }
}

/// "3 days overdue", "today", "tomorrow", "in 6 days".
String dueLabel(int days) {
  if (days < 0) return '${-days} ${-days == 1 ? 'day' : 'days'} overdue';
  if (days == 0) return 'today';
  if (days == 1) return 'tomorrow';
  return 'in $days days';
}

/// Builds one row per cow and sorts them: dated milestones first (soonest
/// or most overdue at the top), then open cycles without a date, then cows
/// with no active cycle.
List<BreedingRow> buildBreedingRows(
  List<CowData> cows,
  List<BreedingCycle> cycles, {
  DateTime? now,
}) {
  final today = now ?? DateTime.now();

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
    if (cycle == null) return BreedingRow(cow);

    final stage = deriveDisplayStage(
      now: today,
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
    return BreedingRow(cow, stage: stage, milestone: milestone);
  }).toList();

  // 0 = has a dated milestone, 1 = open cycle without a date, 2 = idle.
  int group(BreedingRow r) {
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
