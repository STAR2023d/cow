import 'package:cow/theme/app_theme.dart';
import 'package:cow/breeding/breeding_status_card.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/cow_add.dart';
import 'package:cow/screens/feeding_screen.dart';
import 'package:cow/screens/financial_statement_screen.dart';
import 'package:cow/screens/health_screen.dart';
import 'package:cow/screens/widgets/app_drawer.dart';
import 'package:cow/screens/widgets/herd_summary_card.dart';
import 'package:cow/screens/widgets/hover_action_button.dart';
import 'package:cow/screens/widgets/milk_yield_card.dart';
import 'package:drift/drift.dart' show TypedResult;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});


  @override
  Widget build(BuildContext context) {
    // Read the single shared instance created in main.dart. Every
    // navigation call below reuses this — nothing constructs a fresh
    // AppDatabase() anymore.
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appBar,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      drawer: const AppDrawer(),

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
                  Expanded(child: MilkYieldCard(db: db)),
                  const SizedBox(width: 12.0),
                  Expanded(child: HerdSummaryCard(db: db)),
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

  // --- Dashboard Section Widgets ---

  Widget _buildHeaderHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.card,
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
        color: AppColors.card,
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
        color: AppColors.card,
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
