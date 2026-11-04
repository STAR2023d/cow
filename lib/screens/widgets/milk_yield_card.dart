import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
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
    final end = DateTime(today.year, today.month, today.day);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: StreamBuilder<Map<DateTime, double>>(
        stream: db.watchDailyTotalsInRange(start, end),
        builder: (context, snapshot) {
          final totals = snapshot.data ?? {};

          // Seven clean midnight dates, oldest first.
          final days = List.generate(7, (i) => start.add(Duration(days: i)));

          // Litres per day (0 when nothing was logged).
          final values = days.map((d) => totals[d] ?? 0.0).toList();
          final maxValue = values.fold<double>(0, (m, v) => v > m ? v : m);
          final todayTotal = values.last;
          final yesterdayTotal = values[values.length - 2];
          final double? percentChange = yesterdayTotal > 0
              ? ((todayTotal - yesterdayTotal) / yesterdayTotal) * 100
              : null;

          // Weekday initials for the labels under the bars.
          const weekMap = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final dayLabels = days.map((d) {
            final idx = d.weekday - 1;
            return (idx >= 0 && idx < 7) ? weekMap[idx] : '';
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "MILK YIELD (LITERS)",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
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
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Text(
                '${todayTotal.toStringAsFixed(1)} L',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                percentChange == null
                    ? 'No data for yesterday'
                    : '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(0)}% from yesterday',
                style: TextStyle(
                  fontSize: 11,
                  color: (percentChange ?? 0) >= 0
                      ? Colors.greenAccent
                      : Colors.redAccent,
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
        color: isPeak ? AppColors.accent : Colors.white24,
        borderRadius: BorderRadius.circular(3),
        boxShadow: isPeak
            ? [
                const BoxShadow(
                  color: AppColors.accent,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
