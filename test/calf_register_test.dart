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
      expect(r.map((c) => c.cycle.id), [3, 2, 1]);
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

  testWidgets('screen explains when there are no calves', (tester) async {
    await show(tester, const []);
    expect(find.textContaining('No calves yet'), findsOneWidget);
  });
}
