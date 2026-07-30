import 'package:cow/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FarmAnalyticsDashboard extends StatelessWidget {
  final FarmInsightsData data;

  const FarmAnalyticsDashboard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Headline Status Card
          Card(
            elevation: 0,
            color: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.indigo)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(LucideIcons.sparkles, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data.statusOverview,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Graphical Chart Section (Session Breakdown via Pie Chart)
          const Text("Yield Distribution Patterns", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: data.sessionPatterns.map((pattern) {
                  Color color = Colors.blue;
                  if (pattern.session.toLowerCase().contains('morning')) color = Colors.amber;
                  if (pattern.session.toLowerCase().contains('evening')) color = Colors.indigo;
                  
                  return PieChartSectionData(
                    color: color,
                    value: pattern.percentage,
                    title: '${pattern.percentage.toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Top Performing Cows List
          const Text("Top Cow Leaders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.topPerformers.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cow = data.topPerformers[index];
              return ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.blueGrey, child: Icon(LucideIcons.accessibility, size: 18, color: Colors.white)),
                title: Text(cow.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(cow.status, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                trailing: Text('${cow.yield}L', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              );
            },
          ),
          const SizedBox(height: 24),

          // 4. Actionable Bullet List
          const Text("Operational Action Items", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...data.actionableRecommendations.map((tips) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                key: ValueKey(tips),
                child: Row(
                  children: [
                    const Icon(LucideIcons.checkCircle2, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tips, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
