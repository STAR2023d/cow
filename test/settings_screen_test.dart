import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/screens/settings_screen.dart';
import 'package:cow/screens/widgets/farm_header_card.dart';
import 'package:cow/settings/farm_name.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('rename the farm, reset it; language and colours', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final farm = FarmNameController();
    final theme = ThemeController();
    final language = LanguageController();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: db),
          ChangeNotifierProvider.value(value: farm),
          ChangeNotifierProvider.value(value: theme),
          ChangeNotifierProvider.value(value: language),
        ],
        child: Builder(
          builder: (context) => MaterialApp(
            locale: context.watch<LanguageController>().locale,
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            home: const Scaffold(
              body: Column(
                children: [
                  FarmHeaderCard(),
                  Expanded(child: SettingsScreen()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("MWAURA'S FARM"), findsOneWidget);

    // Too short is refused.
    await tester.enterText(find.byKey(const ValueKey('farm-name')), 'K');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Use 2 to 60 letters'), findsOneWidget);
    expect(farm.name, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('farm-name')),
      '  Kamau Dairies ',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(farm.name, 'Kamau Dairies');
    expect(find.text('KAMAU DAIRIES'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString('farm_name'),
      'Kamau Dairies',
    );
    expect((await FarmNameController.load()).name, 'Kamau Dairies');

    await tester.tap(find.text('Use the default name'));
    await tester.pumpAndSettle();
    expect(farm.name, isNull);
    expect(find.text("MWAURA'S FARM"), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(theme.mode, ThemeMode.dark);

    await tester.tap(find.text('Kiswahili'));
    await tester.pumpAndSettle();
    expect(language.isSwahili, isTrue);
    expect(find.text('Mipangilio'), findsOneWidget);
    expect(find.text('Jina la shamba'.toUpperCase()), findsOneWidget);
    expect(find.text('SHAMBA LA MWAURA'), findsOneWidget);
    language.setLanguage('en'); // leave Intl's default as other tests expect
    await tester.pumpAndSettle();
  });
}
