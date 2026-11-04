import 'package:cow/breeding/breeding_status_card.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_add.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:cow/screens/expenses_screen.dart';
import 'package:cow/screens/feeding_screen.dart';
import 'package:cow/screens/financial_statement_screen.dart';
import 'package:cow/screens/health_screen.dart';
import 'package:cow/screens/widgets/hover_action_button.dart';
import 'package:drift/drift.dart' show TypedResult;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  // Base background theme configuration
  static const Color primaryNavy = Color.fromARGB(255, 13, 23, 41);
  static const Color cardNavy = Color.fromARGB(255, 23, 37, 65);
  static const Color accentBlue = Color.fromARGB(255, 30, 144, 255);

  @override
  Widget build(BuildContext context) {
    // Read the single shared instance created in main.dart. Every
    // navigation call below reuses this — nothing constructs a fresh
    // AppDatabase() anymore.
    final db = Provider.of<AppDatabase>(context, listen: false);

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
              icon: Icons.money,
              title: 'Expenses',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseEntryScreen(db: db),
                ),
              ),
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
              icon: Icons.grass,
              title: 'Feeding',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedingScreen(db: db)),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.health_and_safety,
              title: 'Health',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HealthScreen(db: db)),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.analytics,
              title: 'Analytics',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsDashboard(),
                  ),
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

            // 2. Primary KPI Data Layout Grid — now live-streamed
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildMilkYieldCard(db)),
                  const SizedBox(width: 12.0),
                  Expanded(child: _buildHerdSummaryCard(db)),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // 3. Operational Quick Action Button Hub
            _buildQuickActionHub(context, db),
            const SizedBox(height: 16.0),

            // 4. Activity Logs and Operational Notification List
            _buildRecentActivitySection(db),
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
            ],
          ),
        ],
      ),
    );
  }

  /// Live 7-day milk yield card. One stream drives the sparkline, the
  /// headline total, and the day-over-day percentage change.
  Widget _buildMilkYieldCard(AppDatabase db) {
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 6));
    final end = DateTime(today.year, today.month, today.day);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: StreamBuilder<Map<DateTime, double>>(
        stream: db.watchDailyTotalsInRange(start, end),
        builder: (context, snapshot) {
          final totals = snapshot.data ?? {};

          //GENERATE CLEAN MIDNINGHT DATES
          final days = List.generate(7, (i) => start.add(Duration(days: i)));

          //Safely extract normalized values
          final values = days.map((d) => totals[d] ?? 0.0).toList();
          final maxValue = values.fold<double>(0, (m, v) => v > m ? v : m);
          final todayTotal = values.last;
          final yesterdayTotal = values[values.length - 2];
          final double? percentChange = yesterdayTotal > 0
              ? ((todayTotal - yesterdayTotal) / yesterdayTotal) * 100
              : null;

          //weekday list
          const weekMap = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final dayLabels = days.map((d) {
            final idx = d.weekday - 1;
            return (idx >= 0 && idx < 7) ? weekMap[idx] : '';
          }).toList();

          return Column(
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
              SizedBox(
                height: 50,
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (i) {
                          final isPeak = maxValue > 0 && values[i] == maxValue;
                          final height = maxValue > 0
                              ? (values[i] / maxValue) * 50
                              : 2.0;
                          // 1. Wrap each bar in Expanded so they scale to fit the row safely
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ), // Adds space between bars
                              child: _buildGraphBar(
                                height < 2 ? 2 : height,
                                isPeak: isPeak,
                              ),
                            ),
                          );
                        }),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    // 2. Changed fixed width SizedBox(width: 24) to Expanded
                    // This forces all 7 day labels to share width perfectly with the bars above
                    return Expanded(
                      child: Text(
                        dayLabels[i],
                        textAlign: TextAlign.center,
                        maxLines:
                            1, // Prevents text wrapping from pushing layout down
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Text(
                '${todayTotal.toStringAsFixed(1)} L',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                percentChange == null
                    ? 'No data for yesterday'
                    : '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(0)}% from yesterday',
                style: TextStyle(
                  fontSize: 11,
                  color: (percentChange ?? 0) >= 0
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
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

  /// Live herd size + breed breakdown, sourced from watchAllCow().
  Widget _buildHerdSummaryCard(AppDatabase db) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: StreamBuilder<List<CowData>>(
        stream: db.watchAllCow(),
        builder: (context, snapshot) {
          final cows = snapshot.data ?? [];
          final byBreed = <String, int>{};
          for (final c in cows) {
            final breed = c.breed ?? 'Unknown';
            byBreed[breed] = (byBreed[breed] ?? 0) + 1;
          }
          final breedSummary = byBreed.isEmpty
              ? 'No cows yet'
              : byBreed.entries.map((e) => '${e.value} ${e.key}').join('  •  ');

          return Column(
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
                children: [
                  Text(
                    '${cows.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const Text(
                    "Total Animals",
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  breedSummary,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActionHub(BuildContext context, AppDatabase db) {
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
            // Changed to mainAxisAligment.center since Expanded takes up all space anyway
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Wrap each action in an Expanded widget
              Expanded(
                child: _quickAction(
                  icon: Icons.add,
                  label: 'Add Cow',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CowAdd()),
                  ),
                ),
              ),
              Expanded(
                child: _quickAction(
                  icon: Icons.receipt_long,
                  label: 'Statement', // Capitalized 'S' for UI consistency
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatementScreen(db: db),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _quickAction(
                  icon: Icons.grass,
                  label: 'Feeding',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedingScreen(db: db),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _quickAction(
                  icon: Icons.health_and_safety,
                  label: 'Health',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthScreen(db: db),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _quickAction(
                  icon: Icons.analytics,
                  label: 'Breeding',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BreedingStatusCard(db: db, cowId: 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Removed SizedBox(height: 26) to stop the vertical clipping
        HoverActionButton(icon: icon, onPressed: onPressed),
        const SizedBox(
          height: 8.0,
        ), // 2. Slightly increased spacing for better breathing room
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  /// Live "Recent Activity" feed — the most recent milk entries, joined
  /// with the cow's name, instead of a static placeholder string.
  Widget _buildRecentActivitySection(AppDatabase db) {
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
          StreamBuilder<List<TypedResult>>(
            stream: db.watchRecentEntries(limit: 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              final rows = snapshot.data ?? [];
              if (rows.isEmpty) {
                return const Text(
                  'No recent activity',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                );
              }
              return Column(
                children: rows.map((row) {
                  final entry = row.readTable(db.milkTable);
                  final cowData = row.readTable(db.cow);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.opacity,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${cowData.name} • ${entry.session} • ${entry.amount.toStringAsFixed(1)} L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '${entry.entryDate.day}/${entry.entryDate.month}',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
