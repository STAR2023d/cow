import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = DateTime.utc(2026, 1, 1);

  group('BreedingSchedule', () {
    final s = BreedingSchedule(serviceDate: service);

    test('pregnancy checks fall at day 21, 42 and 63', () {
      expect(s.check1Due, DateTime.utc(2026, 1, 22));
      expect(s.check2Due, DateTime.utc(2026, 2, 12));
      expect(s.check3Due, DateTime.utc(2026, 3, 5));
    });

    test('expected calving is 283 days after service', () {
      expect(s.expectedCalvingDate, DateTime.utc(2026, 10, 11));
    });

    test('calving run-up dates', () {
      expect(s.dryOffDate, DateTime.utc(2026, 8, 16));
      expect(s.prep4WeeksDate, DateTime.utc(2026, 9, 13));
      expect(s.prep2WeeksDate, DateTime.utc(2026, 9, 27));
      expect(s.prep1WeekDate, DateTime.utc(2026, 10, 4));
    });

    test('gestation length can be tuned per cycle', () {
      final custom = BreedingSchedule(serviceDate: service, gestationDays: 280);
      expect(custom.expectedCalvingDate, DateTime.utc(2026, 10, 8));
    });

    test('next service is eligible 90 days after calving', () {
      expect(
        BreedingSchedule.nextServiceEligibleDate(DateTime.utc(2026, 10, 11)),
        DateTime.utc(2027, 1, 9),
      );
    });
  });

  group('deriveDisplayStage', () {
    BreedingStage stage({
      DateTime? serviceDate,
      bool? c1,
      bool? c2,
      bool? c3,
      DateTime? calved,
      required DateTime now,
    }) {
      return deriveDisplayStage(
        now: now,
        serviceDate: serviceDate,
        check1Result: c1,
        check2Result: c2,
        check3Result: c3,
        actualCalvingDate: calved,
        gestationDays: 283,
      );
    }

    final now = DateTime.utc(2026, 1, 10);

    test('no service yet means awaiting service', () {
      expect(stage(now: now), BreedingStage.awaitingService);
    });

    test('served cow waits for each check in turn', () {
      expect(
        stage(now: now, serviceDate: service),
        BreedingStage.awaitingCheck1,
      );
      expect(
        stage(now: now, serviceDate: service, c1: true),
        BreedingStage.awaitingCheck2,
      );
      expect(
        stage(now: now, serviceDate: service, c1: true, c2: true),
        BreedingStage.awaitingCheck3,
      );
    });

    test('any negative check fails the cycle', () {
      expect(
        stage(now: now, serviceDate: service, c1: true, c2: false),
        BreedingStage.failed,
      );
    });

    test('calving date logged means calved', () {
      expect(
        stage(
          now: DateTime.utc(2026, 10, 12),
          serviceDate: service,
          c1: true,
          c2: true,
          c3: true,
          calved: DateTime.utc(2026, 10, 11),
        ),
        BreedingStage.calved,
      );
    });

    test('confirmed pregnant moves through the calving run-up', () {
      BreedingStage at(DateTime d) =>
          stage(now: d, serviceDate: service, c1: true, c2: true, c3: true);

      expect(at(DateTime.utc(2026, 6, 1)), BreedingStage.confirmedPregnant);
      expect(at(DateTime.utc(2026, 8, 20)), BreedingStage.dryOff);
      expect(at(DateTime.utc(2026, 9, 14)), BreedingStage.prep4Weeks);
      expect(at(DateTime.utc(2026, 9, 28)), BreedingStage.prep2Weeks);
      expect(at(DateTime.utc(2026, 10, 5)), BreedingStage.prep1Week);
    });
  });
}
