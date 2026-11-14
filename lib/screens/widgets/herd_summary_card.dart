import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Live herd size + breed breakdown, sourced from watchAllCow().
class HerdSummaryCard extends StatelessWidget {
  final AppDatabase db;

  const HerdSummaryCard({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: context.farm.faint),
      ),
      child: StreamBuilder<List<CowData>>(
        stream: db.watchAllCow(),
        builder: (context, snapshot) {
          final cows = snapshot.data ?? [];
          final byBreed = <String, int>{};
          for (final c in cows) {
            final breed = c.breed ?? 'Unknown';
            byBreed[breed] = (byBreed[breed] ?? 0) + 1;
          }
          final breedSummary = byBreed.isEmpty
              ? 'No cows yet'
              : byBreed.entries.map((e) => '${e.value} ${e.key}').join('  •  ');

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MY HERD SUMMARY",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: context.farm.muted,
                  letterSpacing: 0.5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Icon(Icons.pets, color: context.farm.muted, size: 28),
              ),
              Column(
                children: [
                  Text(
                    '${cows.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "Total Animals",
                    style: TextStyle(fontSize: 11, color: context.farm.muted),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  breedSummary,
                  style: TextStyle(
                    fontSize: 9,
                    color: context.farm.muted,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
