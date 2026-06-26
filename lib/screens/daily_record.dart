import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_add.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:cow/screens/widgets/hover_action_button.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  // Base background theme configuration
  static const Color primaryNavy = Color.fromARGB(255, 13, 23, 41);
  static const Color cardNavy = Color.fromARGB(255, 23, 37, 65);
  static const Color accentBlue = Color.fromARGB(255, 30, 144, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 7, 80),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      drawer: Drawer(
        width: 240,
        backgroundColor: cardNavy,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: cardNavy),
              child: const Center(
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
              icon: Icons.pets,
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
            const Divider(color: Colors.white30),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Hero Card
            _buildHeaderHero(),
            const SizedBox(height: 16.0),

            // 2. Primary KPI Data Layout Grid
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildMilkYieldCard()),
                  const SizedBox(width: 12.0),
                  Expanded(child: _buildHerdSummaryCard()),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // 3. Operational Quick Action Button Hub
            _buildQuickActionHub(context),
            const SizedBox(height: 16.0),

            // 4. Activity Logs and Operational Notification List
            _buildRecentActivitySection(),
          ],
        ),
      ),
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

  // --- Dashboard Section Widgets ---

  Widget _buildHeaderHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text(
            "MWAURA'S FARM",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "PURE • FRESH • NATURAL",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(Icons.eco, color: Colors.greenAccent, size: 16),
              SizedBox(width: 4.0),
              Icon(Icons.opacity, color: Colors.blueAccent, size: 16),
              SizedBox(width: 4.0),
              Icon(Icons.wb_sunny, color: Colors.orangeAccent, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilkYieldCard() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MILK YIELD (LITERS)",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          // Clean Custom Sparkline Graph Representation
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildGraphBar(30),
                _buildGraphBar(45),
                _buildGraphBar(35),
                _buildGraphBar(40),
                _buildGraphBar(50),
                _buildGraphBar(75, isPeak: true), // Peak indicator decoration
                _buildGraphBar(55),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Text(
              "M  T  W  T  F  S  S",
              style: TextStyle(
                fontSize: 9,
                color: Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "2,936 L",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "+5% from yesterday",
            style: TextStyle(
              fontSize: 11,
              color: Colors.greenAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphBar(double percentageHeight, {bool isPeak = false}) {
    return Container(
      width: 6,
      height: percentageHeight,
      decoration: BoxDecoration(
        color: isPeak ? accentBlue : Colors.white24,
        borderRadius: BorderRadius.circular(3),
        boxShadow: isPeak
            ? [
                const BoxShadow(
                  color: accentBlue,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildHerdSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "MY HERD SUMMARY",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
              letterSpacing: 0.5,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Icon(Icons.pets, color: Colors.white70, size: 28),
          ),
          Column(
            children: const [
              Text(
                "54",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              Text(
                "Total Animals",
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              "• 35 Jersey  • 19 Holstein",
              style: TextStyle(
                fontSize: 9,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionHub(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
        color: cardNavy,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 26,
                    child: HoverActionButton(
                      icon: Icons.add,

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CowAdd(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 4.0),
                  Text(
                    'Add Cow',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timelapse, size: 28, color: Colors.white),
                  const SizedBox(height: 4.0),
                  Text(
                    'Milking',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.feed, size: 28, color: Colors.white),
                  const SizedBox(height: 4.0),
                  Text(
                    'Feeding',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.health_and_safety, size: 28, color: Colors.white),
                  const SizedBox(height: 4.0),
                  Text(
                    'Health',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12.0),
          // Placeholder for activity items
          const Text(
            'No recent activity',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
