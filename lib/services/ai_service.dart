import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:drift/drift.dart' as d;
import 'package:cow/database/app_database.dart';

class AIService {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static String _buildPrompt(
    List<d.TypedResult> joinedEntries,
    double morning,
    double midday,
    double evening,
    double total,
    d.ResultSetImplementation<MilkTable, dynamic> milkTable,
    d.ResultSetImplementation<Cow, dynamic> cowTable,
  ) {
    StringBuffer logBuffer = StringBuffer();
    for (var row in joinedEntries) {
      final entry = row.readTableOrNull(milkTable);
      final cow = row.readTableOrNull(cowTable);
      if (entry != null && cow != null) {
        logBuffer.writeln(
          "- Cow: ${cow.name}, Amount: ${entry.amount}L, Session: ${entry.session}",
        );
      }
    }
    logBuffer.writeln("\nSummary:");
    logBuffer.writeln("  Morning: $morning L");
    logBuffer.writeln("  Midday: $midday L");
    logBuffer.writeln("  Evening: $evening L");
    logBuffer.writeln("  Total: $total L");
    logBuffer.writeln(
      "\nBased on this data, please provide insights on milk production patterns and suggest improvements for the farm.",
    );
    return logBuffer.toString();
  }

  static Future<String> getProductionInsights({
    required List<d.TypedResult> joinedEntries,
    required double morning,
    required double midday,
    required double evening,
    required double total,
    required d.ResultSetImplementation<MilkTable, dynamic> milkTable,
    required d.ResultSetImplementation<Cow, dynamic> cowTable,
  }) async {
    if (_apiKey.isEmpty) {
      return "AI Configuration Error: API Key missing.";
    }
    try {
      final model = GenerativeModel(model: 'gemini-3.5-flash', apiKey: _apiKey);
      final prompt = _buildPrompt(
        joinedEntries,
        morning,
        midday,
        evening,
        total,
        milkTable,
        cowTable,
      );
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "No insights generated.";
    } catch (e) {
      return "Failed to load AI advisory insights: $e";
    }
  }
}
