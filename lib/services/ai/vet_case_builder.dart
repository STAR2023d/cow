import 'package:cow/breeding/breeding_labels.dart';
import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/services/ai/vet_service.dart';
import 'package:intl/intl.dart';

/// Gathers what the app already knows about [cow] (breed, age, breeding
/// stage, the last 7 days of milk) so the farmer only has to describe the
/// symptoms.
Future<VetCase> buildVetCase({
  required AppDatabase db,
  required CowData cow,
  required String symptoms,
  String? duration,
  VetLanguage language = VetLanguage.english,
  DateTime? now,
}) async {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);

  // Where she is in her breeding cycle, if she has an open one.
  String? breedingStatus;
  final cycle = await db.watchActiveBreedingCycle(cow.id).first;
  if (cycle != null) {
    final stage = deriveDisplayStage(
      now: current,
      serviceDate: cycle.serviceDate,
      check1Result: cycle.check1Result,
      check2Result: cycle.check2Result,
      check3Result: cycle.check3Result,
      actualCalvingDate: cycle.actualCalvingDate,
      gestationDays: cycle.gestationDays,
    );
    breedingStatus = stage.label;
    final due = cycle.expectedCalvingDate;
    if (due != null) {
      breedingStatus =
          '$breedingStatus (expected calving ${DateFormat('d MMM yyyy').format(due)})';
    }
  }

  // Her milk for the last 7 days, oldest first. A trend is what a vet asks
  // about first.
  final litres = <double>[];
  for (var i = 6; i >= 0; i--) {
    final day = today.subtract(Duration(days: i));
    litres.add(await db.watchCowDailyTotal(cow.id, day).first);
  }
  String? milkNote;
  if (litres.any((l) => l > 0)) {
    milkNote =
        'Litres per day for the last 7 days, oldest first '
        '(0 = nothing logged): '
        '${litres.map((l) => l.toStringAsFixed(1)).join(', ')}';
  }

  final trimmedDuration = duration?.trim();

  return VetCase(
    cowName: cow.name,
    breed: cow.breed,
    ageYears: cow.age,
    breedingStatus: breedingStatus,
    recentMilkNote: milkNote,
    symptoms: symptoms.trim(),
    duration: (trimmedDuration == null || trimmedDuration.isEmpty)
        ? null
        : trimmedDuration,
    language: language,
  );
}
