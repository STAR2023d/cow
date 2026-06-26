import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_entry_enum.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MilkData extends StatefulWidget {
  final int cowId;
  final String cowName;

  const MilkData({super.key, required this.cowId, required this.cowName});

  @override
  State<MilkData> createState() => _MilkDataState();
}

class _MilkDataState extends State<MilkData> {
  final _formKey = GlobalKey<FormState>();
  MilkingSession _selectedSession = MilkingSession.morning;
  // Tracks the ID of the chosen cow

  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    // clean up to prevent memory leaks
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<AppDatabase>();
    return Scaffold(
      appBar: AppBar(title: Text('Milk Entry ${widget.cowName}')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              // Adds standard structural breathing room around the outer container edge
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- SESSION SECTION ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Milking Session',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10), // Small gap below dropdown

                        const SizedBox(height: 8), // Small targeted micro-gap
                        SegmentedButton<MilkingSession>(
                          segments: const <ButtonSegment<MilkingSession>>[
                            ButtonSegment<MilkingSession>(
                              value: MilkingSession.morning,
                              label: Text('Morning'),
                              icon: Icon(Icons.wb_sunny_outlined),
                            ),
                            ButtonSegment<MilkingSession>(
                              value: MilkingSession.midday,
                              label: Text('Midday'),
                              icon: Icon(Icons.wb_sunny),
                            ),
                            ButtonSegment<MilkingSession>(
                              value: MilkingSession.evening,
                              label: Text('Evening'),
                              icon: Icon(Icons.dark_mode_outlined),
                            ),
                          ],
                          selected: <MilkingSession>{_selectedSession},
                          onSelectionChanged:
                              (Set<MilkingSession> newSelection) {
                                setState(() {
                                  _selectedSession = newSelection.first;
                                });
                              },
                        ),
                      ],
                    ),

                    // --- QUANTITY FIELD ---
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Milk Quantity',
                        hintText: '0.00',
                        suffixText: 'Liters',
                        prefixIcon: const Icon(Icons.opacity),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Please enter a valid number';
                        }
                        if (amount <= 0) {
                          return 'Quantity must be greater than zero';
                        }
                        return null;
                      },
                    ),

                    // --- SUBMIT BUTTON ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),

                      onPressed: () async {
                        // Check if the user actually typed a valid number
                        if (_formKey.currentState!.validate()) {
                          //Convert the raw user text input into a standard Dart decimal number
                          final inputAmount = double.parse(
                            _quantityController.text,
                          );

                          //Look into the app's tree layout and locate our open Database instance
                          final database = context.read<AppDatabase>();

                          //Prepare the "Order Ticket" (The Companion)
                          //Drift requires a Companion object because it allows values to be explicitly "set" or "absent"
                          final ticket = MilkTableCompanion(
                            //Generates a simple text timestamp ID string
                            id: drift.Value(
                              DateTime.now().millisecondsSinceEpoch.toString(),
                            ),

                            //Grabs the exact current device date and time
                            entryDate: drift.Value(DateTime.now()),

                            // Takes our selected enum (morning, midday, evening) and converts it to text
                            session: drift.Value(_selectedSession.name),

                            // Plugs in the double decimal value we parsed above
                            amount: drift.Value(inputAmount),

                            //selected cow id
                            cowId: drift.Value(widget.cowId),
                          );

                          await database.insertMilkEntry(ticket);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Saved $inputAmount Liters successfully to Drift!',
                                ),
                              ),
                            );

                            // Empty out the input field so it reads blank and is ready for the next day's entry
                            _quantityController.clear();
                          }
                        }
                      },
                      child: const Text(
                        'Submit Data',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // --- REAL-TIME ENTRIES HISTORY LOG ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              children: const [
                Icon(Icons.history, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Production History Log',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<MilkTableData>>(
              // Hook up the new filtered database query stream
              stream: database.watchEntriesForCow(widget.cowId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final history = snapshot.data ?? [];

                if (history.isEmpty) {
                  return const Center(
                    child: Text(
                      'No milk entries logged yet for this cow.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];

                    // Format the SQLite datetime cleanly (e.g., Jun 24, 2026 • 09:30 AM)
                    final formattedDate = DateFormat(
                      'MMM d, yyyy • hh:mm a',
                    ).format(entry.entryDate);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withValues(),
                          child: const Icon(Icons.opacity, color: Colors.blue),
                        ),
                        title: Text(
                          '${entry.amount.toStringAsFixed(2)} Liters',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(formattedDate),
                        trailing: Chip(
                          label: Text(
                            entry.session.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
