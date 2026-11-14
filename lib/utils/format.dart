import 'package:intl/intl.dart';

/// One way to show money, litres and dates on every screen and PDF, the
/// way Kenyan farmers write them: `KSh 5,500`, `6.5 L`, `14 Nov 2026`.
/// File names and AI prompts keep their own formats.

final _whole = NumberFormat('#,##0');
final _cents = NumberFormat('#,##0.00');
final _litres = NumberFormat('#,##0.##');

/// `KSh 5,500`, or `KSh 5,500.00` with [cents]. Negative: `-KSh 1,200`.
String ksh(num value, {bool cents = false}) {
  final text = (cents ? _cents : _whole).format(value.abs());
  return value < 0 ? '-KSh $text' : 'KSh $text';
}

/// An amount without the currency, for tables headed "Amounts in KES":
/// `5,500.00`.
String amount(num value) => _cents.format(value);

/// `6.5 L`, `12 L`, `1,250 L`.
String litres(num value) => '${_litres.format(value)} L';

/// `14 Nov 2026`.
String shortDate(DateTime d) => DateFormat('d MMM yyyy').format(d);

/// `14 Nov`, for recent items where the year is obvious.
String dayMonth(DateTime d) => DateFormat('d MMM').format(d);

/// `Sat 14 Nov`, for things due soon.
String weekdayDate(DateTime d) => DateFormat('EEE d MMM').format(d);

/// `November 2026`.
String monthYear(DateTime d) => DateFormat('MMMM yyyy').format(d);

/// `14 Nov 2026, 07:30`.
String dateTime(DateTime d) => DateFormat('d MMM yyyy, HH:mm').format(d);
