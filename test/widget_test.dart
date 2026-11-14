import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<BuildContext> themed(WidgetTester tester, ThemeData theme) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        theme: theme,
        home: const Scaffold(body: SizedBox()),
      ),
    );
    return tester.element(find.byType(Scaffold));
  }

  testWidgets('dark theme keeps the navy background', (tester) async {
    final context = await themed(tester, AppTheme.dark);
    expect(Theme.of(context).scaffoldBackgroundColor, AppColors.darkBackground);
    expect(context.farm.warning, FarmColors.dark.warning);
  });

  testWidgets('light theme is light, with deep readable accents', (
    tester,
  ) async {
    final context = await themed(tester, AppTheme.light);
    final theme = Theme.of(context);
    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
    expect(context.farm.warning, FarmColors.light.warning);
    // Text and accents must stand out on a white card (WCAG AA: 4.5:1).
    for (final c in [
      theme.colorScheme.onSurface,
      context.farm.good,
      context.farm.warning,
      context.farm.danger,
      context.farm.info,
      context.farm.special,
      context.farm.muted,
    ]) {
      expect(
        _contrast(c, Colors.white),
        greaterThanOrEqualTo(4.5),
        reason: '$c',
      );
    }
  });

  test('theme choice is light by default and remembered', () async {
    SharedPreferences.setMockInitialValues({});
    expect((await ThemeController.load()).mode, ThemeMode.light);

    final controller = await ThemeController.load();
    await controller.setMode(ThemeMode.dark);
    expect((await ThemeController.load()).mode, ThemeMode.dark);
  });
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}
