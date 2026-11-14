import 'package:cow/database/app_database.dart';
import 'package:cow/screens/widgets/app_drawer.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> openDrawer(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Provider<AppDatabase>.value(
        value: db,
        child: const MaterialApp(
          home: Scaffold(drawer: AppDrawer(), body: Text('home')),
        ),
      ),
    );
    final state = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();
  }

  testWidgets('lists real screens in groups, no placeholders', (tester) async {
    await openDrawer(tester);

    for (final section in ['HERD', 'DAILY CARE', 'MONEY']) {
      expect(find.text(section), findsOneWidget, reason: section);
    }
    for (final item in [
      'Log Milk',
      'Herd & Milk',
      'Breeding',
      'Calf Register',
      'Feeding',
      'Health',
      'Vet Assistant',
      'Expenses',
      'Financial Statement',
      'Monthly Report',
      'Milk Analytics',
    ]) {
      expect(find.text(item), findsOneWidget, reason: item);
    }
    for (final gone in ['Home', 'Search', 'Dashboard', 'Settings']) {
      expect(find.text(gone), findsNothing, reason: gone);
    }
  });

  testWidgets('closes the drawer before opening a screen', (tester) async {
    await openDrawer(tester);
    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();

    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pop();
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(find.text('Expenses'), findsNothing); // drawer is closed
  });
}
