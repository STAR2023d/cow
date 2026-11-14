import 'package:cow/l10n/language_controller.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_price.dart';
import 'package:cow/screens/widgets/set_price_dialog.dart';
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// The milk price per litre and its history. The price is a setting:
/// milk entries never store it; reports look up the price for each day.
class MilkPriceScreen extends StatelessWidget {
  final AppDatabase db;

  const MilkPriceScreen({super.key, required this.db});

  Future<void> _change(BuildContext context, double? current) async {
    final saved = await changeMilkPrice(
      context,
      current: current,
      save: (price, from) async {
        await db.setPricePerLitre(price, effectiveDate: from);
        await MilkPriceFlag.markSet();
      },
    );
    if (saved && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.priceSaved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.milkPrice)),
      body: StreamBuilder<List<PriceSetting>>(
        stream: db.watchPriceHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final history = snapshot.data!;
          final now = DateTime.now();
          final current = currentPrice(history, now);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current == null
                            ? context.l10n.noPriceYet
                            : context.l10n.perLitre(
                                ksh(
                                  current.pricePerLitre,
                                  cents: current.pricePerLitre % 1 != 0,
                                ),
                              ),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (current != null)
                        Text(
                          context.l10n.since(shortDate(current.effectiveDate)),
                          style: TextStyle(color: context.farm.muted),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.edit),
                          label: Text(context.l10n.changePrice),
                          onPressed: () =>
                              _change(context, current?.pricePerLitre),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.priceExplain,
                style: TextStyle(color: context.farm.muted),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.priceHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final p in history)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    ksh(p.pricePerLitre, cents: p.pricePerLitre % 1 != 0),
                  ),
                  subtitle: Text(
                    p.effectiveDate.isAfter(now)
                        ? context.l10n.fromDateUpcoming(
                            shortDate(p.effectiveDate),
                          )
                        : context.l10n.fromDate(shortDate(p.effectiveDate)),
                  ),
                  // Keep at least one price, or earnings would have none.
                  trailing: history.length < 2
                      ? null
                      : IconButton(
                          tooltip: context.l10n.delete,
                          icon: Icon(
                            Icons.delete_outline,
                            color: context.farm.danger,
                          ),
                          onPressed: () => deleteWithUndo(
                            context,
                            what: context.l10n.priceWhat,
                            delete: () => db.deletePrice(p.id),
                            restore: () => db.restorePrice(p),
                          ),
                        ),
                ),
            ],
          );
        },
      ),
    );
  }
}
