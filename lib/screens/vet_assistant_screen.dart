import 'package:cow/theme/app_theme.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/services/ai/ai_generator.dart';
import 'package:cow/services/ai/ai_messages.dart';
import 'package:cow/services/ai/vet_case_builder.dart';
import 'package:cow/services/ai/vet_record.dart';
import 'package:cow/services/ai/vet_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pick a cow, describe what is wrong, get guidance on how urgent it is.
class VetAssistantScreen extends StatefulWidget {
  final VetService service;

  const VetAssistantScreen({super.key, this.service = const VetService()});

  @override
  State<VetAssistantScreen> createState() => _VetAssistantScreenState();
}

class _VetAssistantScreenState extends State<VetAssistantScreen> {
  final _symptoms = TextEditingController();
  final _duration = TextEditingController();

  CowData? _cow;
  VetLanguage _language = VetLanguage.english;
  bool _loading = false;
  VetAssessment? _assessment;
  AiFailure? _failure;

  // What the current answer was based on, so saving it stays correct even
  // if the farmer edits the text boxes afterwards.
  CowData? _assessedCow;
  String _assessedSymptoms = '';
  bool _saved = false;

  @override
  void dispose() {
    _symptoms.dispose();
    _duration.dispose();
    super.dispose();
  }

  bool get _canAsk =>
      _cow != null && _symptoms.text.trim().isNotEmpty && !_loading;

  Future<void> _assess() async {
    final cow = _cow;
    if (cow == null) return;
    final db = Provider.of<AppDatabase>(context, listen: false);

    setState(() {
      _loading = true;
      _assessment = null;
      _failure = null;
      _assessedCow = cow;
      _assessedSymptoms = _symptoms.text.trim();
      _saved = false;
    });

    final vetCase = await buildVetCase(
      db: db,
      cow: cow,
      symptoms: _symptoms.text,
      duration: _duration.text,
      language: _language,
    );
    final result = await widget.service.assess(vetCase);
    if (!result.isOk) {
      debugPrint('Vet assistant failed: ${result.failure} ${result.detail}');
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      _assessment = result.value;
      _failure = result.failure;
    });
  }

  Future<void> _save() async {
    final cow = _assessedCow;
    final assessment = _assessment;
    if (cow == null || assessment == null || _saved) return;
    final db = Provider.of<AppDatabase>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    final draft = buildVetRecordDraft(
      assessment: assessment,
      symptoms: _assessedSymptoms,
    );
    await db.insertHealthRecord(
      HealthRecordCompanion.insert(
        date: DateTime.now(),
        cowId: cow.id,
        recordType: draft.recordType,
        description: draft.description,
        followUpDate: Value(draft.followUpDate),
      ),
    );

    if (!mounted) return;
    setState(() => _saved = true);
    messenger.showSnackBar(
      SnackBar(content: Text("Saved to ${cow.name}'s health records")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final flags = findRedFlags(_symptoms.text);

    return Scaffold(
      appBar: AppBar(title: const Text('Vet Assistant')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StreamBuilder<List<CowData>>(
            stream: db.watchAllCow(),
            builder: (context, snapshot) {
              final cows = snapshot.data ?? [];
              return DropdownButtonFormField<int>(
                initialValue: _cow?.id,
                decoration: const InputDecoration(
                  labelText: 'Which cow?',
                  border: OutlineInputBorder(),
                ),
                items: cows
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (id) => setState(() {
                  _cow = cows.firstWhere((c) => c.id == id);
                }),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _symptoms,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'What is wrong?',
              hintText: 'For example: not eating, limping, swollen udder...',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _duration,
            decoration: const InputDecoration(
              labelText: 'For how long? (optional)',
              hintText: 'For example: 2 days',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<VetLanguage>(
            segments: const [
              ButtonSegment(value: VetLanguage.english, label: Text('English')),
              ButtonSegment(
                value: VetLanguage.swahili,
                label: Text('Kiswahili'),
              ),
            ],
            selected: {_language},
            onSelectionChanged: (s) => setState(() => _language = s.first),
          ),
          if (flags.isNotEmpty && _assessment == null) ...[
            const SizedBox(height: 16),
            _DangerBanner(flags: flags),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _canAsk ? _assess : null,
            icon: _loading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.medical_services),
            label: Text(_loading ? 'Checking...' : 'Check symptoms'),
          ),
          if (_failure != null) ...[
            const SizedBox(height: 16),
            Text(
              _failure!.message,
              style: TextStyle(color: context.farm.warning),
            ),
          ],
          if (_assessment != null) ...[
            const SizedBox(height: 16),
            _AssessmentCard(assessment: _assessment!),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saved ? null : _save,
              icon: Icon(_saved ? Icons.check : Icons.save_alt),
              label: Text(
                _saved ? 'Saved to health records' : 'Save to health records',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DangerBanner extends StatelessWidget {
  final List<String> flags;

  const _DangerBanner({required this.flags});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.farm.danger.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.farm.danger),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: context.farm.danger),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Danger sign: ${flags.join(', ')}. Call a vet or your animal '
              "health officer now. Don't wait for the app.",
              style: const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final VetAssessment assessment;

  const _AssessmentCard({required this.assessment});

  (Color, IconData, String) _style(BuildContext context) => switch (assessment.urgency) {
    VetUrgency.emergency => (
      context.farm.danger,
      Icons.warning_amber_rounded,
      'Call a vet now',
    ),
    VetUrgency.seeVetSoon => (
      context.farm.warning,
      Icons.local_hospital,
      'A vet should see her soon',
    ),
    VetUrgency.monitorAtHome => (
      context.farm.good,
      Icons.visibility,
      'Monitor her at home',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (color, icon, title) = _style(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (assessment.summary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              assessment.summary,
              style: const TextStyle(),
            ),
          ],
          if (assessment.redFlags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Danger signs noticed: ${assessment.redFlags.join(', ')}',
              style: TextStyle(color: context.farm.danger),
            ),
          ],
          _Section('Possible causes', assessment.possibleCauses),
          _Section('What to do now', assessment.whatToDoNow),
          _Section('Call a vet if', assessment.callVetIf),
          if (assessment.milkAdvice.isNotEmpty)
            _Section('Milk', [assessment.milkAdvice]),
          const SizedBox(height: 16),
          Text(
            'This is guidance, not a diagnosis. If you are worried, contact '
            'a vet or your animal health officer.',
            style: TextStyle(color: context.farm.muted, fontSize: 12),
          ),
        ],
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
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '• $item',
                style: TextStyle(color: context.farm.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
