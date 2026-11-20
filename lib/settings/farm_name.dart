import 'package:cow/l10n/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The farm's name, chosen in Settings and remembered between runs. Until
/// one is chosen the app uses its built-in title, in the app language.
class FarmNameController extends ChangeNotifier {
  static const _key = 'farm_name';
  static const minLength = 2;
  static const maxLength = 60;

  String? _name;
  FarmNameController([this._name]);

  /// The chosen name, or null for the built-in one.
  String? get name => _name;

  static Future<FarmNameController> load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_key);
      final t = saved?.trim();
      return FarmNameController(t == null || t.isEmpty ? null : t);
    } catch (_) {
      return FarmNameController();
    }
  }

  /// Saves [name]; null or blank goes back to the built-in name.
  Future<void> setName(String? name) async {
    final t = name?.trim();
    final value = t == null || t.isEmpty ? null : t;
    if (value == _name) return;
    _name = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      value == null
          ? await prefs.remove(_key)
          : await prefs.setString(_key, value);
    } catch (_) {
      // Not saved; applies until the app closes.
    }
  }
}

extension FarmNameContext on BuildContext {
  /// The farm name to show; rebuilds when it changes.
  String get farmName => watch<FarmNameController?>()?.name ?? l10n.appTitle;

  /// The farm name now, for one-off use such as a PDF.
  String get farmNameNow => read<FarmNameController?>()?.name ?? l10n.appTitle;
}
