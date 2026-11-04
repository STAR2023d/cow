import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';



// Generates a single unified file for all tables
part 'app_database.g.dart';

// --- SESSION CONSTANTS ---
class MilkSession {
  static const morning = 'Morning';
  static const evening = 'Evening';
  static const all = [morning, evening];
}

// --- TABLE 1: COW ---
class Cow extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 100)();
  TextColumn get tag => text().nullable()();
  TextColumn get breed => text().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get imagePath => text().nullable()();
  // Set when this cow was kept as a heifer calf from a logged breeding
  // cycle -- links her back to her mother.
  IntColumn get parentCowId => integer().nullable().references(Cow, #id)();
}

// --- TABLE 2: MILK ENTRIES ---
class MilkTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get session => text()();
  RealColumn get amount => real()();
  IntColumn get cowId => integer().references(Cow, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

// --- TABLE 3: PRICE SETTINGS ----
class PriceSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get effectiveDate => dateTime()();
  RealColumn get pricePerLitre => real()();
}

// --- TABLE 4: EXPENSES ---
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
}

// --- TABLE 5: FEEDING LOG ---
class FeedingLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get feedType => text().withLength(min: 1, max: 100)();
  RealColumn get quantityKg => real()();
  // Null = fed to the whole herd rather than one specific cow.
  IntColumn get cowId => integer().nullable().references(Cow, #id)();
  TextColumn get notes => text().nullable()();
}

// --- TABLE 6: HEALTH RECORDS ---
class HealthRecord extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get cowId => integer().references(Cow, #id)();
  TextColumn get recordType => text()(); // Vaccination, Illness, Checkup...
  TextColumn get description => text().withLength(min: 1, max: 300)();
  DateTimeColumn get followUpDate => dateTime().nullable()();
}

// --- UNIFIED DATABASE CLASS ---
@DriftDatabase(
  tables: [
    Cow,
    MilkTable,
    PriceSettings,
    Expenses,
    FeedingLog,
    HealthRecord,
    BreedingCycles,
    LedgerEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed a starting price so cash calculations never divide-by-nothing.
        await into(priceSettings).insert(
          PriceSettingsCompanion.insert(
            effectiveDate: DateTime.now(),
            pricePerLitre: 50.0,
          ),
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(milkTable);
        }
        if (from < 3) {
          // Historic: milkRecords table, now superseded by priceSettings + derived totals.
        }
        if (from < 4) {
          await m.createTable(expenses);
        }
        if (from < 5) {
          await m.createTable(priceSettings);
          await into(priceSettings).insert(
            PriceSettingsCompanion.insert(
              effectiveDate: DateTime.now(),
              pricePerLitre: 50.0,
            ),
          );
        }
        if (from < 6) {
          await m.createTable(feedingLog);
          await m.createTable(healthRecord);
        }
        if (from < 7) {
          await m.createTable(breedingCycles);
          await m.createTable(ledgerEntries);
          await m.addColumn(cow, cow.parentCowId);
        }
      },
    );
  }

  // ============================================================
  // === COW OPERATIONS ===
  // ============================================================
  Future<int> insertCow(CowCompanion cowCompanion) =>
      into(cow).insert(cowCompanion);
  Stream<List<CowData>> watchAllCow() => select(cow).watch();
  Future<bool> updateCowInfo(CowCompanion cowCompanion) =>
      update(cow).replace(cowCompanion);
  Future<int> deleteCow(int id) =>
      (delete(cow)..where((tbl) => tbl.id.equals(id))).go();

  // ============================================================
  // === MILK ENTRY OPERATIONS ===
  // ============================================================

  /// Prevents accidental double-logging: call this before insertMilkEntry
  /// to check whether this cow already has a Morning/Evening entry today.
  Future<MilkTableData?> existingSessionEntry(
    int cowId,
    DateTime date,
    String session,
  ) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(milkTable)..where(
          (t) =>
              t.cowId.equals(cowId) &
              t.session.equals(session) &
              t.entryDate.isBiggerOrEqualValue(start) &
              t.entryDate.isSmallerThanValue(end),
        ))
        .getSingleOrNull();
  }

  /// Inserts a new entry, or updates the existing one for that
  /// cow/date/session if it's already there.
  Future<void> upsertMilkEntry({
    required int cowId,
    required DateTime date,
    required String session,
    required double amount,
  }) async {
    final existing = await existingSessionEntry(cowId, date, session);
    if (existing != null) {
      await (update(milkTable)..where((t) => t.id.equals(existing.id))).write(
        MilkTableCompanion(amount: Value(amount)),
      );
    } else {
      await into(milkTable).insert(
        MilkTableCompanion.insert(
          id: '${cowId}_${date.toIso8601String()}_$session',
          entryDate: date,
          session: session,
          amount: amount,
          cowId: cowId,
        ),
      );
    }
  }

  Stream<List<MilkTableData>> watchAllEntries() => select(milkTable).watch();

  Stream<List<MilkTableData>> watchTodayEntries() {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final tomorrowMidnight = todayMidnight.add(const Duration(days: 1));
    return (select(milkTable)
          ..where((tbl) => tbl.entryDate.isBiggerOrEqualValue(todayMidnight))
          ..where((tbl) => tbl.entryDate.isSmallerThanValue(tomorrowMidnight)))
        .watch();
  }

  Stream<List<TypedResult>> watchEntriesWithCowNames() {
    return select(
      milkTable,
    ).join([innerJoin(cow, cow.id.equalsExp(milkTable.cowId))]).watch();
  }

  /// Most recent N milk entries, joined with the cow's name.
  /// Feeds the dashboard's "Recent Activity" section.
  Stream<List<TypedResult>> watchRecentEntries({int limit = 5}) {
    final query =
        select(
            milkTable,
          ).join([innerJoin(cow, cow.id.equalsExp(milkTable.cowId))])
          ..orderBy([OrderingTerm.desc(milkTable.entryDate)])
          ..limit(limit);
    return query.watch();
  }

  /// One-off (non-reactive) fetch of every milk entry in a date range,
  /// oldest first. Used by the financial statement, which needs a plain
  /// list to loop over rather than a live stream.
  Future<List<MilkTableData>> milkEntriesInRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(milkTable)
            ..where(
              (t) =>
                  t.entryDate.isBiggerOrEqualValue(start) &
                  t.entryDate.isSmallerOrEqualValue(end),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.entryDate)]))
          .get();

  Stream<List<MilkTableData>> watchEntriesForCow(int cowId) {
    return (select(milkTable)
          ..where((tbl) => tbl.cowId.equals(cowId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.entryDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  // ============================================================
  // === AGGREGATION ===
  // ============================================================

  /// Total litres for ONE cow on ONE day (both sessions combined).
  Stream<double> watchCowDailyTotal(int cowId, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final totalExp = milkTable.amount.sum();
    final query = selectOnly(milkTable)
      ..addColumns([totalExp])
      ..where(
        milkTable.cowId.equals(cowId) &
            milkTable.entryDate.isBiggerOrEqualValue(start) &
            milkTable.entryDate.isSmallerThanValue(end),
      );
    return query.watchSingle().map((row) => row.read(totalExp) ?? 0.0);
  }

  /// Total litres across ALL cows on ONE day.
  Stream<double> watchAllCowsDailyTotal(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final totalExp = milkTable.amount.sum();
    final query = selectOnly(milkTable)
      ..addColumns([totalExp])
      ..where(
        milkTable.entryDate.isBiggerOrEqualValue(start) &
            milkTable.entryDate.isSmallerThanValue(end),
      );
    return query.watchSingle().map((row) => row.read(totalExp) ?? 0.0);
  }

  /// Total litres across all cows for ONE session (Morning or Evening).
  Stream<double> watchSessionDailyTotal(String session, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final totalExp = milkTable.amount.sum();
    final query = selectOnly(milkTable)
      ..addColumns([totalExp])
      ..where(
        milkTable.session.equals(session) &
            milkTable.entryDate.isBiggerOrEqualValue(start) &
            milkTable.entryDate.isSmallerThanValue(end),
      );
    return query.watchSingle().map((row) => row.read(totalExp) ?? 0.0);
  }

  /// Litres per day across a date range — one-off version for reports/PDFs.
  Future<Map<DateTime, double>> dailyTotalsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final entries =
        await (select(milkTable)..where(
              (t) =>
                  t.entryDate.isBiggerOrEqualValue(start) &
                  t.entryDate.isSmallerOrEqualValue(end),
            ))
            .get();
    return _groupByDay(entries);
  }

  /// Reactive version of [dailyTotalsInRange] — feeds the dashboard's
  /// sparkline so it updates live as milk entries are logged.
  Stream<Map<DateTime, double>> watchDailyTotalsInRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(milkTable)..where(
          (t) =>
              t.entryDate.isBiggerOrEqualValue(start) &
              t.entryDate.isSmallerOrEqualValue(end),
        ))
        .watch()
        .map(_groupByDay);
  }

  Map<DateTime, double> _groupByDay(List<MilkTableData> entries) {
    final totals = <DateTime, double>{};
    for (final e in entries) {
      final day = DateTime(
        e.entryDate.year,
        e.entryDate.month,
        e.entryDate.day,
      );
      totals[day] = (totals[day] ?? 0) + e.amount;
    }
    return totals;
  }

  // ============================================================
  // === PRICE SETTINGS ===
  // ============================================================

  Future<int> setPricePerLitre(double price, {DateTime? effectiveDate}) =>
      into(priceSettings).insert(
        PriceSettingsCompanion.insert(
          effectiveDate: effectiveDate ?? DateTime.now(),
          pricePerLitre: price,
        ),
      );

  Stream<double> watchCurrentPrice() {
    final query = select(priceSettings)
      ..orderBy([(t) => OrderingTerm.desc(t.effectiveDate)])
      ..limit(1);
    return query.watchSingleOrNull().map((row) => row?.pricePerLitre ?? 50.0);
  }

  Future<double> priceForDate(DateTime date) async {
    final row =
        await (select(priceSettings)
              ..where((t) => t.effectiveDate.isSmallerOrEqualValue(date))
              ..orderBy([(t) => OrderingTerm.desc(t.effectiveDate)])
              ..limit(1))
            .getSingleOrNull();
    return row?.pricePerLitre ?? 50.0;
  }

  // ============================================================
  // === CASH ===
  // ============================================================

  Future<double> cashForDate(DateTime date) async {
    final litres = await watchAllCowsDailyTotal(date).first;
    final price = await priceForDate(date);
    return litres * price;
  }

  Future<double> cashInRange(DateTime start, DateTime end) async {
    final dailyTotals = await dailyTotalsInRange(start, end);
    double cash = 0;
    for (final entry in dailyTotals.entries) {
      final price = await priceForDate(entry.key);
      cash += entry.value * price;
    }
    return cash;
  }

  Future<double> cashAfterExpenses(DateTime start, DateTime end) async {
    final cash = await cashInRange(start, end);
    final expensesTotal = await totalExpensesInRange(start, end);
    return cash - expensesTotal;
  }

  // ============================================================
  // === EXPENSES ===
  // ============================================================

  Future<int> insertExpense(ExpensesCompanion entry) =>
      into(expenses).insert(entry);

  Future<int> deleteExpense(int id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();

  Stream<List<Expense>> watchExpenses() =>
      (select(expenses)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<List<Expense>> expensesInRange(DateTime start, DateTime end) =>
      (select(expenses)
            ..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(start) &
                  t.date.isSmallerOrEqualValue(end),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<double> totalExpensesInRange(DateTime start, DateTime end) async {
    final totalExp = expenses.amount.sum();
    final query = selectOnly(expenses)
      ..addColumns([totalExp])
      ..where(
        expenses.date.isBiggerOrEqualValue(start) &
            expenses.date.isSmallerOrEqualValue(end),
      );
    final row = await query.getSingle();
    return row.read(totalExp) ?? 0.0;
  }

  // ============================================================
  // === FEEDING LOG ===
  // ============================================================

  Future<int> insertFeedingLog(FeedingLogCompanion entry) =>
      into(feedingLog).insert(entry);

  Future<int> deleteFeedingLog(int id) =>
      (delete(feedingLog)..where((t) => t.id.equals(id))).go();

  Stream<List<FeedingLogData>> watchFeedingLogs() =>
      (select(feedingLog)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  // ============================================================
  // === HEALTH RECORDS ===
  // ============================================================

  Future<int> insertHealthRecord(HealthRecordCompanion entry) =>
      into(healthRecord).insert(entry);

  Future<int> deleteHealthRecord(int id) =>
      (delete(healthRecord)..where((t) => t.id.equals(id))).go();

  Stream<List<HealthRecordData>> watchHealthRecords() => (select(
    healthRecord,
  )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  /// Upcoming vet/vaccination follow-ups, soonest first.
  Stream<List<HealthRecordData>> watchUpcomingFollowUps() {
    final now = DateTime.now();
    return (select(healthRecord)
          ..where((t) => t.followUpDate.isBiggerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.followUpDate)]))
        .watch();
  }

  // ============================================================
  // === BREEDING CYCLE OPERATIONS ===
  // ============================================================

  /// "Cow heat signs" observed -> opens a brand-new cycle for that cow.
  Future<int> startBreedingCycle({
    required int cowId,
    required DateTime heatDate,
  }) {
    return into(breedingCycles).insert(
      BreedingCyclesCompanion.insert(
        cowId: cowId,
        heatDate: heatDate,
        stage: BreedingStage.awaitingService,
      ),
    );
  }

  /// "Service date" logged.
  Future<void> recordService(int cycleId, DateTime serviceDate) {
    return (update(breedingCycles)..where((t) => t.id.equals(cycleId))).write(
      BreedingCyclesCompanion(
        serviceDate: Value(serviceDate),
        stage: const Value(BreedingStage.awaitingCheck1),
      ),
    );
  }

  /// Log the result of check 1, 2 or 3. On NO, the cycle is closed as
  /// failed -- that's the "NO" arrow looping back to "Cow heat signs" on
  /// the chart. The cow needs a fresh [startBreedingCycle] call next time
  /// she shows heat signs.
  Future<void> recordPregnancyCheck({
    required int cycleId,
    required int checkNumber, // 1, 2, or 3
    required bool passed,
    required DateTime checkDate,
  }) async {
    assert(checkNumber >= 1 && checkNumber <= 3);

    if (!passed) {
      await (update(breedingCycles)..where((t) => t.id.equals(cycleId)))
          .write(
        BreedingCyclesCompanion(
          stage: const Value(BreedingStage.failed),
          isActive: const Value(false),
          check1Date:
              checkNumber == 1 ? Value(checkDate) : const Value.absent(),
          check1Result:
              checkNumber == 1 ? const Value(false) : const Value.absent(),
          check2Date:
              checkNumber == 2 ? Value(checkDate) : const Value.absent(),
          check2Result:
              checkNumber == 2 ? const Value(false) : const Value.absent(),
          check3Date:
              checkNumber == 3 ? Value(checkDate) : const Value.absent(),
          check3Result:
              checkNumber == 3 ? const Value(false) : const Value.absent(),
        ),
      );
      return;
    }

    final nextStage = switch (checkNumber) {
      1 => BreedingStage.awaitingCheck2,
      2 => BreedingStage.awaitingCheck3,
      _ => BreedingStage.confirmedPregnant, // check 3 passed
    };

    var companion = BreedingCyclesCompanion(stage: Value(nextStage));

    if (checkNumber == 1) {
      companion = companion.copyWith(
        check1Date: Value(checkDate),
        check1Result: const Value(true),
      );
    } else if (checkNumber == 2) {
      companion = companion.copyWith(
        check2Date: Value(checkDate),
        check2Result: const Value(true),
      );
    } else {
      companion = companion.copyWith(
        check3Date: Value(checkDate),
        check3Result: const Value(true),
      );

      // Check 3 passed -> pregnancy confirmed. Compute the entire calving
      // run-up (dry-off, prep milestones) in one shot.
      final cycle = await (select(breedingCycles)
            ..where((t) => t.id.equals(cycleId)))
          .getSingle();
      if (cycle.serviceDate != null) {
        final schedule = BreedingSchedule(
          serviceDate: cycle.serviceDate!,
          gestationDays: cycle.gestationDays,
        );
        companion = companion.copyWith(
          expectedCalvingDate: Value(schedule.expectedCalvingDate),
        );
      }
    }

    await (update(breedingCycles)..where((t) => t.id.equals(cycleId)))
        .write(companion);
  }

  /// "Calving date" reached.
  Future<void> recordCalving(int cycleId, DateTime actualDate) {
    return (update(breedingCycles)..where((t) => t.id.equals(cycleId))).write(
      BreedingCyclesCompanion(
        actualCalvingDate: Value(actualDate),
        stage: const Value(BreedingStage.calved),
      ),
    );
  }

  /// "If female -> Yes" branch: keep her, tag this cow as her ancestor.
  Future<int> keepFemaleCalf({
    required int cycleId,
    required int damCowId,
    required String calfName,
  }) async {
    final calfId = await into(cow).insert(
      CowCompanion.insert(
        name: calfName,
        parentCowId: Value(damCowId),
      ),
    );

    await (update(breedingCycles)..where((t) => t.id.equals(cycleId))).write(
      BreedingCyclesCompanion(
        calfSex: const Value('female'),
        calfCowId: Value(calfId),
        stage: const Value(BreedingStage.keptAsHeifer),
        isActive: const Value(false),
      ),
    );
    return calfId;
  }

  /// "If female -> No" branch: "Sell" + "Add to costs statement". Recorded
  /// as income in [LedgerEntries] rather than [Expenses] -- see chat notes
  /// on why a sale shouldn't land in a costs table.
  Future<void> sellCalf({
    required int cycleId,
    required int cowId,
    required double amount,
    required DateTime saleDate,
    String? note,
  }) async {
    await transaction(() async {
      await (update(breedingCycles)..where((t) => t.id.equals(cycleId)))
          .write(
        BreedingCyclesCompanion(
          calfSex: const Value('male'),
          sold: const Value(true),
          saleAmount: Value(amount),
          saleDate: Value(saleDate),
          stage: const Value(BreedingStage.soldCalf),
          isActive: const Value(false),
        ),
      );

      await into(ledgerEntries).insert(
        LedgerEntriesCompanion.insert(
          cowId: Value(cowId),
          breedingCycleId: Value(cycleId),
          type: 'income',
          category: 'calf_sale',
          amount: amount,
          date: Value(saleDate),
          note: Value(note),
        ),
      );
    });
  }

  /// The single open cycle for a cow, if any.
  Stream<BreedingCycle?> watchActiveBreedingCycle(int cowId) {
    final query = select(breedingCycles)
      ..where((t) => t.cowId.equals(cowId) & t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);
    return query.watchSingleOrNull();
  }

  /// All open cycles, for a dashboard. Combine with `deriveDisplayStage`
  /// from breeding_logic.dart in the UI layer to know what's due today.
  Stream<List<BreedingCycle>> watchAllActiveBreedingCycles() {
    return (select(breedingCycles)..where((t) => t.isActive.equals(true)))
        .watch();
  }

  // Unified Connection File
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
