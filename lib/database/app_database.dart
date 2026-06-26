import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Generates a single unified file for all tables
part 'app_database.g.dart';

// --- TABLE 1: COW ---
class Cow extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 100)();
  TextColumn get tag => text().nullable()();
  TextColumn get breed => text().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get imagePath => text().nullable()();
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

// --- UNIFIED DATABASE CLASS ---
@DriftDatabase(tables: [Cow, MilkTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  
  @override
  int get schemaVersion => 2;

  // Custom migration strategy to automatically build the new table on user devices
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Creates the milk table when upgrading an existing app installation
          await m.createTable(milkTable);
        }
      },
    );
  }
  // === ANALYTICS FOR TODAY ===

  // Watches only entries logged TODAY (from midnight to midnight)
  Stream<List<MilkTableData>> watchTodayEntries() {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final tomorrowMidnight = todayMidnight.add(const Duration(days: 1));

    return (select(milkTable)
          ..where((tbl) => tbl.entryDate.isBiggerOrEqualValue(todayMidnight))
          ..where((tbl) => tbl.entryDate.isSmallerThanValue(tomorrowMidnight)))
        .watch();
  }

  // Watches a combined list of milk data + cow info so we can see names
  Stream<List<TypedResult>> watchEntriesWithCowNames() {
    return select(
      milkTable,
    ).join([innerJoin(cow, cow.id.equalsExp(milkTable.cowId))]).watch();
  }

  // MILK HISTORY FOR SPECIFIC COW
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

  // === COW OPERATIONS ===
  Future<int> insertCow(CowCompanion cowCompanion) =>
      into(cow).insert(cowCompanion);
  Stream<List<CowData>> watchAllCow() => select(cow).watch();
  Future<bool> updateCowInfo(CowCompanion cowCompanion) =>
      update(cow).replace(cowCompanion);
  Future<int> deleteCow(int id) =>
      (delete(cow)..where((tbl) => tbl.id.equals(id))).go();

  // === MILK OPERATIONS ===
  Future<int> insertMilkEntry(MilkTableCompanion entry) =>
      into(milkTable).insert(entry);
  Stream<List<MilkTableData>> watchAllEntries() => select(milkTable).watch();

  // Unified Connection File
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database', // Keeps your original primary database name
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
