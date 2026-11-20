import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/screens/widgets/milk_log_form.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// Log one milking for the whole herd on one screen: pick the day and
/// session once, type each cow's litres, save once. The form itself is
/// [MilkLogForm], shared with the cow's own milk screen.
class HerdMilkSheet extends StatelessWidget {
  final AppDatabase db;

  /// The current time; replaced in tests.
  final DateTime Function() clock;

  const HerdMilkSheet({super.key, required this.db, this.clock = _now});

  static DateTime _now() => DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.logMilk)),
      body: MilkLogForm(
        db: db,
        clock: clock,
        onSaved: (cows, session, total) {
          final l10n = context.l10n;
          final messenger = ScaffoldMessenger.of(context);
          Navigator.pop(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.savedSessionMilk(
                  cows,
                  sessionLabel(l10n, session),
                  litres(total),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
