import 'dart:convert';
import 'dart:io';

import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/screens/widgets/app_drawer.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _arb(String code) =>
    jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync());

void main() {
  test('Kiswahili has every English string', () {
    final en = _arb('en').keys.where((k) => !k.startsWith('@')).toSet();
    final sw = _arb('sw').keys.where((k) => !k.startsWith('@')).toSet();
    expect(en.difference(sw), isEmpty);
  });

  test('sessions show in the app language but stay English in the db', () {
    final sw = lookupL10n(const Locale('sw'));
    expect(sessionLabel(sw, MilkSession.morning), 'Asubuhi');
    expect(sessionLabel(sw, MilkSession.evening), 'Jioni');
    expect(MilkSession.morning, 'Morning');
  });

  test('plurals', () {
    final en = lookupL10n(const Locale('en'));
    final sw = lookupL10n(const Locale('sw'));
    expect(en.daysLeft(1), '1 day left');
    expect(en.daysLeft(3), '3 days left');
    expect(sw.daysLeft(3), 'Zimebaki siku 3');
    expect(
      en.saveCowsLitres(2, '11.5 L', 'KSh 575'),
      'Save 2 cows: 11.5 L ≈ KSh 575',
    );
  });

  test('language is English by default and remembered', () async {
    SharedPreferences.setMockInitialValues({});
    expect((await LanguageController.load()).locale.languageCode, 'en');
    await (await LanguageController.load()).setLanguage('sw');
    expect((await LanguageController.load()).isSwahili, isTrue);
  });

  testWidgets('drawer in Kiswahili', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: db),
          ChangeNotifierProvider(create: (_) => ThemeController()),
          ChangeNotifierProvider(
            create: (_) => LanguageController(const Locale('sw')),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('sw'),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(drawer: AppDrawer(), body: SizedBox()),
        ),
      ),
    );
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Andika Maziwa'), findsOneWidget);
    expect(find.text('PESA'), findsOneWidget); // section "Money"
    expect(find.text('Kiswahili'), findsOneWidget);
  });
}
