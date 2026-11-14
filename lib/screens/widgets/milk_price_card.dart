import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_price.dart';
import 'package:cow/screens/milk_price_screen.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// Dashboard line showing the milk price, or asking for it until the
/// farmer has set one (until then earnings use a built-in KSh 50).
class MilkPriceCard extends StatefulWidget {
  final AppDatabase db;

  /// Replaced in tests; reads the saved flag by default.
  final Future<bool> Function() isSet;

  /// Price history; injected in tests, read from [db] by default.
  final Stream<List<PriceSetting>>? history;

  const MilkPriceCard({
    super.key,
    required this.db,
    this.isSet = MilkPriceFlag.isSet,
    this.history,
  });

  @override
  State<MilkPriceCard> createState() => _MilkPriceCardState();
}

class _MilkPriceCardState extends State<MilkPriceCard> {
  late Future<bool> _isSet = widget.isSet();
  late final Stream<List<PriceSetting>> _history =
      widget.history ?? widget.db.watchPriceHistory();

  Future<void> _open() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MilkPriceScreen(db: widget.db)),
    );
    if (mounted) setState(() => _isSet = widget.isSet());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isSet,
      builder: (context, flag) => StreamBuilder<List<PriceSetting>>(
        stream: _history,
        builder: (context, snapshot) {
          if (!flag.hasData || !snapshot.hasData) return const SizedBox();
          final history = snapshot.data!;
          final current = currentPrice(history, DateTime.now());
          final known = flag.data! || history.length > 1;

          if (!known) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.farm.warning, width: 1.5),
              ),
              child: ListTile(
                leading: Icon(Icons.sell, color: context.farm.warning),
                title: const Text('Set your milk price'),
                subtitle: const Text(
                  'Earnings use KSh 50 per litre until you set what your '
                  'buyer pays.',
                ),
                trailing: FilledButton(
                  onPressed: _open,
                  child: const Text('Set'),
                ),
              ),
            );
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Icon(Icons.sell, color: context.farm.good),
              title: Text(
                current == null
                    ? 'Milk price'
                    : 'Milk price: ${ksh(current.pricePerLitre, cents: current.pricePerLitre % 1 != 0)} per litre',
              ),
              subtitle: current == null
                  ? null
                  : Text('since ${shortDate(current.effectiveDate)}'),
              trailing: TextButton(
                onPressed: _open,
                child: const Text('Change'),
              ),
              onTap: _open,
            ),
          );
        },
      ),
    );
  }
}
