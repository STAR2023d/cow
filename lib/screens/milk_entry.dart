import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_entry_enum.dart';
import 'package:cow/screens/widgets/edit_milk_entry_dialog.dart';
import 'package:cow/screens/widgets/milk_hold_banner.dart';
import 'package:cow/screens/widgets/undo_delete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  // Kept after saving: the buyer is usually the same for the next entry.
  final TextEditingController _buyerController = TextEditingController();

  @override
  void dispose() {
    // clean up to prevent memory leaks
    _quantityController.dispose();
    _buyerController.dispose();
    super.dispose();
  }

  /// MilkingSession has three values (morning/midday/evening), but the
  /// dashboard's aggregation queries (watchSessionDailyTotal, etc.) and
  /// the MilkSession class in app_database.dart filter on the
  /// capitalized strings 'Morning' / 'Evening'. This keeps entries
  /// logged here consistent with those queries instead of silently
  /// storing lowercase 'morning'/'evening' that wouldn't match.
  String _sessionLabel(MilkingSession session) {
    switch (session) {
      case MilkingSession.morning:
        return MilkSession.morning;
      case MilkingSession.afternoon:
        return MilkSession.afternoon;
      case MilkingSession.evening:
        return MilkSession.evening;
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<AppDatabase>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.milkEntryFor(widget.cowName))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MilkHoldBanner(cowId: widget.cowId),
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
                        Text(
                          context.l10n.milkingSession,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10), // Small gap below dropdown

                        const SizedBox(height: 8), // Small targeted micro-gap
                        SegmentedButton<MilkingSession>(
                          segments: <ButtonSegment<MilkingSession>>[
                            ButtonSegment<MilkingSession>(
                              value: MilkingSession.morning,
                              label: Text(context.l10n.sessionMorning),
                              icon: Icon(Icons.wb_sunny_outlined),
                            ),
                            ButtonSegment<MilkingSession>(
                              value: MilkingSession.afternoon,
                              label: Text(context.l10n.sessionAfternoon),
                              icon: Icon(Icons.wb_sunny),
                            ),
                            ButtonSegment<MilkingSession>(
                              value: MilkingSession.evening,
                              label: Text(context.l10n.sessionEvening),
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
                        labelText: context.l10n.milkQuantity,
                        hintText: '0.00',
                        suffixText: 'litres',
                        prefixIcon: const Icon(Icons.opacity),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.farm.muted,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.farm.info,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.farm.danger,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.farm.danger,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.enterAmount;
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return context.l10n.enterValidNumber;
                        }
                        if (amount <= 0) {
                          return context.l10n.quantityAboveZero;
                        }
                        return null;
                      },
                    ),

                    // --- BUYER FIELD (optional) ---
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _buyerController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: context.l10n.buyerOptional,
                        hintText: context.l10n.buyerHint,
                        prefixIcon: const Icon(Icons.storefront_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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

                          // upsertMilkEntry both inserts new entries and,
                          // if this cow/day/session already has one,
                          // updates it in place instead of creating a
                          // duplicate — no separate double-log check needed.
                          await database.upsertMilkEntry(
                            cowId: widget.cowId,
                            date: DateTime.now(),
                            session: _sessionLabel(_selectedSession),
                            amount: inputAmount,
                            buyer: _buyerController.text,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n.savedAmount(litres(inputAmount)),
                                ),
                              ),
                            );

                            // Empty out the input field so it reads blank and is ready for the next day's entry
                            _quantityController.clear();
                          }
                        }
                      },
                      child: Text(
                        context.l10n.save,
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
              children: [
                Icon(Icons.history, color: context.farm.muted),
                SizedBox(width: 8),
                Text(
                  context.l10n.historyLog,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.farm.muted,
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
                  return Center(
                    child: Text(
                      context.l10n.noMilkEntriesForCow,
                      style: TextStyle(color: context.farm.muted),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];

                    final formattedDate = dateTime(entry.entryDate);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: ListTile(
                        onTap: () => _editEntry(database, entry, formattedDate),
                        leading: CircleAvatar(
                          backgroundColor: context.farm.info.withValues(),
                          child: Icon(Icons.opacity, color: context.farm.info),
                        ),
                        title: Text(
                          litres(entry.amount),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          entry.buyer == null
                              ? formattedDate
                              : '$formattedDate • ${entry.buyer}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(
                                sessionLabel(
                                  context.l10n,
                                  entry.session,
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: context.l10n.editEntry,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () =>
                                  _editEntry(database, entry, formattedDate),
                            ),
                            IconButton(
                              tooltip: context.l10n.deleteEntry,
                              icon: Icon(
                                Icons.delete_outline,
                                color: context.farm.danger,
                              ),
                              onPressed: () => deleteWithUndo(
                                context,
                                what: context.l10n.milkEntryWhat,
                                delete: () =>
                                    database.deleteMilkEntry(entry.id),
                                restore: () => database.restoreMilkEntry(entry),
                              ),
                            ),
                          ],
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

  Future<void> _editEntry(
    AppDatabase database,
    MilkTableData entry,
    String when,
  ) async {
    final edit = await showDialog<MilkEntryEdit>(
      context: context,
      builder: (_) => EditMilkEntryDialog(
        amount: entry.amount,
        buyer: entry.buyer,
        label:
            '${sessionLabel(context.l10n, entry.session).toUpperCase()} • $when',
      ),
    );
    if (edit == null) return;
    await database.updateMilkEntry(
      entry.id,
      amount: edit.amount,
      buyer: edit.buyer,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.milkEntryUpdated)));
  }
}
