import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:drift/drift.dart' as d;
import 'package:cow/database/app_database.dart';

// ------------------------------------------------------------
// Data classes (unchanged)
// ------------------------------------------------------------
class FarmInsightsData {
  final String statusOverview;
  final List<CowPerformance> topPerformers;
  final List<TimePattern> sessionPatterns;
  final List<String> actionableRecommendations;

  FarmInsightsData({
    required this.statusOverview,
    required this.topPerformers,
    required this.sessionPatterns,
    required this.actionableRecommendations,
  });

  factory FarmInsightsData.fromJson(Map<String, dynamic> json) {
    return FarmInsightsData(
      statusOverview: json['statusOverview'] ?? '',
      topPerformers: (json['topPerformers'] as List? ?? [])
          .map((e) => CowPerformance.fromJson(e))
          .toList(),
      sessionPatterns: (json['sessionPatterns'] as List? ?? [])
          .map((e) => TimePattern.fromJson(e))
          .toList(),
      actionableRecommendations: List<String>.from(
        json['actionableRecommendations'] ?? [],
      ),
    );
  }
}

class CowPerformance {
  final String name;
  final double yield;
  final String status;
  CowPerformance({
    required this.name,
    required this.yield,
    required this.status,
  });
  factory CowPerformance.fromJson(Map<String, dynamic> json) => CowPerformance(
    name: json['name'] ?? '',
    yield: (json['yield'] as num? ?? 0).toDouble(),
    status: json['status'] ?? '',
  );
}

class TimePattern {
  final String session;
  final double percentage;
  final String efficiencyLog;
  TimePattern({
    required this.session,
    required this.percentage,
    required this.efficiencyLog,
  });
  factory TimePattern.fromJson(Map<String, dynamic> json) => TimePattern(
    session: json['session'] ?? '',
    percentage: (json['percentage'] as num? ?? 0).toDouble(),
    efficiencyLog: json['efficiencyLog'] ?? '',
  );
}

// ------------------------------------------------------------
// Main AIService – now includes the missing method
// ------------------------------------------------------------
class AIService {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static final _jsonSchema = Schema.object(
    properties: {
      'statusOverview': Schema.string(
        description: 'One sentence headline of overall farm performance.',
      ),
      'topPerformers': Schema.array(
        items: Schema.object(
          properties: {
            'name': Schema.string(),
            'yield': Schema.number(),
            'status': Schema.string(
              description: 'Performance tier status label.',
            ),
          },
        ),
      ),
      'sessionPatterns': Schema.array(
        items: Schema.object(
          properties: {
            'session': Schema.string(
              description: 'Morning, Midday, or Evening.',
            ),
            'percentage': Schema.number(
              description: 'Contribution percentage to the total daily volume.',
            ),
            'efficiencyLog': Schema.string(),
          },
        ),
      ),
      'actionableRecommendations': Schema.array(
        items: Schema.string(description: 'Short 5-8 word operational tips.'),
      ),
    },
  );

  // ---------- Original method that returns structured data ----------
  static Future<FarmInsightsData?> getGraphicalInsights({
    required List<d.TypedResult> joinedEntries,
    required double morning,
    required double midday,
    required double evening,
    required double total,
    required d.ResultSetImplementation<MilkTable, dynamic> milkTable,
    required d.ResultSetImplementation<Cow, dynamic> cowTable,
  }) async {
    if (_apiKey.isEmpty) return null;

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: _jsonSchema,
        ),
      );

      StringBuffer dataInput = StringBuffer();
      for (var row in joinedEntries) {
        final entry = row.readTableOrNull(milkTable);
        final cow = row.readTableOrNull(cowTable);
        if (entry != null && cow != null) {
          dataInput.writeln(
            "Cow:${cow.name},Vol:${entry.amount}L,Time:${entry.session}",
          );
        }
      }
      dataInput.writeln(
        "Totals-> AM:$morning, Noon:$midday, PM:$evening, All:$total",
      );

      final response = await model.generateContent([
        Content.text(
          "Analyze the following milking metrics and output data strictly matching the requested JSON schema constraints:\n$dataInput",
        ),
      ]);

      if (response.text == null) return null;
      final Map<String, dynamic> decoded = jsonDecode(response.text!);
      return FarmInsightsData.fromJson(decoded);
    } catch (e) {
      return null;
    }
  }

  // ---------- NEW method: returns a plain String (used by your Dashboard) ----------
  static Future<String> getProductionInsights({
    required List<d.TypedResult> joinedEntries,
    required double morning,
    required double midday,
    required double evening,
    required double total,
    required d.ResultSetImplementation<MilkTable, dynamic> milkTable,
    required d.ResultSetImplementation<Cow, dynamic> cowTable,
  }) async {
    final data = await getGraphicalInsights(
      joinedEntries: joinedEntries,
      morning: morning,
      midday: midday,
      evening: evening,
      total: total,
      milkTable: milkTable,
      cowTable: cowTable,
    );

    if (data == null) {
      return 'No AI advice available at this time.';
    }

    final buffer = StringBuffer();
    buffer.writeln(data.statusOverview);

    if (data.topPerformers.isNotEmpty) {
      buffer.write('🏆 Top performers: ');
      buffer.write(
        data.topPerformers
            .map(
              (c) => '${c.name} (${c.yield.toStringAsFixed(1)}L, ${c.status})',
            )
            .join('; '),
      );
      buffer.writeln();
    }

    if (data.sessionPatterns.isNotEmpty) {
      buffer.write('Session distribution: ');
      buffer.write(
        data.sessionPatterns
            .map(
              (p) =>
                  '${p.session}: ${p.percentage.toStringAsFixed(0)}% (${p.efficiencyLog})',
            )
            .join('; '),
      );
      buffer.writeln();
    }

    if (data.actionableRecommendations.isNotEmpty) {
      buffer.write('Recommendations: ');
      buffer.write(data.actionableRecommendations.join('; '));
    }

    return buffer.toString();
  }
}
