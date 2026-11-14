import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/milk_hold_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final records = [
    HealthRecordData(
      id: 1,
      date: DateTime.now(),
      cowId: 1,
      recordType: 'Treatment',
      description: 'test',
      milkWithdrawalDays: 3,
    ),
  ];

  Future<void> show(WidgetTester tester, int cowId) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: MilkHoldBanner(
            key: ValueKey(cowId),
            cowId: cowId,
            records: Stream.value(records),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows banner for a cow on hold', (tester) async {
    await show(tester, 1);
    expect(
      find.textContaining('Milk on hold: do not sell until'),
      findsOneWidget,
    );
  });

  testWidgets('shows nothing for a cow not on hold', (tester) async {
    await show(tester, 2);
    expect(find.textContaining('Milk on hold'), findsNothing);
  });
}
