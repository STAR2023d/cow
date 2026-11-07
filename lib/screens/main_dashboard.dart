import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/app_drawer.dart';
import 'package:cow/screens/widgets/farm_header_card.dart';
import 'package:cow/screens/widgets/herd_summary_card.dart';
import 'package:cow/screens/widgets/milk_yield_card.dart';
import 'package:cow/screens/widgets/quick_actions_hub.dart';
import 'package:cow/screens/widgets/recent_activity_card.dart';
import 'package:cow/theme/app_theme.dart';
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
            const FarmHeaderCard(),
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
            QuickActionsHub(db: db),
            const SizedBox(height: 16.0),

            // 4. Activity Logs and Operational Notification List
            RecentActivityCard(db: db),
          ],
        ),
      ),
    );
  }
}
