import 'package:cow/database/app_database.dart';
import 'package:cow/health/reminders.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 11, 13, 15, 30);

HealthRecordData _rec(int id, DateTime? followUp) => HealthRecordData(
  id: id,
  date: DateTime(2026, 11, 1),
  cowId: 1,
  recordType: 'Vaccination',
  description: 'test',
  followUpDate: followUp,
);

void main() {
  test('records with no follow-up date are ignored', () {
    expect(dueReminders([_rec(1, null)], _now), isEmpty);
  });

  test('today, upcoming and overdue are classified and ordered', () {
    final r = dueReminders([
      _rec(1, DateTime(2026, 11, 20)), // in 7 days
      _rec(2, DateTime(2026, 11, 13, 8)), // today, earlier hour
      _rec(3, DateTime(2026, 11, 10)), // 3 days overdue
    ], _now);

    expect(r.map((x) => x.record.id), [3, 2, 1]);
    expect(r[0].daysUntil, -3);
    expect(r[0].isOverdue, isTrue);
    expect(r[1].isToday, isTrue);
    expect(r[1].isOverdue, isFalse);
    expect(r[2].daysUntil, 7);
    expect(r[2].dueOn, DateTime(2026, 11, 20));
  });

  test('items too far ahead or too long overdue are dropped', () {
    final r = dueReminders([
      _rec(1, DateTime(2026, 11, 28)), // +15
      _rec(2, DateTime(2026, 10, 29)), // -15
      _rec(3, DateTime(2026, 10, 30)), // -14, kept
    ], _now);
    expect(r.map((x) => x.record.id), [3]);
  });

  test('exactly 14 days ahead is kept', () {
    final r = dueReminders([_rec(1, DateTime(2026, 11, 27))], _now);
    expect(r.single.daysUntil, 14);
  });

  test('custom window is respected', () {
    final r = dueReminders(
      [_rec(1, DateTime(2026, 11, 16))],
      _now,
      aheadDays: 2,
    );
    expect(r, isEmpty);
  });
}
