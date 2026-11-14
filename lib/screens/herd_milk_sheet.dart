import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:cow/models/herd_milk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Everything the sheet needs for one day and session.
class _SheetData {
  final List<CowData> cows;

  /// Litres already saved for this day and session, by cow.
  final Map<int, double> saved;

  /// Average litres for this session over the 7 days before, by cow.
  final Map<int, double> usual;

  /// Cows whose milk is on hold that day, with the day it is safe again.
  final Map<int, DateTime> holds;

  /// Milk price per litre on this day, from the price setting.
  final double price;

  const _SheetData(this.cows, this.saved, this.usual, this.holds, this.price);
}

/// Log one milking for the whole herd on one screen: pick the day and
/// session once, type each cow's litres, save once.
class HerdMilkSheet extends StatefulWidget {
  final AppDatabase db;

  /// The current time; replaced in tests.
  final DateTime Function() clock;

  const HerdMilkSheet({super.key, required this.db, this.clock = _now});

  static DateTime _now() => DateTime.now();

  @override
  State<HerdMilkSheet> createState() => _HerdMilkSheetState();
}

class _HerdMilkSheetState extends State<HerdMilkSheet> {
  static final _litresFmt = NumberFormat('0.##');

  late DateTime _day;
  late String _session;
  late Future<_SheetData> _future;
  final _buyer = TextEditingController();
  final _boxes = <int, TextEditingController>{};
  final _errors = <int, String>{};
  bool _saving = false;

  DateTime get _today => dayOf(widget.clock());

  @override
  void initState() {
    super.initState();
    _day = _today;
    _session = defaultSessionFor(widget.clock());
    _future = _load();
  }

  @override
  void dispose() {
    _buyer.dispose();
    for (final c in _boxes.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<_SheetData> _load() async {
    final db = widget.db;
    final dayEnd = _day.add(const Duration(days: 1, seconds: -1));
    final cows = await db.watchAllCow().first;
    final today = await db.milkEntriesInRange(_day, dayEnd);
    final before = await db.milkEntriesInRange(
      _day.subtract(const Duration(days: 7)),
      _day.subtract(const Duration(seconds: 1)),
    );
    final records = await db.watchWithdrawalRecords().first;
    final noon = _day.add(const Duration(hours: 12));

    final saved = {
      for (final e in today)
        if (e.session == _session) e.cowId: e.amount,
    };
    for (final c in _boxes.values) {
      c.dispose();
    }
    _boxes
      ..clear()
      ..addAll({
        for (final cow in cows)
          cow.id: TextEditingController(
            text: saved[cow.id] == null ? '' : _litresFmt.format(saved[cow.id]),
          ),
      });
    _errors.clear();

    final price = await db.priceForDate(
      entryTimeFor(_day, _session, widget.clock()),
    );

    return _SheetData(cows, saved, usualYields(before, _session), {
      for (final h in activeHolds(records, noon))
        h.cowId: h.withdrawal.safeFrom,
    }, price);
  }

  void _reload({DateTime? day, String? session}) {
    setState(() {
      _day = day ?? _day;
      _session = session ?? _session;
      _future = _load();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: _today.subtract(const Duration(days: 365)),
      lastDate: _today,
    );
    if (picked != null) _reload(day: dayOf(picked));
  }

  /// Litres typed so far: number of cows and total.
  (int, double) get _typed {
    var n = 0;
    var total = 0.0;
    for (final c in _boxes.values) {
      final v = parseLitres(c.text);
      if (v != null && !v.isNaN) {
        n++;
        total += v;
      }
    }
    return (n, total);
  }

  Future<void> _save(_SheetData data) async {
    final values = <int, double>{};
    final unusual = <String>[];
    _errors.clear();
    for (final cow in data.cows) {
      final v = parseLitres(_boxes[cow.id]!.text);
      if (v == null) continue;
      if (v.isNaN) {
        _errors[cow.id] = context.l10n.enterNumberAboveZero;
        continue;
      }
      values[cow.id] = v;
      if (isUnusualYield(v, data.usual[cow.id])) {
        final usual = data.usual[cow.id];
        unusual.add(
          usual == null
              ? '${cow.name}: ${litres(v)}'
              : context.l10n.unusualUsual(cow.name, litres(v), litres(usual)),
        );
      }
    }
    if (_errors.isNotEmpty) {
      setState(() {});
      return;
    }
    if (values.isEmpty) {
      _snack(context.l10n.typeLitresAtLeastOne);
      return;
    }
    if (unusual.isNotEmpty && !await _confirmUnusual(unusual)) return;

    setState(() => _saving = true);
    final when = entryTimeFor(_day, _session, widget.clock());
    for (final e in values.entries) {
      await widget.db.upsertMilkEntry(
        cowId: e.key,
        date: when,
        session: _session,
        amount: e.value,
        buyer: _buyer.text,
      );
    }
    if (!mounted) return;
    final total = values.values.fold<double>(0, (a, b) => a + b);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.savedSessionMilk(
            values.length,
            sessionLabel(l10n, _session),
            litres(total),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmUnusual(List<String> lines) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.checkFiguresTitle),
        content: Text(context.l10n.checkFiguresBody(lines.join('\n'))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.goBackFix),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.saveAnyway),
          ),
        ],
      ),
    );
    return ok == true;
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final yesterday = _today.subtract(const Duration(days: 1));
    final otherDay = _day != _today && _day != yesterday;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.logMilk)),
      body: FutureBuilder<_SheetData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(context.l10n.couldNotLoadHerd));
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          if (data.cows.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  context.l10n.noCowsAddFirst,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final (count, total) = _typed;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text(context.l10n.today),
                      selected: _day == _today,
                      onSelected: (_) => _reload(day: _today),
                    ),
                    ChoiceChip(
                      label: Text(context.l10n.yesterday),
                      selected: _day == yesterday,
                      onSelected: (_) => _reload(day: yesterday),
                    ),
                    ChoiceChip(
                      avatar: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        otherDay ? shortDate(_day) : context.l10n.otherDay,
                      ),
                      selected: otherDay,
                      onSelected: (_) => _pickDate(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: [
                      for (final s in MilkSession.all)
                        ButtonSegment(
                          value: s,
                          label: Text(sessionLabel(context.l10n, s)),
                        ),
                    ],
                    selected: {_session},
                    onSelectionChanged: (s) => _reload(session: s.first),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  controller: _buyer,
                  decoration: InputDecoration(
                    labelText: context.l10n.buyerForAll,
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: data.cows.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => _cowRow(
                    data,
                    data.cows[i],
                    last: i == data.cows.length - 1,
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(
                        count == 0
                            ? context.l10n.save
                            : context.l10n.saveCowsLitres(
                                count,
                                litres(total),
                                ksh(total * data.price),
                              ),
                        style: const TextStyle(fontSize: 16),
                      ),
                      onPressed: _saving ? null : () => _save(data),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cowRow(_SheetData data, CowData cow, {required bool last}) {
    final usual = data.usual[cow.id];
    final hold = data.holds[cow.id];
    final saved = data.saved[cow.id];
    final notes = <String>[
      usual == null
          ? context.l10n.noSessionMilkLast7(
              sessionLabel(context.l10n, _session),
            )
          : context.l10n.usuallyAbout(litres(usual)),
      if (saved != null) context.l10n.savedLitres(litres(saved)),
    ];

    return ListTile(
      title: Text(
        cow.tag == null || cow.tag!.isEmpty
            ? cow.name
            : '${cow.name} (${cow.tag})',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notes.join(' • ')),
          if (hold != null)
            Text(
              context.l10n.milkOnHoldUntil(shortDate(hold)),
              style: TextStyle(color: context.farm.warning),
            ),
        ],
      ),
      trailing: SizedBox(
        width: 110,
        child: TextField(
          key: ValueKey('litres-${cow.id}'),
          controller: _boxes[cow.id],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: last ? TextInputAction.done : TextInputAction.next,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            suffixText: 'L',
            isDense: true,
            border: const OutlineInputBorder(),
            errorText: _errors[cow.id],
            errorMaxLines: 2,
          ),
          onChanged: (_) => setState(() => _errors.remove(cow.id)),
        ),
      ),
    );
  }
}
