import 'package:cow/breeding/breeding_overview_screen.dart';
import 'package:cow/breeding/calf_register_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:cow/screens/expenses_screen.dart';
import 'package:cow/screens/feeding_screen.dart';
import 'package:cow/screens/financial_statement_screen.dart';
import 'package:cow/screens/health_screen.dart';
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
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Center(
              child: Text(
                "MWAURA'S FARM",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          ),
          const _Section('Herd'),
          item(Icons.water_drop, 'Log Milk', (_) => HerdMilkSheet(db: db)),
          item(Icons.pets, 'Herd & Milk', (_) => HerdDashboard()),
          item(
            Icons.favorite,
            'Breeding',
            (_) => const BreedingOverviewScreen(),
          ),
          item(
            Icons.child_friendly,
            'Calf Register',
            (_) => CalfRegisterScreen(db: db),
          ),
          const _Section('Daily care'),
          item(Icons.grass, 'Feeding', (_) => FeedingScreen(db: db)),
          item(Icons.health_and_safety, 'Health', (_) => HealthScreen(db: db)),
          item(
            Icons.medical_services,
            'Vet Assistant',
            (_) => const VetAssistantScreen(),
          ),
          const _Section('Money'),
          item(Icons.money, 'Expenses', (_) => ExpenseEntryScreen(db: db)),
          item(
            Icons.receipt_long,
            'Financial Statement',
            (_) => StatementScreen(db: db),
          ),
          item(
            Icons.bar_chart,
            'Monthly Report',
            (_) => MonthlyReportScreen(db: db),
          ),
          item(
            Icons.analytics,
            'Milk Analytics',
            (_) => const AnalyticsDashboard(),
          ),
          const Divider(),
          const _ThemeChoice(),
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
          Text('Screen colours', style: TextStyle(color: context.farm.muted)),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode),
                label: Text('Light'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode),
                label: Text('Dark'),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.phone_android),
                label: Text('Phone'),
              ),
            ],
            selected: {controller.mode},
            onSelectionChanged: (s) => controller.setMode(s.first),
          ),
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
