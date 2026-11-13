import 'package:cow/database/app_database.dart';

/// Milk sold to one buyer over a period.
class BuyerEarnings {
  /// The buyer as first typed, or null for entries with no buyer.
  final String? buyer;
  final double litres;
  final double cash;

  const BuyerEarnings({
    required this.buyer,
    required this.litres,
    required this.cash,
  });
}

DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

/// Groups [entries] by buyer, valuing each entry at [priceFor] its day.
///
/// Buyer names are matched ignoring case and extra spaces, so "Githunguri
/// Dairy" and "githunguri  dairy" are one buyer (shown as first typed).
/// Entries with no buyer are grouped under a null buyer. Biggest earner
/// first; the no-buyer group always comes last.
Future<List<BuyerEarnings>> earningsByBuyer(
  List<MilkTableData> entries,
  Future<double> Function(DateTime day) priceFor,
) async {
  final prices = <DateTime, double>{};
  final names = <String?, String?>{};
  final litres = <String?, double>{};
  final cash = <String?, double>{};

  for (final e in entries) {
    final day = _dayOf(e.entryDate);
    final price = prices[day] ??= await priceFor(day);
    final raw = e.buyer?.trim().replaceAll(RegExp(r'\s+'), ' ');
    final key = raw == null || raw.isEmpty ? null : raw.toLowerCase();
    names.putIfAbsent(key, () => key == null ? null : raw);
    litres[key] = (litres[key] ?? 0) + e.amount;
    cash[key] = (cash[key] ?? 0) + e.amount * price;
  }

  final list = [
    for (final k in litres.keys)
      BuyerEarnings(buyer: names[k], litres: litres[k]!, cash: cash[k]!),
  ];
  list.sort((a, b) {
    if (a.buyer == null) return 1;
    if (b.buyer == null) return -1;
    return b.cash.compareTo(a.cash);
  });
  return list;
}
