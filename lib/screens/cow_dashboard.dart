import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'dart:io';
import 'package:cow/abstract/dialog_deletion.dart';
import 'package:cow/breeding/breeding_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cow_add.dart';
import 'milk_entry.dart';

class HerdDashboard extends StatelessWidget {
  const HerdDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myHerd),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder<List<CowData>>(
        stream: db.watchAllCow(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(context.l10n.errorLoading('${snapshot.error}')),
            );
          }

          final cows = snapshot.data ?? [];

          if (cows.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: context.farm.muted),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noCowsInHerd,
                    style: TextStyle(fontSize: 18, color: context.farm.muted),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            // Bottom padding adjusted to 84 so items clear the Floating Action Button area
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: 84,
            ),
            itemCount: cows.length,
            itemBuilder: (context, index) {
              final cow = cows[index];
              return InkWell(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Keeps the clickable touch effect rounded
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MilkData(
                        cowId: cow.id, // Sends the integer ID across
                        cowName: cow.name,
                      ),
                    ),
                  );
                },

                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: context.farm.faint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              cow.imagePath != null && cow.imagePath!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(cow.imagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: context.farm.muted,
                                        ),
                                  ),
                                )
                              : Icon(
                                  Icons.insert_photo,
                                  size: 40,
                                  color: context.farm.muted,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cow.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.tagLine(
                                  cow.tag ?? context.l10n.noTag,
                                ),
                                style: TextStyle(
                                  color: context.farm.muted,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                context.l10n.breedAgeLine(
                                  cow.breed ?? context.l10n.unknownBreed,
                                  cow.age == null
                                      ? context.l10n.notAvailable
                                      : context.l10n.ageYears(cow.age!),
                                ),
                                style: TextStyle(
                                  color: context.farm.muted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.navBreeding,
                          icon: Icon(
                            Icons.favorite_border,
                            color: context.farm.danger,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BreedingScreen(
                                cowId: cow.id,
                                cowName: cow.name,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: context.farm.danger,
                          ),
                          onPressed: () =>
                              _startTwoStepDeleteProcess(context, db, cow),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      //  Modern Extended Action Button for Add Cow Screen Navigation
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CowAdd()),
          );
        },
        label: Text(
          context.l10n.qaAddCow,
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        icon: const Icon(Icons.add_rounded, size: 24),
        elevation: 4,
      ),
    );
  }

  // Launches the modern multi-stage workflow dialog
  void _startTwoStepDeleteProcess(
    BuildContext context,
    AppDatabase db,
    CowData cow,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return TwoStepDeleteWorkflow(
          cow: cow,
          onConfirmedDelete: () async {
            await db.deleteCow(cow.id);
          },
        );
      },
    );
  }
}
