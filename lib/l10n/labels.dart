import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/breeding/calf_register.dart';
import 'package:cow/health/health_presets.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/models/period_runner.dart';

/// Translated names for values that are stored or computed in English.
/// The English values stay as they are (the database, the AI vet prompt
/// and tests rely on them); only what the farmer sees is translated.

/// Feed type as saved in the feeding log ('Hay', 'Dairy Meal', ...).
String feedTypeLabel(L10n l10n, String stored) => switch (stored) {
  'Hay' => l10n.feedHay,
  'Silage' => l10n.feedSilage,
  'Concentrate' => l10n.feedConcentrate,
  'Pasture' => l10n.feedPasture,
  'Mineral Supplement' => l10n.feedMineral,
  'Dairy Meal' => l10n.feedDairyMeal,
  'Other' => l10n.other,
  _ => stored,
};

/// Health record type as saved ('Vaccination', 'Tick control', ...).
String recordTypeLabel(L10n l10n, String stored) => switch (stored) {
  'Vaccination' => l10n.recVaccination,
  'Illness' => l10n.recIllness,
  'Checkup' => l10n.recCheckup,
  'Treatment' => l10n.recTreatment,
  'Deworming' => l10n.recDeworming,
  'Tick control' => l10n.recTickControl,
  'Hoof care' => l10n.recHoofCare,
  'Other' => l10n.other,
  _ => stored,
};

/// The chip text of a health preset.
String presetLabel(L10n l10n, HealthPreset p) => p.label == 'Vet check'
    ? l10n.presetVetCheck
    : recordTypeLabel(l10n, p.label);

/// The description a preset fills in (the farmer can still edit it).
String presetDescription(L10n l10n, HealthPreset p) => switch (p.label) {
  'Vaccination' => l10n.presetDescVaccination,
  'Tick control' => l10n.presetDescTick,
  'Deworming' => l10n.presetDescDeworming,
  'Hoof care' => l10n.presetDescHoof,
  'Vet check' => l10n.presetDescVetCheck,
  _ => p.description,
};

/// A breeding stage in the app language (English: `BreedingStage.label`).
String stageText(L10n l10n, BreedingStage stage) => switch (stage) {
  BreedingStage.awaitingService => l10n.stageAwaitingService,
  BreedingStage.awaitingCheck1 => l10n.stageAwaitingCheck(21),
  BreedingStage.awaitingCheck2 => l10n.stageAwaitingCheck(42),
  BreedingStage.awaitingCheck3 => l10n.stageAwaitingCheck(63),
  BreedingStage.confirmedPregnant => l10n.stageConfirmed,
  BreedingStage.dryOff => l10n.stageDryOff,
  BreedingStage.prep4Weeks => l10n.stagePrepWeeks(4),
  BreedingStage.prep2Weeks => l10n.stagePrepWeeks(2),
  BreedingStage.prep1Week => l10n.stagePrepWeeks(1),
  BreedingStage.calved => l10n.stageCalved,
  BreedingStage.keptAsHeifer => l10n.stageKeptHeifer,
  BreedingStage.soldCalf => l10n.stageSoldCalf,
  BreedingStage.failed => l10n.stageFailed,
};

/// A milestone from `nextMilestone` in the app language.
String milestoneText(L10n l10n, BreedingMilestone m) => switch (m.label) {
  'Waiting for service' => l10n.msWaitingService,
  'Record the calf outcome' => l10n.msRecordOutcome,
  'Check 1 due' => l10n.msCheckDue(1),
  'Check 2 due' => l10n.msCheckDue(2),
  'Check 3 due' => l10n.msCheckDue(3),
  'Calving expected' => l10n.msCalvingExpected,
  _ => m.label,
};

/// "3 days overdue", "today", "tomorrow", "in 6 days" (English: `dueLabel`).
String dueText(L10n l10n, int days) {
  if (days < 0) return l10n.dueOverdue(-days);
  if (days == 0) return l10n.dueToday;
  if (days == 1) return l10n.dueTomorrow;
  return l10n.dueInDays(days);
}

/// Expense category key ('feed', 'vet', ...) in the app language
/// (English: `ExpenseCategory.label`).
String expenseCategoryLabel(L10n l10n, String key) => switch (key) {
  'feed' => l10n.catFeed,
  'vet' => l10n.catVet,
  'labour' => l10n.catLabour,
  'transport' => l10n.catTransport,
  _ => l10n.other,
};

/// Income category ('calf_sale', ...) in the app language
/// (English: `incomeLabel`).
String incomeCategoryLabel(L10n l10n, String category) => switch (category) {
  'calf_sale' => l10n.incomeCalfSale,
  '' => l10n.income,
  _ => incomeLabel(category),
};

/// A calf's mother as the register names her: 'Unknown dam', 'Cow #4' or
/// her name.
String damLabel(L10n l10n, String dam) {
  if (dam == 'Unknown dam') return l10n.unknownDam;
  final n = RegExp(r'^Cow #(\d+)$').firstMatch(dam);
  return n == null ? dam : l10n.cowNumber(int.parse(n.group(1)!));
}

/// The calf's own name, or "Calf of [dam]", or "Unnamed calf".
String calfTitle(L10n l10n, CalfEntry c) =>
    c.calfName ??
    (c.damName == 'Unknown dam'
        ? l10n.unnamedCalf
        : l10n.calfOf(damLabel(l10n, c.damName)));

/// A calf's age on [now], same rules as `CalfEntry.ageOn`.
String calfAgeText(L10n l10n, DateTime bornOn, DateTime now) {
  final days = DateTime.utc(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime.utc(bornOn.year, bornOn.month, bornOn.day)).inDays;
  if (days < 0) return l10n.ageNotBorn;
  if (days < 14) return l10n.ageDays(days);
  if (days < 61) return l10n.ageWeeks(days ~/ 7);
  final months =
      (now.year - bornOn.year) * 12 +
      now.month -
      bornOn.month -
      (now.day < bornOn.day ? 1 : 0);
  if (months < 24) return l10n.ageMonths(months);
  return l10n.ageYearsLong(months ~/ 12);
}
