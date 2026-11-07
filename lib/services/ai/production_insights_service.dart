import 'dart:convert';

import 'package:cow/services/ai/ai_generator.dart';

/// One milking entry, reduced to what the AI needs to see.
class MilkLog {
  final String cowName;
  final String session;
  final double litres;

  const MilkLog({
    required this.cowName,
    required this.session,
    required this.litres,
  });
}

/// Today's milk, ready to be analysed.
class ProductionSnapshot {
  final List<MilkLog> logs;

  const ProductionSnapshot({required this.logs});

  double get total => logs.fold(0.0, (sum, l) => sum + l.litres);

  /// Litres per session name, for example {Morning: 12.0, Evening: 8.0}.
  Map<String, double> get bySession {
    final totals = <String, double>{};
    for (final l in logs) {
      totals[l.session] = (totals[l.session] ?? 0) + l.litres;
    }
    return totals;
  }

  /// Identical milk data always gives the same signature, whatever order
  /// the entries arrive in. Used to avoid asking the AI the same question
  /// twice.
  String get signature {
    final parts =
        logs.map((l) => '${l.cowName}|${l.session}|${l.litres}').toList()
          ..sort();
    return parts.join(';');
  }
}

class ProductionInsights {
  final String headline;
  final List<String> topCows;
  final List<String> sessionNotes;
  final List<String> tips;

  const ProductionInsights({
    required this.headline,
    this.topCows = const [],
    this.sessionNotes = const [],
    this.tips = const [],
  });
}

const String productionSystemInstruction = '''
You are a milk production analyst for a small-scale dairy farm in Kenya.
Be brief, practical and encouraging. Use plain language.

Rules:
- Only use the numbers you are given. Do not invent figures.
- You are not a vet. If a cow's yield looks unusually low, suggest checking
  her feed, water and health, and using the Vet Assistant if she seems
  unwell.
- Reply with JSON only, no other text.
''';

String buildProductionPrompt(ProductionSnapshot s) {
  final lines = s.logs.map(
    (l) => '- ${l.cowName}: ${l.litres.toStringAsFixed(1)} L, ${l.session}',
  );
  final sessions = s.bySession.entries
      .map((e) => '${e.key}: ${e.value.toStringAsFixed(1)} L')
      .join(', ');

  return '''
Today's milk logs:
${lines.join('\n')}

Totals: ${s.total.toStringAsFixed(1)} L in total ($sessions)

Reply with a JSON object with exactly these keys:
{
  "headline": "one sentence summary of today's production",
  "topCows": ["up to 3 short items such as 'Daisy: 12.5 L'"],
  "sessionNotes": ["up to 3 short observations about the milking sessions"],
  "tips": ["up to 4 short, practical tips of 5 to 10 words"]
}
''';
}

/// Turns the AI's reply into [ProductionInsights]. Returns null when the
/// reply is not usable.
ProductionInsights? parseProductionInsights(String raw) {
  var text = raw.trim();
  final fenced = RegExp(r'```(?:json)?\s*([\s\S]*?)```').firstMatch(text);
  if (fenced != null) text = fenced.group(1)!.trim();

  final Object? decoded;
  try {
    decoded = jsonDecode(text);
  } catch (_) {
    return null;
  }
  if (decoded is! Map<String, dynamic>) return null;

  List<String> strings(Object? value) => value is List
      ? value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
      : <String>[];

  final insights = ProductionInsights(
    headline: (decoded['headline'] ?? '').toString(),
    topCows: strings(decoded['topCows']),
    sessionNotes: strings(decoded['sessionNotes']),
    tips: strings(decoded['tips']),
  );

  final empty =
      insights.headline.isEmpty &&
      insights.topCows.isEmpty &&
      insights.sessionNotes.isEmpty &&
      insights.tips.isEmpty;
  return empty ? null : insights;
}

class ProductionInsightsService {
  final AiGenerator generator;

  const ProductionInsightsService([this.generator = const GeminiGenerator()]);

  // Remembers answers while the app is open, so reopening the screen with
  // the same milk data costs nothing.
  static final Map<String, ProductionInsights> _cache = {};
  static const int _maxCached = 20;

  static ProductionInsights? cached(ProductionSnapshot snapshot) =>
      _cache[snapshot.signature];

  static void clearCache() => _cache.clear();

  /// Analyses [snapshot]. Asks the AI only when the same milk data has not
  /// been analysed already, unless [forceRefresh] is true.
  Future<AiResult<ProductionInsights>> analyse(
    ProductionSnapshot snapshot, {
    bool forceRefresh = false,
  }) async {
    if (snapshot.logs.isEmpty) {
      return const AiResult.fail(AiFailure.unknown, 'No milk logged');
    }

    if (!forceRefresh) {
      final hit = _cache[snapshot.signature];
      if (hit != null) return AiResult.ok(hit);
    }

    final result = await generator.generate(
      prompt: buildProductionPrompt(snapshot),
      system: productionSystemInstruction,
      json: true,
    );
    if (!result.isOk) return AiResult.fail(result.failure!, result.detail);

    final insights = parseProductionInsights(result.value!);
    if (insights == null) {
      return const AiResult.fail(
        AiFailure.unknown,
        'Could not read the AI reply',
      );
    }

    _cache[snapshot.signature] = insights;
    if (_cache.length > _maxCached) _cache.remove(_cache.keys.first);
    return AiResult.ok(insights);
  }
}
