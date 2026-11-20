import 'dart:io';

import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/screens/cow_add.dart';
import 'package:cow/services/cow_photos.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 20, 9);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('edit a cow: name, tag, breed and age; list status kept', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final id = (await tester.runAsync(
      () => db.insertCow(
        CowCompanion.insert(
          name: 'Dasy',
          breed: const Value('Friesien'),
          inMilk: const Value(false),
        ),
      ),
    ))!;
    final cow = (await tester.runAsync(db.allCows))!.single;

    await tester.pumpWidget(
      Provider<AppDatabase>.value(
        value: db,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CowAdd(cow: cow, clock: () => now),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Edit cow'), findsOneWidget);
    expect(find.text('Friesien'), findsOneWidget); // old breed kept
    await tester.enterText(find.byKey(const ValueKey('cow-name')), 'Daisy');
    await tester.enterText(find.byKey(const ValueKey('cow-tag')), 'KE-12');
    await tester.tap(find.text("Don't know the date? Enter age in years"));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('cow-age-years')), '3');
    await tester.tap(find.text('Save changes'));
    await settle(tester);

    expect(find.text('open'), findsOneWidget); // screen closed
    final saved = (await tester.runAsync(db.allCows))!.single;
    expect(saved.id, id);
    expect(saved.name, 'Daisy');
    expect(saved.tag, 'KE-12');
    expect(saved.bornOn, DateTime(2023, 11, 20));
    expect(saved.inMilk, isFalse);
  });

  test('photos are copied into the app folder and removed later', () async {
    final base = Directory.systemTemp.createTempSync('cow_photos_');
    addTearDown(() => base.deleteSync(recursive: true));
    final picked = File('${base.path}/picker_tmp.png')..writeAsStringSync('x');

    final kept = await keepCowPhoto(picked.path, base: base);
    expect(kept, startsWith('${base.path}/cow_photos/'));
    expect(kept, endsWith('.png'));
    picked.deleteSync(); // the phone clears its temporary copy
    expect(File(kept).existsSync(), isTrue);

    await deleteCowPhoto(kept, base: base);
    expect(File(kept).existsSync(), isFalse);

    // A photo outside the app folder is never deleted.
    final other = File('${base.path}/mine.jpg')..writeAsStringSync('y');
    await deleteCowPhoto(other.path, base: base);
    expect(other.existsSync(), isTrue);
  });
}
