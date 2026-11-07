import 'breeding_schema.dart' show BreedingStage;

/// Pure date-math derived from the flowchart. No DB/Flutter dependencies,
/// so you can unit test this in isolation before wiring it to anything.
class BreedingSchedule {
  final DateTime serviceDate;
  final int gestationDays;

  BreedingSchedule({required this.serviceDate, this.gestationDays = 283});

  DateTime get check1Due => serviceDate.add(const Duration(days: 21));
  DateTime get check2Due => serviceDate.add(const Duration(days: 42));
  DateTime get check3Due => serviceDate.add(const Duration(days: 63));

  DateTime get expectedCalvingDate =>
      serviceDate.add(Duration(days: gestationDays));

  DateTime get dryOffDate =>
      expectedCalvingDate.subtract(const Duration(days: 56)); // 8 wks
  DateTime get prep4WeeksDate =>
      expectedCalvingDate.subtract(const Duration(days: 28));
  DateTime get prep2WeeksDate =>
      expectedCalvingDate.subtract(const Duration(days: 14));
  DateTime get prep1WeekDate =>
      expectedCalvingDate.subtract(const Duration(days: 7));

  /// Voluntary waiting period: earliest the cow should be re-served after
  /// calving ("Countdown to next service + 90 days" on the chart). This
  /// runs in parallel with the female/male branch, not after it — both
  /// fire off the same "Calving date" node independently.
  static DateTime nextServiceEligibleDate(DateTime actualCalvingDate) =>
      actualCalvingDate.add(const Duration(days: 90));
}

/// Given "today", figure out which stage a still-open cycle *should* show
/// as. Call this from your UI layer when you just want to know "what do I
/// nudge the farmer about today" — keep the `stage` column in the DB as the
/// authoritative record of what actually happened (checks logged, calving
/// logged) and use this only for display/reminders so date math lives in
/// exactly one testable place.
BreedingStage deriveDisplayStage({
  required DateTime now,
  required DateTime? serviceDate,
  required bool? check1Result,
  required bool? check2Result,
  required bool? check3Result,
  required DateTime? actualCalvingDate,
  required int gestationDays,
}) {
  if (serviceDate == null) return BreedingStage.awaitingService;

  if (check1Result == false || check2Result == false || check3Result == false) {
    return BreedingStage.failed;
  }

  if (actualCalvingDate != null) return BreedingStage.calved;

  if (check1Result == null) return BreedingStage.awaitingCheck1;
  if (check2Result == null) return BreedingStage.awaitingCheck2;
  if (check3Result == null) return BreedingStage.awaitingCheck3;

  // All three checks passed -> pregnant, somewhere in the calving run-up.
  final schedule = BreedingSchedule(
    serviceDate: serviceDate,
    gestationDays: gestationDays,
  );
  if (now.isAfter(schedule.prep1WeekDate)) return BreedingStage.prep1Week;
  if (now.isAfter(schedule.prep2WeeksDate)) return BreedingStage.prep2Weeks;
  if (now.isAfter(schedule.prep4WeeksDate)) return BreedingStage.prep4Weeks;
  if (now.isAfter(schedule.dryOffDate)) return BreedingStage.dryOff;
  return BreedingStage.confirmedPregnant;
}

/// The next thing the farmer is waiting for on a cycle.
/// [date] is null when there is no calendar date to show.
class BreedingMilestone {
  final String label;
  final DateTime? date;

  const BreedingMilestone(this.label, [this.date]);
}

/// What is the farmer waiting for next, given the cycle's display stage?
/// Pure date maths like the rest of this file, so it is easy to test.
BreedingMilestone? nextMilestone({
  required BreedingStage stage,
  required DateTime? serviceDate,
  required int gestationDays,
  DateTime? expectedCalvingDate,
}) {
  if (stage == BreedingStage.awaitingService) {
    return const BreedingMilestone('Waiting for service');
  }
  if (stage == BreedingStage.calved) {
    return const BreedingMilestone('Record the calf outcome');
  }
  if (serviceDate == null) return null;

  final schedule = BreedingSchedule(
    serviceDate: serviceDate,
    gestationDays: gestationDays,
  );

  switch (stage) {
    case BreedingStage.awaitingCheck1:
      return BreedingMilestone('Check 1 due', schedule.check1Due);
    case BreedingStage.awaitingCheck2:
      return BreedingMilestone('Check 2 due', schedule.check2Due);
    case BreedingStage.awaitingCheck3:
      return BreedingMilestone('Check 3 due', schedule.check3Due);
    case BreedingStage.confirmedPregnant:
    case BreedingStage.dryOff:
    case BreedingStage.prep4Weeks:
    case BreedingStage.prep2Weeks:
    case BreedingStage.prep1Week:
      return BreedingMilestone(
        'Calving expected',
        expectedCalvingDate ?? schedule.expectedCalvingDate,
      );
    default:
      return null;
  }
}
