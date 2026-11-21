/// What the dashboard milk card shows under the bars.
enum MilkHeadlineKind {
  /// Today has milk: show today's litres and the change from yesterday.
  today,

  /// Nothing logged today yet, but yesterday has milk: show yesterday.
  yesterdayOnly,

  /// Nothing today or yesterday.
  none,
}

class MilkHeadline {
  final MilkHeadlineKind kind;
  final double litres;

  /// Percent change today vs yesterday; null when it can't be worked out.
  final double? percentChange;

  const MilkHeadline(this.kind, this.litres, [this.percentChange]);

  /// [today] and [yesterday] are litres per session ("Morning", ...).
  /// The change compares only the sessions already logged today with the
  /// same sessions yesterday, so a morning-only day is not set against a
  /// whole day.
  factory MilkHeadline.from({
    required Map<String, double> today,
    required Map<String, double> yesterday,
  }) {
    final todayTotal = today.values.fold<double>(0, (a, b) => a + b);
    final yesterdayTotal = yesterday.values.fold<double>(0, (a, b) => a + b);
    if (todayTotal > 0) {
      final base = today.keys.fold<double>(
        0,
        (sum, s) => sum + (yesterday[s] ?? 0),
      );
      final change = base > 0 ? (todayTotal - base) / base * 100 : null;
      return MilkHeadline(MilkHeadlineKind.today, todayTotal, change);
    }
    if (yesterdayTotal > 0) {
      return MilkHeadline(MilkHeadlineKind.yesterdayOnly, yesterdayTotal);
    }
    return const MilkHeadline(MilkHeadlineKind.none, 0);
  }
}

/// Litres per session for each day in [entries], keyed by midnight.
Map<DateTime, Map<String, double>> sessionTotalsByDay(
  Iterable<({DateTime date, String session, double litres})> entries,
) {
  final out = <DateTime, Map<String, double>>{};
  for (final e in entries) {
    final day = DateTime(e.date.year, e.date.month, e.date.day);
    final m = out.putIfAbsent(day, () => {});
    m[e.session] = (m[e.session] ?? 0) + e.litres;
  }
  return out;
}
