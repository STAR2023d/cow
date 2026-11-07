import 'package:cow/database/app_database.dart';
import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:cow/screens/expenses_screen.dart';
import 'package:cow/screens/feeding_screen.dart';
import 'package:cow/screens/health_screen.dart';
import 'package:cow/screens/vet_assistant_screen.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The navigation drawer shown on the main dashboard.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Drawer(
      width: 240,
      backgroundColor: AppColors.card,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.card),
            child: Center(
              child: Text(
                "MWAURA'S FARM",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.search,
            title: 'Search',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.money,
            title: 'Expenses',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseEntryScreen(db: db),
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.pets,
            title: 'Herd',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HerdDashboard()),
            ),
          ),
          _DrawerItem(
            icon: Icons.grass,
            title: 'Feeding',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedingScreen(db: db)),
            ),
          ),
          _DrawerItem(
            icon: Icons.health_and_safety,
            title: 'Health',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HealthScreen(db: db)),
            ),
          ),
          _DrawerItem(
            icon: Icons.medical_services,
            title: 'Vet Assistant',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VetAssistantScreen(),
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.analytics,
            title: 'Analytics',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnalyticsDashboard(),
              ),
            ),
          ),
          const Divider(color: Colors.white30),
          _DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => Navigator.pop(context),
          ),
        ],
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
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
