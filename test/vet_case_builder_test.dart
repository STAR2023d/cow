import 'package:cow/database/app_database.dart';
import 'package:cow/services/ai/vet_case_builder.dart';
import 'package:cow/services/ai/vet_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  final now = DateTime(2026, 11, 7, 12);

  Future<CowData> addCow(String name, {String? breed, int? age}) async {
    final id = await db.insertCow(
      CowCompanion.insert(
        name: name,
        breed: breed == null ? const Value.absent() : Value(breed),
        age: age == null ? const Value.absent() : Value(age),
      ),
    );
    final cows = await db.watchAllCow().first;
    return cows.firstWhere((c) => c.id == id);
  }

  test('a cow with no history gives a plain case', () async {
    final cow = await addCow('Bella');

    final c = await buildVetCase(
      db: db,
      cow: cow,
      symptoms: '  Limping on the back leg  ',
      duration: '   ',
      now: now,
    );

    expect(c.cowName, 'Bella');
    expect(c.symptoms, 'Limping on the back leg');
    expect(c.duration, isNull);
    expect(c.breedingStatus, isNull);
    expect(c.recentMilkNote, isNull);
    expect(c.language, VetLanguage.english);
  });

  test('breed and age are passed along', () async {
    final cow = await addCow('Daisy', breed: 'Friesian', age: 4);

    final c = await buildVetCase(
      db: db,
      cow: cow,
      symptoms: 'Not eating',
      duration: '2 days',
      language: VetLanguage.swahili,
      now: now,
    );

    expect(c.breed, 'Friesian');
    expect(c.ageYears, 4);
    expect(c.duration, '2 days');
    expect(c.language, VetLanguage.swahili);
  });

  test('includes the breeding stage of an open cycle', () async {
    final cow = await addCow('Daisy');
    final cycleId = await db.startBreedingCycle(
      cowId: cow.id,
      heatDate: DateTime(2026, 5, 31),
    );
    await db.recordService(cycleId, DateTime(2026, 6, 1));
    for (var n = 1; n <= 3; n++) {
      await db.recordPregnancyCheck(
        cycleId: cycleId,
        checkNumber: n,
        passed: true,
        checkDate: DateTime(2026, 6, 1).add(Duration(days: 21 * n)),
      );
    }

    final c = await buildVetCase(
      db: db,
      cow: cow,
      symptoms: 'Not eating',
      now: now,
    );

    expect(c.breedingStatus, contains('Pregnancy confirmed'));
    expect(c.breedingStatus, contains('expected calving'));
  });

  test('includes the last 7 days of milk, oldest first', () async {
    final cow = await addCow('Daisy');
    await db.upsertMilkEntry(
      cowId: cow.id,
      date: DateTime(2026, 11, 6, 6, 30),
      session: MilkSession.morning,
      amount: 12,
    );
    await db.upsertMilkEntry(
      cowId: cow.id,
      date: DateTime(2026, 11, 7, 6, 30),
      session: MilkSession.morning,
      amount: 8,
    );

    final c = await buildVetCase(
      db: db,
      cow: cow,
      symptoms: 'Swollen udder',
      now: now,
    );

    expect(c.recentMilkNote, isNotNull);
    expect(c.recentMilkNote, endsWith('12.0, 8.0'));
  });
}
