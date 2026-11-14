import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/screens/widgets/production_insights_card.dart';
import 'package:cow/services/ai/production_insights_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as d;

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Production Analytics",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<d.TypedResult>>(
        stream: database.watchTodayEntriesWithCowNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final joinedEntries = snapshot.data ?? [];

          // CALCULATE VOLUMES BY SESSION TYPE
          double morningTotal = 0;
          double middayTotal = 0;
          double eveningTotal = 0;

          for (var row in joinedEntries) {
            final entry = row.readTable(database.milkTable);
            if (entry.session == MilkSession.morning) {
              morningTotal += entry.amount;
            }
            if (entry.session == MilkSession.afternoon) {
              middayTotal += entry.amount;
            }
            if (entry.session == MilkSession.evening) {
              eveningTotal += entry.amount;
            }
          }

          double grandTotal = morningTotal + middayTotal + eveningTotal;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // GRAND TOTAL SCOREBOARD CARD
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          "TOTAL PRODUCTION TODAY",
                          style: TextStyle(
                            color: context.farm.warning,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          litres(grandTotal),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: context.farm.good,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "+8% vs yesterday",
                              style: TextStyle(color: context.farm.good),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // AI ADVISORY INSIGHTS CARD
                const Text(
                  "AI Farm Insights",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ProductionInsightsCard(
                  snapshot: ProductionSnapshot(
                    logs: joinedEntries.map((row) {
                      final entry = row.readTable(database.milkTable);
                      final cow = row.readTable(database.cow);
                      return MilkLog(
                        cowName: cow.name,
                        session: entry.session,
                        litres: entry.amount,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Session Breakdown",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _buildSessionBar(
                        title: "Morning",
                        amount: morningTotal,
                        total: grandTotal,
                        color: context.farm.warning,
                      ),
                    ),
                    Expanded(
                      child: _buildSessionBar(
                        title: "Afternoon",
                        amount: middayTotal,
                        total: grandTotal,
                        color: context.farm.warning,
                      ),
                    ),
                    Expanded(
                      child: _buildSessionBar(
                        title: "Evening",
                        amount: eveningTotal,
                        total: grandTotal,
                        color: context.farm.warning,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),
                const Text(
                  "Today's Live Logs",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (joinedEntries.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text(
                        "No milk has been logged yet today.",
                        style: TextStyle(
                          color: context.farm.muted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: joinedEntries.length,
                    itemBuilder: (context, index) {
                      final row = joinedEntries[index];
                      final entry = row.readTable(database.milkTable);
                      final cow = row.readTable(database.cow);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: context.farm.info,
                            child: Icon(Icons.opacity),
                          ),
                          title: Text(
                            cow.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.farm.info,
                              fontSize: 30.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Amount: ${litres(entry.amount)}",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: context.farm.good,
                                ),
                              ),
                              Text(
                                "Session: ${entry.session.toUpperCase()}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.jm().format(entry.entryDate),
                                style: TextStyle(
                                  color: context.farm.muted,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.check_circle,
                            color: context.farm.good,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionBar({
    required String title,
    required double amount,
    required double total,
    required Color color,
  }) {
    final percent = total == 0 ? 0.0 : amount / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: context.farm.muted,
              color: color,
              minHeight: 8,
            ),
            const SizedBox(height: 4),
            Text(
              "${amount.toStringAsFixed(1)}L (${(percent * 100).toStringAsFixed(0)}%)",
              style: TextStyle(color: context.farm.muted),
            ),
          ],
        ),
      ),
    );
  }
}
