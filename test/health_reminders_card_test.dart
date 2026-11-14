import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/health_reminders_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _today = DateTime.now();

HealthRecordData _rec(int id, int daysFromToday) => HealthRecordData(
  id: id,
  date: _today.subtract(const Duration(days: 30)),
  cowId: 1,
  recordType: 'Vaccination',
  description: 'record $id',
  followUpDate: DateTime(_today.year, _today.month, _today.day + daysFromToday),
);

Future<void> _show(WidgetTester tester, List<HealthRecordData> records) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: HealthRemindersCard(
            cows: Stream.value(const [CowData(id: 1, name: 'Daisy')]),
            records: Stream.value(records),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('hidden when there are no reminders', (tester) async {
    await _show(tester, [_rec(1, 60)]); // outside the window
    expect(find.textContaining('Health reminders'), findsNothing);
  });

  testWidgets('shows an overdue label', (tester) async {
    await _show(tester, [_rec(1, -3), _rec(2, 0), _rec(3, 1)]);
    expect(find.text('Health reminders (3)'), findsOneWidget);
    expect(find.text('Overdue by 3 days'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(
      find.textContaining('Daisy · Vaccination: record 1'),
      findsOneWidget,
    );
  });

  testWidgets('shows "+N more" past five reminders', (tester) async {
    await _show(tester, [for (var i = 1; i <= 7; i++) _rec(i, i)]);
    expect(find.text('Health reminders (7)'), findsOneWidget);
    expect(find.text('+2 more'), findsOneWidget);
    expect(find.textContaining('record 6'), findsNothing);
  });
}
