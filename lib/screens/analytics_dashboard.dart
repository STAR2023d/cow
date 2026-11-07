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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Daily Production Analytics",
          style: TextStyle(
            color: Colors.white,
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
                  color: AppColors.card,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Text(
                          "TOTAL PRODUCTION TODAY",
                          style: TextStyle(
                            color: AppColors.highlight,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${grandTotal.toStringAsFixed(2)} L",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "+8% vs yesterday",
                              style: TextStyle(color: Colors.green[300]),
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
                    color: Colors.white,
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
                    color: Colors.white,
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
                        color: Colors.amber,
                      ),
                    ),
                    Expanded(
                      child: _buildSessionBar(
                        title: "Afternoon",
                        amount: middayTotal,
                        total: grandTotal,
                        color: Colors.amber,
                      ),
                    ),
                    Expanded(
                      child: _buildSessionBar(
                        title: "Evening",
                        amount: eveningTotal,
                        total: grandTotal,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),
                const Text(
                  "Today's Live Logs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (joinedEntries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text(
                        "No milk has been logged yet today.",
                        style: TextStyle(
                          color: Colors.grey,
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
                        color: AppColors.card,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.opacity, color: Colors.white),
                          ),
                          title: Text(
                            cow.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 30.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Amount: ${entry.amount.toStringAsFixed(2)} Liters",
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen,
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
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
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
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[700],
              color: color,
              minHeight: 8,
            ),
            const SizedBox(height: 4),
            Text(
              "${amount.toStringAsFixed(1)}L (${(percent * 100).toStringAsFixed(0)}%)",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
