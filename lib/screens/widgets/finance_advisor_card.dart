import 'package:cow/models/monthly_report.dart';
import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/ai_messages.dart';
import 'package:cow/services/ai/finance_advisor_service.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// The month's warning signs (worked out instantly, no AI) plus optional
/// AI advice and a box to ask a question about the numbers.
class FinanceAdvisorCard extends StatefulWidget {
  final MonthlyReport current;
  final MonthlyReport? previous;
  final FinanceAdvisorService service;

  const FinanceAdvisorCard({
    super.key,
    required this.current,
    this.previous,
    this.service = const FinanceAdvisorService(),
  });

  @override
  State<FinanceAdvisorCard> createState() => _FinanceAdvisorCardState();
}

class _FinanceAdvisorCardState extends State<FinanceAdvisorCard> {
  final _question = TextEditingController();
  FinanceAdvice? _advice;
  String _askedQuestion = '';
  AiFailure? _failure;
  bool _loading = false;

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final question = _question.text.trim();
    setState(() {
      _loading = true;
      _failure = null;
    });

    final result = await widget.service.advise(
      current: widget.current,
      previous: widget.previous,
      question: question.isEmpty ? null : question,
    );
    if (!result.isOk) {
      debugPrint('Finance advisor failed: ${result.failure} ${result.detail}');
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (result.isOk) {
        _advice = result.value;
        _askedQuestion = question;
      } else {
        _failure = result.failure;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alerts = findFinanceAlerts(widget.current, widget.previous);
    final advice = _advice;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purpleAccent),
              SizedBox(width: 8),
              Text(
                'AI Finance Advisor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (alerts.isNotEmpty)
            _Bullets('Things to watch', alerts, color: Colors.orangeAccent),
          if (advice != null) ...[
            if (advice.headline.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  advice.headline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            _Bullets('What I notice', advice.insights),
            _Bullets('Suggestions', advice.suggestions),
            if (advice.answer.isNotEmpty && _askedQuestion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You asked: $_askedQuestion',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      advice.answer,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
          ] else if (alerts.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Nothing unusual spotted. Tap Get advice for an AI summary '
                'of this month.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          if (_failure != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _failure!.message,
                style: const TextStyle(color: Colors.orangeAccent),
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _question,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Ask about this month (optional)',
              hintText: 'For example: why is my profit low?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _loading ? null : _ask,
              icon: _loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'Thinking...' : 'Get advice'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const _Bullets(this.title, this.items, {this.color = Colors.white70});

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
              child: Text('• $item', style: TextStyle(color: color)),
            ),
          ),
        ],
      ),
    );
  }
}
