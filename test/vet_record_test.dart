import 'package:cow/database/app_database.dart';
import 'package:cow/services/ai/vet_record.dart';
import 'package:cow/services/ai/vet_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

VetAssessment _assessment(VetUrgency urgency, {String summary = ''}) =>
    VetAssessment(urgency: urgency, summary: summary);

void main() {
  final now = DateTime(2026, 11, 7, 15);

  group('buildVetRecordDraft', () {
    test('follow-up is tomorrow when urgent, in two days when monitoring', () {
      final urgent = buildVetRecordDraft(
        assessment: _assessment(VetUrgency.emergency),
        symptoms: 'Bloated',
        now: now,
      );
      final soon = buildVetRecordDraft(
        assessment: _assessment(VetUrgency.seeVetSoon),
        symptoms: 'Limping',
        now: now,
      );
      final monitor = buildVetRecordDraft(
        assessment: _assessment(VetUrgency.monitorAtHome),
        symptoms: 'Eating less',
        now: now,
      );

      expect(urgent.followUpDate, DateTime(2026, 11, 8));
      expect(soon.followUpDate, DateTime(2026, 11, 8));
      expect(monitor.followUpDate, DateTime(2026, 11, 9));
    });

    test('follow-up rolls over the end of the month', () {
      final draft = buildVetRecordDraft(
        assessment: _assessment(VetUrgency.monitorAtHome),
        symptoms: 'Eating less',
        now: DateTime(2026, 11, 30),
      );
      expect(draft.followUpDate, DateTime(2026, 12, 2));
    });

    test('description has the urgency, symptoms and summary', () {
      final draft = buildVetRecordDraft(
        assessment: _assessment(
          VetUrgency.seeVetSoon,
          summary: 'Possible hoof infection.',
        ),
        symptoms: '  Limping\n on the   back leg ',
        now: now,
      );

      expect(draft.recordType, 'Illness');
      expect(
        draft.description,
        'Vet Assistant (A vet should see her soon): '
        'Limping on the back leg — Possible hoof infection.',
      );
    });

    test('a long description is cut to 300 characters', () {
      final draft = buildVetRecordDraft(
        assessment: _assessment(VetUrgency.monitorAtHome),
        symptoms: 'x' * 500,
        now: now,
      );

      expect(draft.description.length, 300);
      expect(draft.description, endsWith('…'));
    });
  });

  test('a draft can be saved as a health record and read back', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final cowId = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    final draft = buildVetRecordDraft(
      assessment: _assessment(VetUrgency.seeVetSoon, summary: 'Mastitis?'),
      symptoms: 'Swollen udder',
      now: now,
    );

    await db.insertHealthRecord(
      HealthRecordCompanion.insert(
        date: now,
        cowId: cowId,
        recordType: draft.recordType,
        description: draft.description,
        followUpDate: Value(draft.followUpDate),
      ),
    );

    final records = await db.watchHealthRecords().first;
    expect(records.length, 1);
    expect(records.first.recordType, 'Illness');
    expect(records.first.followUpDate, DateTime(2026, 11, 8));
    expect(records.first.description, contains('Swollen udder'));
  });
}
