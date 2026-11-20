import 'package:cow/database/app_database.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/models/herd_milk.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Everything the form needs for one day and session.
class _FormData {
  /// Cows shown on the form: those on the milking list (or the one cow),
  /// plus any that already have milk saved for this day and session.
  final List<CowData> cows;

  /// Every cow still in the herd, for editing the milking list.
  final List<CowData> herd;

  /// Litres already saved for this day and session, by cow.
  final Map<int, double> saved;

  /// Average litres for this session over the 7 days before, by cow.
  final Map<int, double> usual;

  /// Cows whose milk is on hold that day, with the day it is safe again.
  final Map<int, DateTime> holds;

  /// Milk price per litre on this day, from the price setting.
  final double price;

  /// Buyers used before, newest first.
  final List<String> buyers;

  const _FormData(
    this.cows,
    this.herd,
    this.saved,
    this.usual,
    this.holds,
    this.price,
    this.buyers,
  );

  /// Herd cows not on the milking list and not already on the form.
  List<CowData> get offList => [
    for (final c in herd)
      if (!c.inMilk && !cows.any((s) => s.id == c.id)) c,
  ];
}

/// The milk form used everywhere milk is logged. Pick the day and session,
/// type each cow's litres (or tap her usual figure), save once.
///
/// With [cowId] it shows that one cow (the cow's own milk screen) and has
/// no height of its own, so it can sit in a scroll view. Without it, it
/// shows the milking list and fills the space it is given.
class MilkLogForm extends StatefulWidget {
  final AppDatabase db;

  /// One cow only, or null for the whole milking list.
  final int? cowId;

  /// Called after a save with the number of cows, the session and litres.
  final void Function(int cows, String session, double litres) onSaved;

  /// The current time; replaced in tests.
  final DateTime Function() clock;

  const MilkLogForm({
    super.key,
    required this.db,
    required this.onSaved,
    this.cowId,
    this.clock = _now,
  });

  static DateTime _now() => DateTime.now();

  @override
  State<MilkLogForm> createState() => _MilkLogFormState();
}

class _MilkLogFormState extends State<MilkLogForm> {
  static final _litresFmt = NumberFormat('0.##');

  late DateTime _day;
  late String _session;
  late Future<_FormData> _future;
  final _buyer = TextEditingController();
  final _boxes = <int, TextEditingController>{};
  final _errors = <int, String>{};
  bool _saving = false;

  bool get _single => widget.cowId != null;
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

  /// Loads the form. [keep] holds litres already typed, by cow, so
  /// editing the milking list does not wipe them.
  Future<_FormData> _load({Map<int, String> keep = const {}}) async {
    final db = widget.db;
    final dayEnd = _day.add(const Duration(days: 1, seconds: -1));
    final all = await db.allCows();
    final herd = [
      for (final c in all)
        if (c.leftOn == null) c,
    ];
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
    final cows = [
      for (final cow in all)
        if (_single
            ? cow.id == widget.cowId
            : (cow.inMilk && cow.leftOn == null) || saved.containsKey(cow.id))
          cow,
    ];
    for (final c in _boxes.values) {
      c.dispose();
    }
    _boxes
      ..clear()
      ..addAll({
        for (final cow in cows)
          cow.id: TextEditingController(
            text:
                keep[cow.id] ??
                (saved[cow.id] == null ? '' : _litresFmt.format(saved[cow.id])),
          ),
      });
    _errors.clear();

    final price = await db.priceForDate(
      entryTimeFor(_day, _session, widget.clock()),
    );
    final buyers = await db.recentBuyers();

    return _FormData(
      cows,
      herd,
      saved,
      usualYields(before, _session),
      {
        for (final h in activeHolds(records, noon))
          h.cowId: h.withdrawal.safeFrom,
      },
      price,
      buyers,
    );
  }

  void _reload({DateTime? day, String? session}) {
    setState(() {
      _day = day ?? _day;
      _session = session ?? _session;
      _future = _load();
    });
  }

  /// Litres typed so far, by cow.
  Map<int, String> get _typedText => {
    for (final e in _boxes.entries)
      if (e.value.text.trim().isNotEmpty) e.key: e.value.text,
  };

  Future<void> _setInMilk(CowData cow, bool inMilk, {bool undo = true}) async {
    final keep = _typedText;
    if (!inMilk && !_single) keep.remove(cow.id);
    await widget.db.setInMilk(cow.id, inMilk);
    if (!mounted) return;
    setState(() {
      _future = _load(keep: keep);
    });
    if (!inMilk && undo && !_single) {
      final l10n = context.l10n;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.removedFromMilkingList(cow.name)),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => _setInMilk(cow, true),
            ),
          ),
        );
    }
  }

  /// Lets the farmer tick which cows are being milked.
  Future<void> _editMilkingList(List<CowData> herd) async {
    final picked = {
      for (final cow in herd)
        if (cow.inMilk) cow.id,
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(context.l10n.milkingList),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.milkingListHelp),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final cow in herd)
                        CheckboxListTile(
                          key: ValueKey('in-milk-${cow.id}'),
                          title: Text(_cowLabel(cow)),
                          value: picked.contains(cow.id),
                          onChanged: (v) => setDialog(
                            () => v == true
                                ? picked.add(cow.id)
                                : picked.remove(cow.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.save),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final keep = _typedText;
    for (final cow in herd) {
      final want = picked.contains(cow.id);
      if (want != cow.inMilk) await widget.db.setInMilk(cow.id, want);
    }
    if (!mounted) return;
    setState(() {
      _future = _load(keep: keep);
    });
  }

  static String _cowLabel(CowData cow) => cow.tag == null || cow.tag!.isEmpty
      ? cow.name
      : '${cow.name} (${cow.tag})';

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

  Future<void> _save(_FormData data) async {
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
    setState(() {
      _saving = false;
      if (_single) _future = _load();
    });
    widget.onSaved(values.length, _session, total);
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
    return FutureBuilder<_FormData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(context.l10n.couldNotLoadHerd));
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _body(snapshot.data!);
      },
    );
  }

  Widget _message(String text, {Widget? action}) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 16), action],
        ],
      ),
    ),
  );

  Widget _body(_FormData data) {
    final l = context.l10n;
    if (!_single && data.herd.isEmpty) return _message(l.noCowsAddFirst);
    if (!_single && data.cows.isEmpty) {
      return _message(
        l.noCowsInMilk,
        action: FilledButton.icon(
          onPressed: () => _editMilkingList(data.herd),
          icon: const Icon(Icons.playlist_add),
          label: Text(l.addCowsToMilkingList),
        ),
      );
    }

    final controls = [_whenPicker(), _sessionPicker(), _buyerField(data)];
    final saveButton = _saveButton(data);

    if (_single) {
      final cow = data.cows.single;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...controls,
          _cowRow(data, cow, last: true),
          if (cow.leftOn == null)
            SwitchListTile(
              key: const ValueKey('on-milking-list'),
              title: Text(l.onMilkingList),
              subtitle: Text(l.onMilkingListHelp),
              value: cow.inMilk,
              onChanged: (v) => _setInMilk(cow, v),
            ),
          saveButton,
        ],
      );
    }

    final offList = data.offList;
    return Column(
      children: [
        ...controls,
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              for (var i = 0; i < data.cows.length; i++) ...[
                _cowRow(data, data.cows[i], last: i == data.cows.length - 1),
                const Divider(height: 1),
              ],
              if (offList.isNotEmpty)
                ExpansionTile(
                  key: const ValueKey('off-list'),
                  leading: const Icon(Icons.playlist_add),
                  title: Text(l.notOnMilkingList(offList.length)),
                  children: [
                    for (final cow in offList)
                      ListTile(
                        title: Text(_cowLabel(cow)),
                        trailing: FilledButton.tonalIcon(
                          key: ValueKey('add-${cow.id}'),
                          onPressed: () => _setInMilk(cow, true),
                          icon: const Icon(Icons.add),
                          label: Text(l.add),
                        ),
                      ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: () => _editMilkingList(data.herd),
                    icon: const Icon(Icons.playlist_add_check),
                    label: Text(l.milkingList),
                  ),
                ),
              ),
            ],
          ),
        ),
        saveButton,
      ],
    );
  }

  Widget _whenPicker() {
    final l = context.l10n;
    final yesterday = _today.subtract(const Duration(days: 1));
    final otherDay = _day != _today && _day != yesterday;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ChoiceChip(
            label: Text(l.today),
            selected: _day == _today,
            onSelected: (_) => _reload(day: _today),
          ),
          ChoiceChip(
            label: Text(l.yesterday),
            selected: _day == yesterday,
            onSelected: (_) => _reload(day: yesterday),
          ),
          ChoiceChip(
            avatar: const Icon(Icons.calendar_today, size: 18),
            label: Text(otherDay ? shortDate(_day) : l.otherDay),
            selected: otherDay,
            onSelected: (_) => _pickDate(),
          ),
        ],
      ),
    );
  }

  static IconData _sessionIcon(String s) => switch (s) {
    MilkSession.morning => Icons.wb_twilight,
    MilkSession.afternoon => Icons.wb_sunny,
    _ => Icons.dark_mode_outlined,
  };

  Widget _sessionPicker() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          for (final s in MilkSession.all)
            ButtonSegment(
              value: s,
              icon: Icon(_sessionIcon(s)),
              label: Text(sessionLabel(context.l10n, s)),
            ),
        ],
        selected: {_session},
        onSelectionChanged: (s) => _reload(session: s.first),
      ),
    ),
  );

  Widget _buyerField(_FormData data) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _buyer,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: _single ? l.buyerOptional : l.buyerForAll,
              prefixIcon: const Icon(Icons.storefront_outlined),
              isDense: true,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (data.buyers.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final b in data.buyers)
                  ChoiceChip(
                    label: Text(b),
                    tooltip: l.recentBuyers,
                    selected: _buyer.text.trim() == b,
                    onSelected: (on) =>
                        setState(() => _buyer.text = on ? b : ''),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _saveButton(_FormData data) {
    final l = context.l10n;
    final (count, total) = _typed;
    return SafeArea(
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
                  ? l.save
                  : l.saveCowsLitres(
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
    );
  }

  /// Checks a box as the farmer types: an error for text that is not a
  /// number, a gentle warning for a figure far above her usual.
  void _onTyped(int cowId, String text) {
    setState(() {
      final v = parseLitres(text);
      if (v != null && v.isNaN) {
        _errors[cowId] = context.l10n.enterNumberAboveZero;
      } else {
        _errors.remove(cowId);
      }
    });
  }

  Widget _cowRow(_FormData data, CowData cow, {required bool last}) {
    final l = context.l10n;
    final usual = data.usual[cow.id];
    final hold = data.holds[cow.id];
    final saved = data.saved[cow.id];
    final box = _boxes[cow.id]!;
    final typed = parseLitres(box.text);
    final unusual =
        typed != null && !typed.isNaN && isUnusualYield(typed, usual);

    return ListTile(
      contentPadding: EdgeInsetsDirectional.only(
        start: _single ? 16 : 4,
        end: 16,
        top: 4,
        bottom: 4,
      ),
      leading: _single
          ? null
          : cow.inMilk
          ? IconButton(
              key: ValueKey('remove-${cow.id}'),
              tooltip: l.removeFromMilkingList,
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => _setInMilk(cow, false),
            )
          : const SizedBox(width: 48),
      title: Text(
        _cowLabel(cow),
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (usual == null)
            Text(l.noSessionMilkLast7(sessionLabel(l, _session)))
          else
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ActionChip(
                key: ValueKey('usual-${cow.id}'),
                avatar: const Icon(Icons.touch_app_outlined, size: 18),
                label: Text(l.usuallyAbout(litres(usual))),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  box.text = _litresFmt.format(usual);
                  _onTyped(cow.id, box.text);
                },
              ),
            ),
          if (saved != null)
            Text(
              l.savedLitres(litres(saved)),
              style: TextStyle(color: context.farm.good),
            ),
          // The cow's own screen shows the hold banner above the form.
          if (hold != null && !_single)
            Text(
              l.milkOnHoldUntil(shortDate(hold)),
              style: TextStyle(color: context.farm.warning),
            ),
        ],
      ),
      trailing: SizedBox(
        width: 120,
        child: TextField(
          key: ValueKey('litres-${cow.id}'),
          controller: box,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: last ? TextInputAction.done : TextInputAction.next,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: '0',
            suffixText: 'L',
            isDense: true,
            border: const OutlineInputBorder(),
            errorText: _errors[cow.id],
            errorMaxLines: 2,
            helperText: unusual ? l.checkFigureHint : null,
            helperMaxLines: 2,
            helperStyle: TextStyle(color: context.farm.warning),
          ),
          onChanged: (t) => _onTyped(cow.id, t),
        ),
      ),
    );
  }
}
