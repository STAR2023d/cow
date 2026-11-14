import 'package:cow/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The price in force at [now]: the newest one that has started. Prices
/// set for a later day are upcoming and not returned.
PriceSetting? currentPrice(List<PriceSetting> history, DateTime now) {
  for (final p in history) {
    if (!p.effectiveDate.isAfter(now)) return p;
  }
  return null;
}

/// Remembers that the farmer has set a price at least once. Until then
/// the app uses a built-in KSh 50 and the dashboard asks for the real one.
class MilkPriceFlag {
  static const _key = 'milk_price_set';

  static Future<bool> isSet() async {
    try {
      return (await SharedPreferences.getInstance()).getBool(_key) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> markSet() async {
    try {
      await (await SharedPreferences.getInstance()).setBool(_key, true);
    } catch (_) {
      // Not remembered; the dashboard may ask again next time.
    }
  }
}
