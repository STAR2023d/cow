import 'package:cow/breeding/breeding_screen.dart';
import 'package:cow/breeding/calf_register.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Read-only list of every calf recorded through breeding cycles.
class CalfRegisterScreen extends StatefulWidget {
  final AppDatabase? db;

  /// Test hooks; default to the database streams.
  final Stream<List<CowData>>? cows;
  final Stream<List<BreedingCycle>>? cycles;

  const CalfRegisterScreen({super.key, this.db, this.cows, this.cycles});

  @override
  State<CalfRegisterScreen> createState() => _CalfRegisterScreenState();
}

class _CalfRegisterScreenState extends State<CalfRegisterScreen> {
  late final _cows = widget.cows ?? widget.db!.watchAllCow();
  late final _cycles = widget.cycles ?? widget.db!.watchCalvings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Calf Register')),
      body: StreamBuilder<List<CowData>>(
        stream: _cows,
        builder: (context, cowSnap) => StreamBuilder<List<BreedingCycle>>(
          stream: _cycles,
          builder: (context, cycleSnap) {
            if (!cowSnap.hasData || !cycleSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final calves = buildCalfRegister(cowSnap.data!, cycleSnap.data!);
            if (calves.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No calves yet. Calves appear here once a calving is '
                    'recorded on a cow\'s breeding screen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Summary(calves: calves),
                const SizedBox(height: 12),
                for (final c in calves) _CalfTile(calf: c, db: widget.db),
              ],
            );
          },
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
    return Text(
      '${calves.length} calves · ${count(CalfOutcome.kept)} kept · '
      '${count(CalfOutcome.sold)} sold'
      '${awaiting > 0 ? ' · $awaiting awaiting outcome' : ''}',
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}

class _CalfTile extends StatelessWidget {
  final CalfEntry calf;
  final AppDatabase? db;

  const _CalfTile({required this.calf, this.db});

  static final _date = DateFormat('EEE d MMM yyyy');
  static final _money = NumberFormat('#,##0');

  (String, Color, IconData) get _outcome => switch (calf.outcome) {
    CalfOutcome.kept => ('Kept', Colors.greenAccent, Icons.pets),
    CalfOutcome.sold => (
      calf.cycle.saleAmount == null
          ? 'Sold'
          : 'Sold · ${_money.format(calf.cycle.saleAmount)}',
      Colors.lightBlueAccent,
      Icons.sell_outlined,
    ),
    CalfOutcome.awaiting => (
      'Awaiting outcome',
      Colors.orange,
      Icons.hourglass_empty,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _outcome;
    final sex = switch (calf.sex) {
      'female' => 'Female',
      'male' => 'Male',
      _ => 'Sex not recorded',
    };
    final title = calf.calfName ?? 'Calf of ${calf.damName}';
    final sub = [
      if (calf.calfName != null) 'Dam: ${calf.damName}',
      'Born ${_date.format(calf.bornOn)} (${calf.ageOn(DateTime.now())})',
      sex,
    ].join(' · ');

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white54)),
        trailing: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        // Opens the dam's breeding screen, where the outcome is recorded.
        onTap: db == null
            ? null
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BreedingScreen(
                    cowId: calf.cycle.cowId,
                    cowName: calf.damName,
                  ),
                ),
              ),
      ),
    );
  }
}
