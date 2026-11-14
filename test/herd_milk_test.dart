import 'package:cow/database/app_database.dart';
import 'package:cow/models/herd_milk.dart';
import 'package:flutter_test/flutter_test.dart';

MilkTableData _entry(int cow, String session, double litres) => MilkTableData(
  id: '$cow-$session-$litres',
  entryDate: DateTime(2026, 11, 10),
  session: session,
  amount: litres,
  cowId: cow,
);

void main() {
  test('suggests the session from the time of day', () {
    expect(defaultSessionFor(DateTime(2026, 11, 14, 5)), MilkSession.morning);
    expect(
      defaultSessionFor(DateTime(2026, 11, 14, 13)),
      MilkSession.afternoon,
    );
    expect(defaultSessionFor(DateTime(2026, 11, 14, 19)), MilkSession.evening);
  });

  test('today keeps the time; other days get a time in the session', () {
    final now = DateTime(2026, 11, 14, 8, 15);
    expect(entryTimeFor(DateTime(2026, 11, 14), MilkSession.morning, now), now);
    expect(
      entryTimeFor(DateTime(2026, 11, 13), MilkSession.evening, now),
      DateTime(2026, 11, 13, 18),
    );
  });

  test('usual yield averages one session per cow', () {
    final usual = usualYields([
      _entry(1, MilkSession.morning, 6),
      _entry(1, MilkSession.morning, 8),
      _entry(1, MilkSession.evening, 20),
      _entry(2, MilkSession.evening, 5),
    ], MilkSession.morning);
    expect(usual, {1: 7});
  });

  test('flags typos, not normal figures or new cows', () {
    expect(isUnusualYield(65, 6.5), isTrue); // missed decimal point
    expect(isUnusualYield(12, 6.5), isFalse);
    expect(isUnusualYield(14, 6.5), isTrue);
    expect(isUnusualYield(8, null), isFalse); // new cow
    expect(isUnusualYield(45, null), isTrue); // no cow gives 45 L
    expect(isUnusualYield(2, 0.5), isFalse); // tiny usual not used
  });

  test('reads litres boxes', () {
    expect(parseLitres(''), isNull);
    expect(parseLitres(' 6,5 '), 6.5);
    expect(parseLitres('abc'), isNaN);
    expect(parseLitres('0'), isNaN);
  });
}
