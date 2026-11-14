import 'package:cow/database/app_database.dart';
import 'package:cow/screens/main_dashboard.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = await ThemeController.load();
  runApp(
    // ONE AppDatabase instance for the whole app lifetime. Every screen
    // reads it via Provider.of<AppDatabase>(context) instead of ever
    // constructing `AppDatabase()` itself. Constructing it more than
    // once opens a second SQLite connection to the same file, which
    // causes stale streams and, on native platforms, "database is
    // locked" errors under concurrent writes.
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        ChangeNotifierProvider<ThemeController>.value(value: theme),
      ],
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
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: context.watch<ThemeController>().mode,
      home: const MainDashboard(),
    );
  }
}
