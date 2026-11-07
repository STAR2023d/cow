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
        title: const Text('My Herd Dashboard'),
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
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }

          final cows = snapshot.data ?? [];

          if (cows.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.pets, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No cows in your herd yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
                            color: Colors.grey[200],
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
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                  ),
                                )
                              : const Icon(
                                  Icons.insert_photo,
                                  size: 40,
                                  color: Colors.grey,
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
                                'Tag: ${cow.tag ?? "No Tag"}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Breed: ${cow.breed ?? "Unknown"} • Age: ${cow.age ?? "N/A"} yrs',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Breeding',
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.pinkAccent,
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
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
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
        label: const Text(
          'Add Cow',
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
