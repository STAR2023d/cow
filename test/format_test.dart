import 'package:cow/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('money', () {
    expect(ksh(5500), 'KSh 5,500');
    expect(ksh(383.25, cents: true), 'KSh 383.25');
    expect(ksh(-1200), '-KSh 1,200');
    expect(amount(5500), '5,500.00');
  });

  test('litres', () {
    expect(litres(6.5), '6.5 L');
    expect(litres(12), '12 L');
    expect(litres(6.556), '6.56 L');
    expect(litres(1250), '1,250 L');
  });

  test('dates', () {
    final d = DateTime(2026, 11, 14, 7, 5);
    expect(shortDate(d), '14 Nov 2026');
    expect(dayMonth(d), '14 Nov');
    expect(weekdayDate(d), 'Sat 14 Nov');
    expect(monthYear(d), 'November 2026');
    expect(dateTime(d), '14 Nov 2026, 07:05');
  });
}
