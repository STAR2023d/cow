import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/milk_hold_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

HealthRecordData _rec(int id, int cowId, DateTime date, int days) =>
    HealthRecordData(
      id: id,
      date: date,
      cowId: cowId,
      recordType: 'Treatment',
      description: 'test',
      milkWithdrawalDays: days,
    );

Future<void> _show(WidgetTester tester, List<HealthRecordData> records) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MilkHoldCard(
          cows: Stream.value(const [
            CowData(id: 1, name: 'Daisy'),
            CowData(id: 2, name: 'Bella'),
          ]),
          records: Stream.value(records),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  final today = DateTime.now();

  testWidgets('lists only cows on hold', (tester) async {
    await _show(tester, [
      _rec(1, 1, today, 2), // on hold, 3 days left
      _rec(2, 2, today.subtract(const Duration(days: 30)), 3), // over
    ]);
    expect(find.text('Milk on hold (1)'), findsOneWidget);
    expect(find.textContaining('Daisy: do not sell until'), findsOneWidget);
    expect(find.textContaining('3 days left'), findsOneWidget);
    expect(find.textContaining('Bella'), findsNothing);
  });

  testWidgets('hidden when no cow is on hold', (tester) async {
    await _show(tester, []);
    expect(find.textContaining('Milk on hold'), findsNothing);
  });
}
