import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/breeding/calf_register.dart';
import 'package:cow/breeding/calf_register_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

BreedingCycle _cycle(
  int id, {
  DateTime? born,
  BreedingStage stage = BreedingStage.calved,
  String? sex,
  int? calfCowId,
  bool sold = false,
  double? saleAmount,
}) => BreedingCycle(
  id: id,
  cowId: 1,
  heatDate: DateTime(2025, 1, 1),
  gestationDays: 283,
  actualCalvingDate: born,
  calfSex: sex,
  calfCowId: calfCowId,
  sold: sold,
  saleAmount: saleAmount,
  stage: stage,
  isActive: stage == BreedingStage.calved,
  createdAt: DateTime(2025, 1, 1),
);

const _cows = [CowData(id: 1, name: 'Daisy'), CowData(id: 5, name: 'Lulu')];

final _cycles = [
  _cycle(
    1,
    born: DateTime(2026, 3, 1),
    stage: BreedingStage.keptAsHeifer,
    sex: 'female',
    calfCowId: 5,
  ),
  _cycle(
    2,
    born: DateTime(2026, 9, 1),
    stage: BreedingStage.soldCalf,
    sex: 'male',
    sold: true,
    saleAmount: 15000,
  ),
  _cycle(3, born: DateTime(2026, 11, 10)), // awaiting outcome
  _cycle(4, stage: BreedingStage.confirmedPregnant), // not born yet
];

void main() {
  group('buildCalfRegister', () {
    test('lists only calved cycles, newest first, with outcomes', () {
      final r = buildCalfRegister(_cows, _cycles);
      expect(r.map((c) => c.cycle!.id), [3, 2, 1]);
      expect(r.map((c) => c.outcome), [
        CalfOutcome.awaiting,
        CalfOutcome.sold,
        CalfOutcome.kept,
      ]);
      expect(r.last.calfName, 'Lulu');
      expect(r.last.damName, 'Daisy');
      expect(r.first.sex, isNull);
    });

    test('age reads in days, weeks, months and years', () {
      final calf = buildCalfRegister(_cows, [
        _cycle(1, born: DateTime(2026, 1, 31)),
      ]).single;
      expect(calf.ageOn(DateTime(2026, 2, 1)), '1 day');
      expect(calf.ageOn(DateTime(2026, 2, 10)), '10 days');
      expect(calf.ageOn(DateTime(2026, 3, 14)), '6 weeks');
      expect(calf.ageOn(DateTime(2026, 6, 30)), '4 months');
      expect(calf.ageOn(DateTime(2028, 2, 1)), '2 years');
    });

    test('missing dam falls back to the cow id', () {
      final r = buildCalfRegister(const [], [
        _cycle(1, born: DateTime(2026, 1, 1)),
      ]);
      expect(r.single.damName, 'Cow #1');
    });
  });

  group('merging Calves rows', () {
    Calf row(
      int id, {
      int? cycleId,
      String? name,
      DateTime? born,
      String sex = 'female',
      int? damId,
      double? weight,
      DateTime? weaned,
      bool boughtIn = false,
    }) => Calf(
      id: id,
      breedingCycleId: cycleId,
      name: name,
      dateOfBirth: born ?? DateTime(2026, 1, 1),
      sex: sex,
      damCowId: damId,
      birthWeightKg: weight,
      weanedOn: weaned,
      boughtIn: boughtIn,
    );

    test('a row linked to a cycle adds its details to that calf', () {
      final r = buildCalfRegister(_cows, _cycles, [
        row(
          10,
          cycleId: 2,
          sex: 'unknown',
          weight: 30.5,
          weaned: DateTime(2026, 11, 1),
        ),
      ]);
      expect(r, hasLength(3)); // no extra entry
      final sold = r.firstWhere((c) => c.cycle?.id == 2);
      expect(sold.birthWeightKg, 30.5);
      expect(sold.weanedOn, DateTime(2026, 11, 1));
      expect(sold.outcome, CalfOutcome.sold);
      expect(sold.sex, 'male'); // the cycle wins over the stored value
    });

    test('a calf with no cycle is listed on its own, newest first', () {
      final r = buildCalfRegister(_cows, _cycles, [
        row(
          11,
          name: 'Toto',
          born: DateTime(2026, 10, 1),
          damId: 1,
          boughtIn: true,
        ),
        row(12, born: DateTime(2020, 5, 5)), // unknown dam
      ]);
      expect(r, hasLength(5));
      final toto = r.firstWhere((c) => c.calfName == 'Toto');
      expect(toto.fromCycle, isFalse);
      expect(toto.outcome, CalfOutcome.onFarm);
      expect(toto.boughtIn, isTrue);
      expect(toto.damName, 'Daisy');
      expect(r.last.details!.id, 12);
      expect(r.last.damName, 'Unknown dam');
      // Dates descending.
      final dates = r.map((c) => c.bornOn).toList();
      expect(dates, [...dates]..sort((a, b) => b.compareTo(a)));
    });

    test('a row whose cycle has no calving date is still listed', () {
      final r = buildCalfRegister(_cows, _cycles, [
        row(13, cycleId: 4, weight: 28),
      ]);
      final orphan = r.singleWhere((c) => c.details?.id == 13);
      expect(orphan.fromCycle, isFalse);
      expect(orphan.birthWeightKg, 28);
    });

    test('an unknown stored sex reads as not recorded', () {
      final r = buildCalfRegister(const [], const [], [
        row(14, sex: 'unknown'),
      ]);
      expect(r.single.sex, isNull);
    });
  });

  Future<void> show(WidgetTester tester, List<BreedingCycle> cycles) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CalfRegisterScreen(
          cows: Stream.value(_cows),
          cycles: Stream.value(cycles),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  testWidgets('screen shows summary and each calf', (tester) async {
    await show(tester, _cycles);
    expect(
      find.text('3 calves · 1 kept · 1 sold · 1 awaiting outcome'),
      findsOneWidget,
    );
    expect(find.text('Lulu'), findsOneWidget);
    expect(find.text('Sold · 15,000'), findsOneWidget);
    expect(find.text('Awaiting outcome'), findsOneWidget);
    expect(find.text('Calf of Daisy'), findsNWidgets(2));
  });

  testWidgets('a calf row shows birth weight and weaning date', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CalfRegisterScreen(
          cows: Stream.value(_cows),
          cycles: Stream.value(const []),
          calves: Stream.value([
            Calf(
              id: 1,
              name: 'Toto',
              dateOfBirth: DateTime(2026, 1, 1),
              sex: 'male',
              birthWeightKg: 32,
              weanedOn: DateTime(2026, 4, 3),
              boughtIn: true,
            ),
          ]),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(find.text('Toto'), findsOneWidget);
    expect(find.text('Bought in'), findsOneWidget);
    expect(
      find.textContaining('32 kg at birth · Weaned on 3/4/2026'),
      findsOneWidget,
    );
  });

  testWidgets('screen explains when there are no calves', (tester) async {
    await show(tester, const []);
    expect(find.textContaining('No calves yet'), findsOneWidget);
  });
}
