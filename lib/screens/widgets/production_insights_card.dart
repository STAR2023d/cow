import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/ai_messages.dart';
import 'package:cow/services/ai/production_insights_service.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// AI summary of today's milk. It only asks the AI when the farmer taps
/// the button, and it remembers the answer for the same milk data.
class ProductionInsightsCard extends StatefulWidget {
  final ProductionSnapshot snapshot;
  final ProductionInsightsService service;

  const ProductionInsightsCard({
    super.key,
    required this.snapshot,
    this.service = const ProductionInsightsService(),
  });

  @override
  State<ProductionInsightsCard> createState() => _ProductionInsightsCardState();
}

class _ProductionInsightsCardState extends State<ProductionInsightsCard> {
  ProductionInsights? _insights;
  String? _insightsSignature;
  AiFailure? _failure;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Reopening the screen with the same milk data shows the old answer.
    final hit = ProductionInsightsService.cached(widget.snapshot);
    if (hit != null) {
      _insights = hit;
      _insightsSignature = widget.snapshot.signature;
    }
  }

  /// New milk was logged after the answer on screen was produced.
  bool get _isStale =>
      _insights != null && _insightsSignature != widget.snapshot.signature;

  Future<void> _run({required bool force}) async {
    final snapshot = widget.snapshot;
    setState(() {
      _loading = true;
      _failure = null;
    });

    final result = await widget.service.analyse(snapshot, forceRefresh: force);
    if (!result.isOk) {
      debugPrint(
        'Production insights failed: ${result.failure} ${result.detail}',
      );
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (result.isOk) {
        _insights = result.value;
        _insightsSignature = snapshot.signature;
      } else {
        _failure = result.failure;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final insights = _insights;
    final hasMilk = widget.snapshot.logs.isNotEmpty;

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.insights, color: Colors.purpleAccent, size: 28),
                SizedBox(width: 8),
                Text(
                  'AI Production Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.purpleAccent, height: 20),
            if (insights != null) ...[
              if (insights.headline.isNotEmpty)
                Text(
                  insights.headline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              _Section('Top cows', insights.topCows),
              _Section('Milking sessions', insights.sessionNotes),
              _Section('Tips', insights.tips),
              if (_isStale)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'More milk has been logged since this analysis.',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
            ] else if (!hasMilk)
              const Text(
                'Log some milk today to get insights.',
                style: TextStyle(color: Colors.white70),
              )
            else
              const Text(
                "Tap the button to analyse today's milk.",
                style: TextStyle(color: Colors.white70),
              ),
            if (_failure != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _failure!.message,
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: (!hasMilk || _loading)
                    ? null
                    : () => _run(force: insights != null),
                icon: _loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _loading
                      ? 'Analysing...'
                      : (insights == null ? 'Analyse' : 'Refresh'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '• $item',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
