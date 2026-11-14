import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Brand colours that are the same in light and dark mode.
class AppColors {
  AppColors._();

  static const Color accent = Color.fromARGB(255, 30, 144, 255);
  static const Color appBar = Color.fromARGB(255, 33, 7, 80);

  // Dark mode surfaces.
  static const Color darkBackground = Color.fromARGB(255, 13, 23, 41);
  static const Color darkCard = Color.fromARGB(255, 23, 37, 65);

  // Light mode surfaces: off-white page, white cards (easy to read in sun).
  static const Color lightBackground = Color(0xFFF3F5F8);
  static const Color lightCard = Colors.white;
}

/// Colours with a meaning, chosen per mode so they stay readable: bright
/// on the dark background, deeper on the light one. Use them through
/// `context.farm`, never as fixed `Colors.*` values in screens.
@immutable
class FarmColors extends ThemeExtension<FarmColors> {
  /// Good news: profit, healthy, done.
  final Color good;

  /// Needs attention soon: milk on hold, due today, expenses.
  final Color warning;

  /// Act now or destructive: overdue, emergency, delete, loss.
  final Color danger;

  /// Neutral information: sold calves, links.
  final Color info;

  /// Breeding and calves.
  final Color special;

  /// Secondary text: hints, dates, captions.
  final Color muted;

  /// Lines, borders and subtle fills.
  final Color faint;

  const FarmColors({
    required this.good,
    required this.warning,
    required this.danger,
    required this.info,
    required this.special,
    required this.muted,
    required this.faint,
  });

  static const dark = FarmColors(
    good: Colors.greenAccent,
    warning: Colors.orangeAccent,
    danger: Colors.redAccent,
    info: Colors.lightBlueAccent,
    special: Colors.purpleAccent,
    muted: Colors.white70,
    faint: Colors.white24,
  );

  static const light = FarmColors(
    good: Color(0xFF2E7D32),
    warning: Color(0xFFBF360C),
    danger: Color(0xFFC62828),
    info: Color(0xFF1565C0),
    special: Color(0xFF6A1B9A),
    muted: Color(0xFF55606E),
    faint: Color(0xFFD5DAE1),
  );

  @override
  FarmColors copyWith({
    Color? good,
    Color? warning,
    Color? danger,
    Color? info,
    Color? special,
    Color? muted,
    Color? faint,
  }) => FarmColors(
    good: good ?? this.good,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    info: info ?? this.info,
    special: special ?? this.special,
    muted: muted ?? this.muted,
    faint: faint ?? this.faint,
  );

  @override
  FarmColors lerp(FarmColors? other, double t) {
    if (other == null) return this;
    return FarmColors(
      good: Color.lerp(good, other.good, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      special: Color.lerp(special, other.special, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
    );
  }
}

extension FarmThemeContext on BuildContext {
  /// The meaningful colours for the current mode.
  FarmColors get farm =>
      Theme.of(this).extension<FarmColors>() ?? FarmColors.dark;

  /// Card and panel background for the current mode.
  Color get cardColor => Theme.of(this).cardColor;
}

/// App-wide themes, used by MaterialApp in main.dart.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: brightness,
      surface: card,
    );
    final farm = isDark ? FarmColors.dark : FarmColors.light;

    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      cardColor: card,
      cardTheme: CardThemeData(color: card),
      dialogTheme: DialogThemeData(backgroundColor: card),
      drawerTheme: DrawerThemeData(backgroundColor: card),
      dividerColor: farm.faint,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extensions: [farm],
    );
  }
}

/// Light, dark or the phone's setting; remembered between runs. Light is
/// the default because it reads best outdoors.
class ThemeController extends ChangeNotifier {
  static const _key = 'theme_mode';

  ThemeMode _mode;
  ThemeController([this._mode = ThemeMode.light]);

  ThemeMode get mode => _mode;

  /// Reads the saved choice. Falls back to light if nothing was saved or
  /// the settings store cannot be read.
  static Future<ThemeController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      return ThemeController(
        ThemeMode.values.firstWhere(
          (m) => m.name == saved,
          orElse: () => ThemeMode.light,
        ),
      );
    } catch (_) {
      return ThemeController();
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
    } catch (_) {
      // Not saved; the choice still applies until the app closes.
    }
  }
}
