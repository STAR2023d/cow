import 'package:cow/screens/widgets/edit_milk_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              await showDialog<MilkEntryEdit>(
                context: context,
                builder: (_) => const EditMilkEntryDialog(
                  amount: 50,
                  buyer: 'KCC',
                  label: 'MORNING',
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the current figures and saves a corrected one', (
    tester,
  ) async {
    MilkEntryEdit? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showDialog<MilkEntryEdit>(
              context: context,
              builder: (_) => const EditMilkEntryDialog(
                amount: 50,
                buyer: 'KCC',
                label: 'MORNING',
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('50'), findsOneWidget);
    expect(find.text('KCC'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '5.5');
    await tester.enterText(find.byType(TextFormField).last, '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(result, (amount: 5.5, buyer: null));
  });

  testWidgets('rejects zero and stays open', (tester) async {
    await open(tester);
    await tester.enterText(find.byType(TextFormField).first, '0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Quantity must be greater than zero'), findsOneWidget);
    expect(find.text('Edit milk entry'), findsOneWidget);
  });
}
