import 'package:cow/l10n/language_controller.dart';
import 'package:cow/breeding/breeding_alerts_card.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/herd_milk_sheet.dart';
import 'package:cow/screens/widgets/app_drawer.dart';
import 'package:cow/screens/widgets/farm_header_card.dart';
import 'package:cow/screens/widgets/health_reminders_card.dart';
import 'package:cow/screens/widgets/herd_summary_card.dart';
import 'package:cow/screens/widgets/milk_hold_card.dart';
import 'package:cow/screens/widgets/milk_price_card.dart';
import 'package:cow/screens/widgets/milk_yield_card.dart';
import 'package:cow/screens/widgets/quick_actions_hub.dart';
import 'package:cow/screens/widgets/recent_activity_card.dart';
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
      appBar: AppBar(
        title: Text(
          context.l10n.dashboard,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(),
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

            // 1a. The daily job, one tap away.
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                icon: const Icon(Icons.water_drop, size: 26),
                label: Text(
                  context.l10n.logMilk,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HerdMilkSheet(db: db)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // 1a2. Milk price (asks for it until set)
            MilkPriceCard(db: db),

            // 1b. Breeding alerts (hidden when nothing needs attention)
            BreedingAlertsCard(db: db),

            // 1c. Cows whose milk is on hold (hidden when none)
            MilkHoldCard(db: db),

            // 1d. Health reminders (hidden when none)
            HealthRemindersCard(db: db),

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
