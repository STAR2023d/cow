import 'package:cow/abstract/dialog_deletion.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// Cows that were sold, died, culled or given away. Their records stay;
/// a cow can be brought back to the herd from here.
class LeftHerdScreen extends StatelessWidget {
  final AppDatabase db;

  const LeftHerdScreen({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.leftTheHerd)),
      body: StreamBuilder<List<CowData>>(
        stream: db.watchLeftCows(),
        builder: (context, snapshot) {
          final cows = snapshot.data;
          if (cows == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (cows.isEmpty) {
            return Center(
              child: Text(
                l.noCowsLeft,
                style: TextStyle(color: context.farm.muted),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final cow in cows)
                Card(
                  child: ListTile(
                    title: Text(cow.name),
                    subtitle: Text(
                      '${cowLeftReasonLabel(context, cow.leftReason)}'
                      ' · ${shortDate(cow.leftOn!)}',
                    ),
                    trailing: TextButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final msg = l.cowReturned(cow.name);
                        await db.returnToHerd(cow.id);
                        messenger.showSnackBar(SnackBar(content: Text(msg)));
                      },
                      child: Text(l.returnToHerd),
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
