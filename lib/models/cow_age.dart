import 'package:cow/l10n/app_localizations.dart';

/// A cow's age in whole years and months on a given day.
class CowAge {
  final int years;
  final int months;
  const CowAge(this.years, this.months);

  @override
  bool operator ==(Object other) =>
      other is CowAge && other.years == years && other.months == months;

  @override
  int get hashCode => Object.hash(years, months);

  @override
  String toString() => 'CowAge($years y, $months m)';
}

/// Her age on [now], counted from [bornOn]. Null when the birth date is
/// not known. A birth date after [now] counts as 0 months.
CowAge? ageOn(DateTime? bornOn, DateTime now) {
  if (bornOn == null) return null;
  var months = (now.year - bornOn.year) * 12 + now.month - bornOn.month;
  if (now.day < bornOn.day) months--;
  if (months < 0) months = 0;
  return CowAge(months ~/ 12, months % 12);
}

/// "8 months", "1 year", "3 years 2 months" in the app language.
String ageLabel(L10n l, CowAge age) {
  if (age.years == 0) return l.ageMonths(age.months);
  if (age.months == 0) return l.ageYearsOnly(age.years);
  return l.ageYearsMonths(age.years, age.months);
}
