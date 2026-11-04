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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
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
              const Text(
                "MY HERD SUMMARY",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
                  letterSpacing: 0.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Icon(Icons.pets, color: Colors.white70, size: 28),
              ),
              Column(
                children: [
                  Text(
                    '${cows.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const Text(
                    "Total Animals",
                    style: TextStyle(fontSize: 11, color: Colors.white38),
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
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
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
