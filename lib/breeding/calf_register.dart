import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/database/app_database.dart';

/// What happened to a calf after it was born.
///
/// [onFarm] is for calves entered by hand (bought in, or born before the
/// app was used); the others come from a breeding cycle.
enum CalfOutcome { kept, sold, awaiting, onFarm }

/// One calf in the register.
///
/// A calf comes from a breeding cycle with a calving date ([cycle]), from a
/// hand-entered [Calf] row, or both: a cycle calf gets a [Calf] row (linked
/// by `breedingCycleId`) the first time its weight, weaning or notes are
/// saved.
class CalfEntry {
  final BreedingCycle? cycle;
  final Calf? details;
  final String damName;

  /// Name of the heifer in the herd (kept cycle calves) or the name given
  /// to a hand-entered calf.
  final String? calfName;

  CalfEntry({this.cycle, this.details, required this.damName, this.calfName})
    : assert(cycle != null || details != null);

  bool get fromCycle => cycle != null;

  DateTime get bornOn => cycle?.actualCalvingDate ?? details!.dateOfBirth;

  /// 'female', 'male' or null when not recorded.
  String? get sex {
    final s = cycle != null ? cycle!.calfSex : details!.sex;
    return s == 'female' || s == 'male' ? s : null;
  }

  double? get birthWeightKg => details?.birthWeightKg;
  DateTime? get weanedOn => details?.weanedOn;
  String? get notes => details?.notes;
  bool get boughtIn => details?.boughtIn ?? false;

  CalfOutcome get outcome {
    final c = cycle;
    if (c == null) return CalfOutcome.onFarm;
    if (c.calfCowId != null || c.stage == BreedingStage.keptAsHeifer) {
      return CalfOutcome.kept;
    }
    if (c.sold || c.stage == BreedingStage.soldCalf) return CalfOutcome.sold;
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

/// Every calf, newest first: calves from breeding cycles (with their
/// [Calf] details when saved) plus hand-entered calves.
///
/// A [Calf] row whose cycle is no longer in [cycles] (for example the
/// calving date was removed) is still listed on its own, so its details
/// are never hidden.
List<CalfEntry> buildCalfRegister(
  List<CowData> cows,
  List<BreedingCycle> cycles, [
  List<Calf> calves = const [],
]) {
  final names = {for (final c in cows) c.id: c.name};
  final byCycle = {
    for (final c in calves)
      if (c.breedingCycleId != null) c.breedingCycleId!: c,
  };
  final usedIds = <int>{};

  final entries = <CalfEntry>[];
  for (final c in cycles) {
    if (c.actualCalvingDate == null) continue;
    final details = byCycle[c.id];
    if (details != null) usedIds.add(details.id);
    entries.add(
      CalfEntry(
        cycle: c,
        details: details,
        damName: names[c.cowId] ?? 'Cow #${c.cowId}',
        calfName: c.calfCowId == null ? null : names[c.calfCowId],
      ),
    );
  }
  for (final d in calves) {
    if (usedIds.contains(d.id)) continue;
    final dam = d.damCowId;
    entries.add(
      CalfEntry(
        details: d,
        damName: dam == null ? 'Unknown dam' : names[dam] ?? 'Cow #$dam',
        calfName: d.name,
      ),
    );
  }
  return entries..sort((a, b) => b.bornOn.compareTo(a.bornOn));
}
