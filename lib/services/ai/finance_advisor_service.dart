import 'dart:convert';

import 'package:cow/models/expense_category.dart';
import 'package:cow/models/monthly_report.dart';
import 'package:cow/services/ai/ai_generator.dart';
import 'package:intl/intl.dart';

final _whole = NumberFormat('#,##0');
final _cents = NumberFormat('#,##0.00');

String _pct(double ratio) => '${(ratio * 100).round()}%';

/// Things worth a farmer's attention, found by plain arithmetic so they
/// appear instantly and work without internet. [previous] is the month
/// before (for the same days when [current] is a month in progress).
List<String> findFinanceAlerts(MonthlyReport current, MonthlyReport? previous) {
  final alerts = <String>[];

  if (current.net < 0) {
    alerts.add(
      'Expenses are higher than income by ${_whole.format(-current.net)}.',
    );
  }

  if (previous == null) return alerts;

  final period = current.throughDay != null
      ? 'the same days last month'
      : 'last month';

  final before = previous.costPerLitre;
  final after = current.costPerLitre;
  if (before != null && after != null && before > 0 && after >= before * 1.2) {
    alerts.add(
      'Cost per litre rose from ${_cents.format(before)} to '
      '${_cents.format(after)} (+${_pct(after / before - 1)}).',
    );
  }

  if (previous.totalIncome > 0 &&
      current.totalIncome <= previous.totalIncome * 0.8) {
    alerts.add(
      'Income is down ${_pct(1 - current.totalIncome / previous.totalIncome)} '
      'compared with $period.',
    );
  }

  if (previous.litres > 0 && current.litres <= previous.litres * 0.8) {
    alerts.add(
      'Milk production is down ${_pct(1 - current.litres / previous.litres)} '
      '(${previous.litres.toStringAsFixed(0)} L to '
      '${current.litres.toStringAsFixed(0)} L).',
    );
  }

  for (final entry in current.categoriesBySpend) {
    final label = ExpenseCategory.label(entry.key);
    final value = entry.value;
    final prior = previous.expensesByCategory[entry.key] ?? 0;

    if (prior > 0) {
      if (value >= prior * 1.3 &&
          value - prior >= current.totalExpenses * 0.05) {
        alerts.add(
          '$label spending rose ${_pct(value / prior - 1)} '
          '(from ${_whole.format(prior)} to ${_whole.format(value)}).',
        );
      }
    } else if (previous.totalExpenses > 0 &&
        value >= current.totalExpenses * 0.2) {
      alerts.add(
        '$label is new this month: ${_whole.format(value)} '
        '(${_pct(value / current.totalExpenses)} of spending).',
      );
    }
  }

  return alerts;
}

class FinanceAdvice {
  final String headline;
  final List<String> insights;
  final List<String> suggestions;

  /// The reply to the farmer's question, empty when none was asked.
  final String answer;

  const FinanceAdvice({
    required this.headline,
    this.insights = const [],
    this.suggestions = const [],
    this.answer = '',
  });
}

const String financeSystemInstruction = '''
You are a farm finance helper for a small-scale dairy farmer in Kenya.
Amounts are in Kenyan shillings (KSh). Be brief, practical and plain.

Rules:
- Only use the numbers you are given. Never invent figures or prices.
- If the month has only a few days of data, say the picture is still early.
- Give practical ideas such as using feed efficiently, checking milk
  prices, or cutting waste.
- Do not give tax, loan, investment or legal advice. Suggest speaking to
  a local agricultural extension officer or an accountant for those.
- If a question cannot be answered from the numbers, say so honestly.
- Reply with JSON only, no other text.
''';

String buildFinancePrompt({
  required MonthlyReport current,
  MonthlyReport? previous,
  required List<String> alerts,
  String? question,
}) {
  String block(String title, MonthlyReport r) {
    final categories = r.categoriesBySpend
        .map(
          (e) => '${ExpenseCategory.label(e.key)}: ${_whole.format(e.value)}',
        )
        .join(', ');
    final cost = r.costPerLitre;
    return '''
$title
- Milk produced: ${r.litres.toStringAsFixed(1)} L
- Milk income: ${_whole.format(r.milkCash)}
- Other income (such as calf sales): ${_whole.format(r.otherIncome)}
- Total expenses: ${_whole.format(r.totalExpenses)}${categories.isEmpty ? '' : ' ($categories)'}
- Profit: ${_whole.format(r.net)}
- Cost per litre: ${cost == null ? 'not available' : _cents.format(cost)}''';
  }

  final monthName = DateFormat('MMMM yyyy').format(current.month);
  final partial = current.throughDay != null;

  final currentTitle = partial
      ? '$monthName (so far, days 1 to ${current.throughDay})'
      : monthName;
  final previousTitle = partial
      ? 'Last month (the same days)'
      : 'The month before';

  final lines = <String>[
    block(currentTitle, current),
    '',
    previous == null
        ? 'No earlier month to compare with.'
        : block(previousTitle, previous),
    '',
    'Things the app already noticed:',
    if (alerts.isEmpty) '- nothing unusual' else ...alerts.map((a) => '- $a'),
    if (question != null && question.isNotEmpty) ...[
      '',
      "Farmer's question: $question",
    ],
  ];

  return '''
${lines.join('\n')}

Reply with a JSON object with exactly these keys:
{
  "headline": "one sentence on how the month is going",
  "insights": ["up to 4 short observations using the numbers above"],
  "suggestions": ["up to 4 short, practical suggestions"],
  "answer": "a short answer to the farmer's question, or an empty string if none was asked"
}
''';
}

/// Turns the AI's reply into [FinanceAdvice]. Returns null when the reply
/// is not usable.
FinanceAdvice? parseFinanceAdvice(String raw) {
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

  final advice = FinanceAdvice(
    headline: (decoded['headline'] ?? '').toString(),
    insights: strings(decoded['insights']),
    suggestions: strings(decoded['suggestions']),
    answer: (decoded['answer'] ?? '').toString(),
  );

  final empty =
      advice.headline.isEmpty &&
      advice.insights.isEmpty &&
      advice.suggestions.isEmpty &&
      advice.answer.isEmpty;
  return empty ? null : advice;
}

String _signature(MonthlyReport r) {
  final categories =
      (r.expensesByCategory.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)))
          .map((e) => '${e.key}=${e.value}')
          .join(',');
  return [
    r.month.toIso8601String(),
    r.throughDay,
    r.litres,
    r.milkCash,
    r.otherIncome,
    r.totalExpenses,
    categories,
  ].join('|');
}

class FinanceAdvisorService {
  final AiGenerator generator;

  const FinanceAdvisorService([this.generator = const GeminiGenerator()]);

  // Remembers answers while the app is open, so asking the same thing
  // about the same numbers costs nothing.
  static final Map<String, FinanceAdvice> _cache = {};
  static const int _maxCached = 20;

  static void clearCache() => _cache.clear();

  /// Asks the AI for advice on [current], comparing with [previous] when
  /// there is one. The alerts from [findFinanceAlerts] are always included
  /// so the AI starts from the same facts the farmer sees.
  Future<AiResult<FinanceAdvice>> advise({
    required MonthlyReport current,
    MonthlyReport? previous,
    String? question,
    bool forceRefresh = false,
  }) async {
    if (current.isEmpty) {
      return const AiResult.fail(AiFailure.unknown, 'Nothing recorded');
    }

    final asked = question?.trim() ?? '';
    final key =
        '${_signature(current)}##'
        '${previous == null ? '-' : _signature(previous)}##$asked';

    if (!forceRefresh) {
      final hit = _cache[key];
      if (hit != null) return AiResult.ok(hit);
    }

    final result = await generator.generate(
      prompt: buildFinancePrompt(
        current: current,
        previous: previous,
        alerts: findFinanceAlerts(current, previous),
        question: asked,
      ),
      system: financeSystemInstruction,
      json: true,
    );
    if (!result.isOk) return AiResult.fail(result.failure!, result.detail);

    final advice = parseFinanceAdvice(result.value!);
    if (advice == null) {
      return const AiResult.fail(
        AiFailure.unknown,
        'Could not read the AI reply',
      );
    }

    _cache[key] = advice;
    if (_cache.length > _maxCached) _cache.remove(_cache.keys.first);
    return AiResult.ok(advice);
  }
}
