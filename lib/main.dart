import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/screens/main_dashboard.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = await ThemeController.load();
  final language = await LanguageController.load();
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
        ChangeNotifierProvider<LanguageController>.value(value: language),
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
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: context.watch<LanguageController>().locale,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: context.watch<ThemeController>().mode,
      home: const MainDashboard(),
    );
  }
}
