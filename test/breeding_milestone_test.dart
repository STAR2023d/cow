import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = DateTime.utc(2026, 1, 1);

  BreedingMilestone? at(BreedingStage stage, {DateTime? expected}) =>
      nextMilestone(
        stage: stage,
        serviceDate: service,
        gestationDays: 283,
        expectedCalvingDate: expected,
      );

  test('waiting for a check points at that check\'s due date', () {
    expect(at(BreedingStage.awaitingCheck1)!.label, 'Check 1 due');
    expect(at(BreedingStage.awaitingCheck1)!.date, DateTime.utc(2026, 1, 22));
    expect(at(BreedingStage.awaitingCheck2)!.date, DateTime.utc(2026, 2, 12));
    expect(at(BreedingStage.awaitingCheck3)!.date, DateTime.utc(2026, 3, 5));
  });

  test('every pregnant stage points at the expected calving date', () {
    for (final stage in [
      BreedingStage.confirmedPregnant,
      BreedingStage.dryOff,
      BreedingStage.prep4Weeks,
      BreedingStage.prep2Weeks,
      BreedingStage.prep1Week,
    ]) {
      final m = at(stage)!;
      expect(m.label, 'Calving expected');
      expect(m.date, DateTime.utc(2026, 10, 11));
    }
  });

  test('a stored expected calving date wins over the calculation', () {
    final stored = DateTime.utc(2026, 10, 15);
    expect(at(BreedingStage.dryOff, expected: stored)!.date, stored);
  });

  test('stages without a calendar date', () {
    final waiting = nextMilestone(
      stage: BreedingStage.awaitingService,
      serviceDate: null,
      gestationDays: 283,
    );
    expect(waiting!.label, 'Waiting for service');
    expect(waiting.date, isNull);
    expect(at(BreedingStage.calved)!.date, isNull);
  });

  test('closed cycles have no next milestone', () {
    expect(at(BreedingStage.failed), isNull);
    expect(at(BreedingStage.soldCalf), isNull);
  });
}
