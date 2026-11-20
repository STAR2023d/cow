import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// English or Kiswahili. Each language is named in its own words so a
/// farmer can always find theirs.
class LanguageChoice extends StatelessWidget {
  const LanguageChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LanguageController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.language,
            style: TextStyle(color: context.farm.muted),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'sw', label: Text('Kiswahili')),
            ],
            selected: {controller.locale.languageCode},
            onSelectionChanged: (s) => controller.setLanguage(s.first),
          ),
        ],
      ),
    );
  }
}

/// Light, dark or the phone's setting. Light reads best outdoors.
class ThemeChoice extends StatelessWidget {
  const ThemeChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.screenColours,
            style: TextStyle(color: context.farm.muted),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
              ),
              segments: [
                _themeSegment(
                  ThemeMode.light,
                  Icons.light_mode,
                  context.l10n.themeLight,
                ),
                _themeSegment(
                  ThemeMode.dark,
                  Icons.dark_mode,
                  context.l10n.themeDark,
                ),
                _themeSegment(
                  ThemeMode.system,
                  Icons.phone_android,
                  context.l10n.themePhone,
                ),
              ],
              selected: {controller.mode},
              onSelectionChanged: (s) => controller.setMode(s.first),
            ),
          ),
        ],
      ),
    );
  }

  /// Icon above the word, so the three choices fit a narrow drawer.
  ButtonSegment<ThemeMode> _themeSegment(
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    return ButtonSegment(
      value: mode,
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, softWrap: false),
        ],
      ),
    );
  }
}
