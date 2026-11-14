import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// English or Kiswahili; remembered between runs. Also sets the default
/// locale for dates and numbers (`lib/utils/format.dart`).
class LanguageController extends ChangeNotifier {
  static const _key = 'language';
  static const supported = ['en', 'sw'];

  Locale _locale;
  LanguageController([this._locale = const Locale('en')]) {
    Intl.defaultLocale = _locale.languageCode;
  }

  Locale get locale => _locale;
  bool get isSwahili => _locale.languageCode == 'sw';

  static Future<LanguageController> load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key);
      if (saved != null && supported.contains(saved)) {
        return LanguageController(Locale(saved));
      }
    } catch (_) {
      // Fall back to English.
    }
    return LanguageController();
  }

  Future<void> setLanguage(String code) async {
    if (!supported.contains(code) || code == _locale.languageCode) return;
    _locale = Locale(code);
    Intl.defaultLocale = code;
    notifyListeners();
    try {
      await (await SharedPreferences.getInstance()).setString(_key, code);
    } catch (_) {
      // Not saved; applies until the app closes.
    }
  }
}

/// Short way to the translated strings: `context.l10n.logMilk`.
extension L10nContext on BuildContext {
  L10n get l10n => L10n.of(this);
}

/// A milking session's name in the app language. Sessions are stored in
/// English ('Morning', ...) in the database and must stay that way.
String sessionLabel(L10n l10n, String session) => switch (session) {
  MilkSession.morning => l10n.sessionMorning,
  MilkSession.afternoon => l10n.sessionAfternoon,
  MilkSession.evening => l10n.sessionEvening,
  _ => session,
};
