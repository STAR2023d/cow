import 'package:cow/models/milk_headline.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fullDay = {'Morning': 10.0, 'Afternoon': 6.0, 'Evening': 8.0};

  test('nothing logged today shows yesterday, no percent', () {
    final h = MilkHeadline.from(today: {}, yesterday: fullDay);
    expect(h.kind, MilkHeadlineKind.yesterdayOnly);
    expect(h.litres, 24);
    expect(h.percentChange, isNull);
  });

  test('both days empty', () {
    final h = MilkHeadline.from(today: {}, yesterday: {});
    expect(h.kind, MilkHeadlineKind.none);
  });

  test('morning only is compared with yesterday morning', () {
    final h = MilkHeadline.from(today: {'Morning': 11}, yesterday: fullDay);
    expect(h.kind, MilkHeadlineKind.today);
    expect(h.litres, 11);
    expect(h.percentChange, closeTo(10, 0.001));
  });

  test('full day is compared with full day', () {
    final h = MilkHeadline.from(
      today: {'Morning': 12, 'Afternoon': 6, 'Evening': 12},
      yesterday: fullDay,
    );
    expect(h.litres, 30);
    expect(h.percentChange, closeTo(25, 0.001));
  });

  test('no yesterday milk for those sessions gives no percent', () {
    final h = MilkHeadline.from(
      today: {'Evening': 8},
      yesterday: {'Morning': 10},
    );
    expect(h.kind, MilkHeadlineKind.today);
    expect(h.percentChange, isNull);
  });

  test('sessionTotalsByDay adds cows per session and day', () {
    final d = DateTime(2026, 11, 21);
    final m = sessionTotalsByDay([
      (date: d, session: 'Morning', litres: 5),
      (date: d, session: 'Morning', litres: 4),
      (date: d, session: 'Evening', litres: 3),
    ]);
    expect(m[d], {'Morning': 9.0, 'Evening': 3.0});
  });
}
