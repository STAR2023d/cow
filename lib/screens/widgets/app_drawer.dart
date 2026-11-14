import 'package:cow/l10n/language_controller.dart';
import 'package:cow/breeding/breeding_overview_screen.dart';
import 'package:cow/breeding/calf_register_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:cow/screens/expenses_screen.dart';
import 'package:cow/screens/feeding_screen.dart';
import 'package:cow/screens/financial_statement_screen.dart';
import 'package:cow/screens/health_screen.dart';
import 'package:cow/screens/milk_price_screen.dart';
import 'package:cow/screens/herd_milk_sheet.dart';
import 'package:cow/screens/monthly_report_screen.dart';
import 'package:cow/screens/vet_assistant_screen.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The navigation drawer shown on the main dashboard, grouped by job.
/// Only real screens are listed: no placeholders that do nothing.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    // Closes the drawer first, so Back from the screen returns to Home.
    Widget item(IconData icon, String title, WidgetBuilder screen) =>
        _DrawerItem(
          icon: icon,
          title: title,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: screen));
          },
        );

    return Drawer(
      width: 260,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(),
            child: Center(
              child: Text(
                context.l10n.appTitle.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          ),
          _Section(context.l10n.sectionHerd),
          item(
            Icons.water_drop,
            context.l10n.navLogMilk,
            (_) => HerdMilkSheet(db: db),
          ),
          item(Icons.pets, context.l10n.navHerdMilk, (_) => HerdDashboard()),
          item(
            Icons.favorite,
            context.l10n.navBreeding,
            (_) => const BreedingOverviewScreen(),
          ),
          item(
            Icons.child_friendly,
            context.l10n.navCalfRegister,
            (_) => CalfRegisterScreen(db: db),
          ),
          _Section(context.l10n.sectionDailyCare),
          item(
            Icons.grass,
            context.l10n.navFeeding,
            (_) => FeedingScreen(db: db),
          ),
          item(
            Icons.health_and_safety,
            context.l10n.navHealth,
            (_) => HealthScreen(db: db),
          ),
          item(
            Icons.medical_services,
            context.l10n.navVetAssistant,
            (_) => const VetAssistantScreen(),
          ),
          _Section(context.l10n.sectionMoney),
          item(
            Icons.sell,
            context.l10n.navMilkPrice,
            (_) => MilkPriceScreen(db: db),
          ),
          item(
            Icons.money,
            context.l10n.navExpenses,
            (_) => ExpenseEntryScreen(db: db),
          ),
          item(
            Icons.receipt_long,
            context.l10n.navStatement,
            (_) => StatementScreen(db: db),
          ),
          item(
            Icons.bar_chart,
            context.l10n.navMonthlyReport,
            (_) => MonthlyReportScreen(db: db),
          ),
          item(
            Icons.analytics,
            context.l10n.navMilkAnalytics,
            (_) => const AnalyticsDashboard(),
          ),
          const Divider(),
          const _LanguageChoice(),
          const _ThemeChoice(),
        ],
      ),
    );
  }
}

/// English or Kiswahili. Each language is named in its own words so a
/// farmer can always find theirs.
class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LanguageController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.language,
            style: TextStyle(color: context.farm.muted),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'sw', label: Text('Kiswahili')),
            ],
            selected: {controller.locale.languageCode},
            onSelectionChanged: (s) => controller.setLanguage(s.first),
          ),
        ],
      ),
    );
  }
}

/// Light, dark or the phone's setting. Light reads best outdoors.
class _ThemeChoice extends StatelessWidget {
  const _ThemeChoice();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.screenColours,
            style: TextStyle(color: context.farm.muted),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
              ),
              segments: [
                _themeSegment(
                  ThemeMode.light,
                  Icons.light_mode,
                  context.l10n.themeLight,
                ),
                _themeSegment(
                  ThemeMode.dark,
                  Icons.dark_mode,
                  context.l10n.themeDark,
                ),
                _themeSegment(
                  ThemeMode.system,
                  Icons.phone_android,
                  context.l10n.themePhone,
                ),
              ],
              selected: {controller.mode},
              onSelectionChanged: (s) => controller.setMode(s.first),
            ),
          ),
        ],
      ),
    );
  }

  /// Icon above the word, so the three choices fit a narrow drawer.
  ButtonSegment<ThemeMode> _themeSegment(
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    return ButtonSegment(
      value: mode,
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, softWrap: false),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: context.farm.muted,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
