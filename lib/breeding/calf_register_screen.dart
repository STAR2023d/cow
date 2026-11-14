import 'package:cow/utils/format.dart';
import 'package:cow/breeding/breeding_screen.dart';
import 'package:cow/breeding/calf_dialogs.dart';
import 'package:cow/breeding/calf_register.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' show Value;
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Every calf: those recorded through breeding cycles plus calves added by
/// hand (bought in, or born before the app was used).
class CalfRegisterScreen extends StatefulWidget {
  final AppDatabase? db;

  /// Test hooks; default to the database streams.
  final Stream<List<CowData>>? cows;
  final Stream<List<BreedingCycle>>? cycles;
  final Stream<List<Calf>>? calves;

  const CalfRegisterScreen({
    super.key,
    this.db,
    this.cows,
    this.cycles,
    this.calves,
  });

  @override
  State<CalfRegisterScreen> createState() => _CalfRegisterScreenState();
}

class _CalfRegisterScreenState extends State<CalfRegisterScreen> {
  late final _cows = widget.cows ?? widget.db!.watchAllCow();
  late final _cycles = widget.cycles ?? widget.db!.watchCalvings();
  late final _calves =
      widget.calves ??
      widget.db?.watchCalves() ??
      Stream<List<Calf>>.value(const []);

  List<CowData> _latestCows = const [];

  Future<void> _addCalf() async {
    final db = widget.db;
    if (db == null) return;
    final row = await showDialog<CalvesCompanion>(
      context: context,
      builder: (_) => AddCalfDialog(cows: _latestCows),
    );
    if (row != null) await db.insertCalf(row);
  }

  Future<void> _editCalf(CalfEntry calf, String title) async {
    final db = widget.db;
    if (db == null) return;
    final result = await showDialog<CalfDetailsResult>(
      context: context,
      builder: (_) => CalfDetailsDialog(calf: calf, title: title),
    );
    switch (result) {
      case null:
        return;
      case DeleteCalf():
        final row = calf.details!;
        if (!mounted) return;
        await deleteWithUndo(
          context,
          what: 'Calf details',
          delete: () => db.deleteCalf(row.id),
          restore: () => db.restoreCalf(row),
        );
      case OpenBreedingRecord():
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BreedingScreen(cowId: calf.cycle!.cowId, cowName: calf.damName),
          ),
        );
      case SaveCalfDetails(:final birthWeightKg, :final weanedOn, :final notes):
        final details = calf.details;
        if (details != null) {
          await db.updateCalf(
            details.id,
            CalvesCompanion(
              birthWeightKg: Value(birthWeightKg),
              weanedOn: Value(weanedOn),
              notes: Value(notes),
            ),
          );
        } else {
          // First edit of a cycle calf: create its row, linked to the cycle.
          final cycle = calf.cycle!;
          await db.insertCalf(
            CalvesCompanion.insert(
              breedingCycleId: Value(cycle.id),
              dateOfBirth: calf.bornOn,
              sex: cycle.calfSex ?? 'unknown',
              damCowId: Value(cycle.cowId),
              birthWeightKg: Value(birthWeightKg),
              weanedOn: Value(weanedOn),
              notes: Value(notes),
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calf Register')),
      floatingActionButton: widget.db == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _addCalf,
              icon: const Icon(Icons.add),
              label: const Text('Add calf'),
            ),
      body: StreamBuilder<List<CowData>>(
        stream: _cows,
        builder: (context, cowSnap) => StreamBuilder<List<BreedingCycle>>(
          stream: _cycles,
          builder: (context, cycleSnap) => StreamBuilder<List<Calf>>(
            stream: _calves,
            builder: (context, calfSnap) {
              if (!cowSnap.hasData || !cycleSnap.hasData || !calfSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              _latestCows = cowSnap.data!;
              final calves = buildCalfRegister(
                cowSnap.data!,
                cycleSnap.data!,
                calfSnap.data!,
              );
              if (calves.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No calves yet. Calves appear here once a calving is '
                      'recorded on a cow\'s breeding screen, or tap Add calf '
                      'for one bought in or born before you used the app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.farm.muted),
                    ),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                children: [
                  _Summary(calves: calves),
                  const SizedBox(height: 12),
                  for (final c in calves)
                    _CalfTile(
                      calf: c,
                      onTap: widget.db == null
                          ? null
                          : () => _editCalf(c, _CalfTile.titleOf(c)),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final List<CalfEntry> calves;

  const _Summary({required this.calves});

  @override
  Widget build(BuildContext context) {
    int count(CalfOutcome o) => calves.where((c) => c.outcome == o).length;
    final awaiting = count(CalfOutcome.awaiting);
    final onFarm = count(CalfOutcome.onFarm);
    return Text(
      '${calves.length} calves · ${count(CalfOutcome.kept)} kept · '
      '${count(CalfOutcome.sold)} sold'
      '${awaiting > 0 ? ' · $awaiting awaiting outcome' : ''}'
      '${onFarm > 0 ? ' · $onFarm added by hand' : ''}',
      style: TextStyle(color: context.farm.muted, fontSize: 14),
    );
  }
}

class _CalfTile extends StatelessWidget {
  final CalfEntry calf;
  final VoidCallback? onTap;

  const _CalfTile({required this.calf, this.onTap});

  static final _kg = NumberFormat('#,##0.#');

  static String titleOf(CalfEntry c) =>
      c.calfName ??
      (c.damName == 'Unknown dam' ? 'Unnamed calf' : 'Calf of ${c.damName}');

  (String, Color, IconData) _outcome(BuildContext context) =>
      switch (calf.outcome) {
        CalfOutcome.kept => ('Kept', context.farm.good, Icons.pets),
        CalfOutcome.sold => (
          calf.cycle!.saleAmount == null
              ? 'Sold'
              : 'Sold · ${ksh(calf.cycle!.saleAmount!)}',
          context.farm.info,
          Icons.sell_outlined,
        ),
        CalfOutcome.awaiting => (
          'Awaiting outcome',
          context.farm.warning,
          Icons.hourglass_empty,
        ),
        CalfOutcome.onFarm => (
          calf.boughtIn ? 'Bought in' : 'On farm',
          context.farm.muted,
          Icons.child_friendly,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _outcome(context);
    final sex = switch (calf.sex) {
      'female' => 'Female',
      'male' => 'Male',
      _ => 'Sex not recorded',
    };
    final weight = calf.birthWeightKg;
    final weaned = calf.weanedOn;
    final sub = [
      [
        if (calf.calfName != null) 'Dam: ${calf.damName}',
        'Born ${shortDate(calf.bornOn)} (${calf.ageOn(DateTime.now())})',
        sex,
      ].join(' · '),
      if (weight != null || weaned != null)
        [
          if (weight != null) '${_kg.format(weight)} kg at birth',
          if (weaned != null) 'Weaned on ${shortDate(weaned)}',
        ].join(' · '),
    ].join('\n');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(titleOf(calf), style: const TextStyle()),
        subtitle: Text(sub, style: TextStyle(color: context.farm.muted)),
        isThreeLine: weight != null || weaned != null,
        trailing: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
