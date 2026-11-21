import 'package:cow/l10n/language_controller.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_headline.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:flutter/material.dart';

/// Live 7-day milk yield card. One stream drives the sparkline, the
/// headline total, and the day-over-day percentage change.
class MilkYieldCard extends StatelessWidget {
  final AppDatabase db;

  const MilkYieldCard({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 6));
    // Today's entries keep the time they were saved, so go to the end of today.
    final end = DateTime(
      today.year,
      today.month,
      today.day + 1,
    ).subtract(const Duration(seconds: 1));

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: context.farm.faint),
      ),
      child: StreamBuilder<List<MilkTableData>>(
        stream: db.watchMilkInRange(start, end),
        builder: (context, snapshot) {
          final byDay = sessionTotalsByDay(
            (snapshot.data ?? const []).map(
              (e) => (date: e.entryDate, session: e.session, litres: e.amount),
            ),
          );

          // Seven clean midnight dates, oldest first.
          final days = List.generate(7, (i) => start.add(Duration(days: i)));

          // Litres per day (0 when nothing was logged).
          final values = days
              .map(
                (d) => (byDay[d] ?? const {}).values.fold<double>(
                  0,
                  (a, b) => a + b,
                ),
              )
              .toList();
          final maxValue = values.fold<double>(0, (m, v) => v > m ? v : m);
          final headline = MilkHeadline.from(
            today: byDay[days.last] ?? const {},
            yesterday: byDay[days[days.length - 2]] ?? const {},
          );
          final percentChange = headline.percentChange;

          // Weekday initials for the labels under the bars.
          const weekMap = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final dayLabels = days.map((d) {
            final idx = d.weekday - 1;
            return (idx >= 0 && idx < 7) ? weekMap[idx] : '';
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.milkYieldTitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: context.farm.muted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 50,
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (i) {
                          final isPeak = maxValue > 0 && values[i] == maxValue;
                          final height = maxValue > 0
                              ? (values[i] / maxValue) * 50
                              : 2.0;
                          // Expanded so the bars share the row width evenly.
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              child: _GraphBar(
                                height: height < 2 ? 2 : height,
                                isPeak: isPeak,
                              ),
                            ),
                          );
                        }),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    // Expanded so each label lines up with its bar above.
                    return Expanded(
                      child: Text(
                        dayLabels[i],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 9,
                          color: context.farm.muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Text(
                litres(headline.litres),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                switch (headline.kind) {
                  MilkHeadlineKind.none => context.l10n.noMilkLoggedYet,
                  MilkHeadlineKind.yesterdayOnly =>
                    context.l10n.milkYesterdayTodayNotLogged,
                  MilkHeadlineKind.today =>
                    percentChange == null
                        ? context.l10n.milkToday
                        : '${context.l10n.milkToday} · ${context.l10n.changeFromYesterday('${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(0)}')}',
                },
                style: TextStyle(
                  fontSize: 11,
                  color: percentChange == null
                      ? context.farm.muted
                      : percentChange >= 0
                      ? context.farm.good
                      : context.farm.danger,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GraphBar extends StatelessWidget {
  final double height;
  final bool isPeak;

  const _GraphBar({required this.height, this.isPeak = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: isPeak
            ? Theme.of(context).colorScheme.primary
            : context.farm.faint,
        borderRadius: BorderRadius.circular(3),
        boxShadow: isPeak
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
