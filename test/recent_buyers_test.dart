import 'package:cow/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recent buyers: newest first, no blanks or repeats', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final cow = await db.insertCow(CowCompanion.insert(name: 'Daisy'));
    Future<void> log(int day, String session, String? buyer) =>
        db.upsertMilkEntry(
          cowId: cow,
          date: DateTime(2026, 11, day, 7),
          session: session,
          amount: 5,
          buyer: buyer,
        );
    await log(10, MilkSession.morning, 'Brookside');
    await log(11, MilkSession.morning, 'Mama Wanjiku');
    await log(12, MilkSession.morning, ' ');
    await log(13, MilkSession.morning, 'brookside');
    await log(14, MilkSession.morning, null);

    expect(await db.recentBuyers(), ['brookside', 'Mama Wanjiku']);
  });
}
