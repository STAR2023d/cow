import 'package:cow/database/app_database.dart';

/// Helpers for the whole-herd milk sheet: which session to suggest, each
/// cow's usual yield, and which typed figures look like typing mistakes.

/// The session a farmer is most likely logging at [now]: morning before
/// 11:00, afternoon before 16:00, evening after that.
String defaultSessionFor(DateTime now) {
  if (now.hour < 11) return MilkSession.morning;
  if (now.hour < 16) return MilkSession.afternoon;
  return MilkSession.evening;
}

DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

/// The time stored for an entry on [day] in [session]. Today keeps the
/// current time (as the single-cow form does); other days get a fixed
/// time inside the session so the entry sorts in the right place.
DateTime entryTimeFor(DateTime day, String session, DateTime now) {
  if (dayOf(day) == dayOf(now)) return now;
  final hour = switch (session) {
    MilkSession.morning => 7,
    MilkSession.afternoon => 13,
    _ => 18,
  };
  return DateTime(day.year, day.month, day.day, hour);
}

/// Each cow's average litres for [session] over [entries] (the days
/// before the day being logged). Cows with no entries are left out.
Map<int, double> usualYields(List<MilkTableData> entries, String session) {
  final sum = <int, double>{};
  final count = <int, int>{};
  for (final e in entries) {
    if (e.session != session) continue;
    sum[e.cowId] = (sum[e.cowId] ?? 0) + e.amount;
    count[e.cowId] = (count[e.cowId] ?? 0) + 1;
  }
  return {for (final id in sum.keys) id: sum[id]! / count[id]!};
}

/// No cow gives this much in one milking; a figure above it is a typo.
const maxLitresPerSession = 40.0;

/// True when [litres] looks like a typing mistake: above
/// [maxLitresPerSession], or more than twice the cow's [usual] yield
/// (only when she usually gives at least 1 litre, so small numbers and
/// new cows are not flagged).
bool isUnusualYield(double litres, double? usual) {
  if (litres > maxLitresPerSession) return true;
  if (usual == null || usual < 1) return false;
  return litres > usual * 2;
}

/// Reads a litres box: null for empty, NaN for text that is not a
/// number above zero.
double? parseLitres(String text) {
  final t = text.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  final v = double.tryParse(t);
  return v == null || v <= 0 ? double.nan : v;
}
