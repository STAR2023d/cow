/*import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 43, 2, 114),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        width: 240,
        backgroundColor: const Color.fromARGB(255, 33, 7, 80),
        child: ListView(
          padding: EdgeInsets.only(),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 5, 0, 19),
              ),
              child: Center(
                child: Text(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                  "MWAURA'S FARM",
                ),
              ),
            ),

            // Drawer Items:
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.search,
              title: 'Search',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.pets, // Fits the 'Herd' theme nicely
              title: 'Herd',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HerdDashboard()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.analytics,
              title: 'Analytics',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalyticsDashboard()),
                );
              },
            ),

            const Divider(color: Colors.white30), // Visual separator line

            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      // 3. The body is what shows on the main screen background
      body: const Center(child: Text('Tap the menu button at the top left!')),
    );
  }

  // A clean helper method to avoid repetitive item styling code
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}*/
