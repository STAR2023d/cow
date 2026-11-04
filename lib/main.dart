import 'package:cow/database/app_database.dart';
import 'package:cow/screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // ONE AppDatabase instance for the whole app lifetime. Every screen
    // reads it via Provider.of<AppDatabase>(context) instead of ever
    // constructing `AppDatabase()` itself. Constructing it more than
    // once opens a second SQLite connection to the same file, which
    // causes stale streams and, on native platforms, "database is
    // locked" errors under concurrent writes.
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
      child: const CowApp(),
    ),
  );
}

class CowApp extends StatelessWidget {
  const CowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mwaura's Farm",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: MainDashboard.primaryNavy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MainDashboard.accentBlue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 33, 7, 80),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainDashboard(),
    );
  }
}