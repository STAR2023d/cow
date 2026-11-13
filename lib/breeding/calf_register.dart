import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/database/app_database.dart';

/// What happened to a calf after it was born.
enum CalfOutcome { kept, sold, awaiting }

/// One calf, read from the breeding cycle that recorded its birth.
///
/// The register is read-only: calves only appear here once a breeding
/// cycle has a calving date.
class CalfEntry {
  final BreedingCycle cycle;
  final String damName;

  /// Name of the heifer in the herd, when the calf was kept.
  final String? calfName;

  CalfEntry(this.cycle, {required this.damName, this.calfName});

  DateTime get bornOn => cycle.actualCalvingDate!;

  /// 'female', 'male' or null while the outcome is not recorded.
  String? get sex => cycle.calfSex;

  CalfOutcome get outcome {
    if (cycle.calfCowId != null || cycle.stage == BreedingStage.keptAsHeifer) {
      return CalfOutcome.kept;
    }
    if (cycle.sold || cycle.stage == BreedingStage.soldCalf) {
      return CalfOutcome.sold;
    }
    return CalfOutcome.awaiting;
  }

  /// Age on [now] as days (under 2 weeks), weeks (under 2 months), months
  /// (under 2 years) or years.
  String ageOn(DateTime now) {
    final days = DateTime.utc(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime.utc(bornOn.year, bornOn.month, bornOn.day)).inDays;
    if (days < 0) return 'not born yet';
    if (days < 14) return days == 1 ? '1 day' : '$days days';
    if (days < 61) return '${days ~/ 7} weeks';
    final months =
        (now.year - bornOn.year) * 12 +
        now.month -
        bornOn.month -
        (now.day < bornOn.day ? 1 : 0);
    if (months < 24) return '$months months';
    return '${months ~/ 12} years';
  }
}

/// Every calf recorded through breeding cycles, newest first.
List<CalfEntry> buildCalfRegister(
  List<CowData> cows,
  List<BreedingCycle> cycles,
) {
  final names = {for (final c in cows) c.id: c.name};
  return [
    for (final c in cycles)
      if (c.actualCalvingDate != null)
        CalfEntry(
          c,
          damName: names[c.cowId] ?? 'Cow #${c.cowId}',
          calfName: c.calfCowId == null ? null : names[c.calfCowId],
        ),
  ]..sort((a, b) => b.bornOn.compareTo(a.bornOn));
}
