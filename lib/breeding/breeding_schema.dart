import 'package:cow/database/app_database.dart';
import 'package:drift/drift.dart';

/// Where a breeding cycle currently sits, mapped directly off your flowchart.
enum BreedingStage {
  awaitingService, // "Cow heat signs" observed, not yet served
  awaitingCheck1, // served, waiting on day-21 check
  awaitingCheck2, // day-21 passed, waiting on day-42 check
  awaitingCheck3, // day-42 passed, waiting on day-63 check
  confirmedPregnant, // day-63 confirmed -> "Countdown to calving"
  dryOff, // 8 weeks to calving
  prep4Weeks, // 4 weeks to calving
  prep2Weeks, // 2 weeks to calving
  prep1Week, // 1 week to calving
  calved, // calving date reached, awaiting sex decision
  keptAsHeifer, // female calf -> added to herd
  soldCalf, // male / non-kept calf -> sold
  failed, // any check came back NO -> cycle abandoned, cow returns to heat
}

class BreedingCycles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// The dam (mother) going through this cycle.
  IntColumn get cowId => integer().references(Cow, #id)();

  DateTimeColumn get heatDate => dateTime()();
  DateTimeColumn get serviceDate => dateTime().nullable()();

  DateTimeColumn get check1Date => dateTime().nullable()();
  BoolColumn get check1Result => boolean().nullable()();

  DateTimeColumn get check2Date => dateTime().nullable()();
  BoolColumn get check2Result => boolean().nullable()();

  DateTimeColumn get check3Date => dateTime().nullable()();
  BoolColumn get check3Result => boolean().nullable()();

  /// Average dairy gestation is ~283 days — NOT on your chart, so this is
  /// my assumption. Kept per-cycle (not hardcoded) so you can tune it per
  /// breed later instead of it being buried in code.
  IntColumn get gestationDays => integer().withDefault(const Constant(283))();

  DateTimeColumn get expectedCalvingDate => dateTime().nullable()();
  DateTimeColumn get actualCalvingDate => dateTime().nullable()();

  TextColumn get calfSex => text().nullable()(); // 'female' | 'male'
  IntColumn get calfCowId =>
      integer().nullable().references(Cow, #id)(); // set if kept as heifer

  BoolColumn get sold => boolean().withDefault(const Constant(false))();
  RealColumn get saleAmount => real().nullable()();
  DateTimeColumn get saleDate => dateTime().nullable()();

  IntColumn get stage => intEnum<BreedingStage>()();

  /// False once the cycle ends (calved+resolved, or failed a check).
  /// Keeping failed/finished rows instead of overwriting them gives you a
  /// full breeding history per cow (conception rate, days-open, etc.) —
  /// the flowchart's loop-back arrow doesn't show this, but you'll want it.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Your chart labels the sale step "Add to costs statement", but a calf
/// sale is income, not a cost. I generalized this to a simple ledger
/// (income/expense) rather than a costs-only table — see chat notes.
class LedgerEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cowId => integer().nullable().references(Cow, #id)();
  IntColumn get breedingCycleId =>
      integer().nullable().references(BreedingCycles, #id)();
  TextColumn get type => text()(); // 'income' | 'expense'
  TextColumn get category => text()(); // e.g. 'calf_sale', 'vet', 'feed'
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
