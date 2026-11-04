import 'package:flutter/material.dart';

/// Central colour palette. Change a colour here and the whole app follows.
class AppColors {
  AppColors._();

  static const Color background = Color.fromARGB(255, 13, 23, 41);
  static const Color card = Color.fromARGB(255, 23, 37, 65);
  static const Color accent = Color.fromARGB(255, 30, 144, 255);
  static const Color appBar = Color.fromARGB(255, 33, 7, 80);
  static const Color highlight = Color.fromARGB(255, 250, 143, 3);
}

/// App-wide theme, used by MaterialApp in main.dart.
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBar,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
