import 'package:cow/breeding/breeding_logic.dart';
import 'package:cow/breeding/breeding_labels.dart';
import 'package:cow/breeding/breeding_rows.dart';
import 'package:cow/breeding/breeding_schema.dart';
import 'package:cow/breeding/calf_register.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/models/expense_category.dart';
import 'package:cow/health/health_presets.dart';
import 'package:cow/l10n/app_localizations.dart';
import 'package:cow/l10n/labels.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final en = lookupL10n(const Locale('en'));
  final sw = lookupL10n(const Locale('sw'));

  test('stored feed and record types show translated, unknown kept', () {
    expect(feedTypeLabel(sw, 'Dairy Meal'), 'Dairy meal');
    expect(feedTypeLabel(sw, 'Pasture'), 'Malisho');
    expect(feedTypeLabel(sw, 'Napier grass'), 'Napier grass');
    expect(recordTypeLabel(sw, 'Tick control'), 'Kudhibiti kupe');
    expect(recordTypeLabel(en, 'Tick control'), 'Tick control');
  });

  test('every preset has a translated chip and description', () {
    for (final p in healthPresets) {
      expect(presetLabel(sw, p), isNot(p.label), reason: p.label);
      expect(presetDescription(en, p), p.description, reason: p.label);
    }
  });

  test('English stage text matches the existing English labels', () {
    for (final stage in BreedingStage.values) {
      expect(stageText(en, stage), stage.label, reason: '$stage');
    }
  });

  test('milestones and due dates', () {
    expect(
      milestoneText(sw, const BreedingMilestone('Check 2 due')),
      'Kipimo 2 kinatakiwa',
    );
    for (final days in [-3, -1, 0, 1, 6]) {
      expect(dueText(en, days), dueLabel(days), reason: '$days');
    }
    expect(dueText(sw, -3), 'amechelewa siku 3');
  });

  test('expense categories match the English labels', () {
    for (final key in [...ExpenseCategory.all, 'unknown']) {
      expect(expenseCategoryLabel(en, key), ExpenseCategory.label(key));
    }
    expect(expenseCategoryLabel(sw, 'vet'), 'Daktari na dawa');
  });

  test('calf age matches CalfEntry.ageOn in English', () {
    final born = DateTime(2025, 3, 10);
    for (final now in [
      DateTime(2025, 3, 9),
      DateTime(2025, 3, 11),
      DateTime(2025, 3, 20),
      DateTime(2025, 4, 25),
      DateTime(2025, 9, 1),
      DateTime(2027, 6, 1),
    ]) {
      final calf = CalfEntry(
        damName: 'Daisy',
        details: Calf(id: 1, dateOfBirth: born, sex: 'female', boughtIn: false),
      );
      expect(calfAgeText(en, born, now), calf.ageOn(now), reason: '$now');
    }
    expect(calfAgeText(sw, born, DateTime(2025, 9, 1)), 'miezi 5');
  });

  test('dam names', () {
    expect(damLabel(sw, 'Unknown dam'), 'Mama hajulikani');
    expect(damLabel(sw, 'Cow #4'), "Ng'ombe #4");
    expect(damLabel(sw, 'Daisy'), 'Daisy');
  });
}
