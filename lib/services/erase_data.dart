import 'dart:io';

import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk_price.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Erases all farm data so the app starts fresh. First saves a backup of
/// the database next to it and returns that file's path. Cow photos are
/// deleted and the milk price is asked for again. Theme and language stay.
/// [folder] replaces the app folder and [now] the clock, in tests.
Future<String> eraseAllFarmData(
  AppDatabase db, {
  Directory? folder,
  DateTime? now,
}) async {
  final dir = folder ?? await getApplicationSupportDirectory();
  final stamp = DateFormat('yyyy-MM-dd-HHmmss').format(now ?? DateTime.now());
  final backup = '${dir.path}/my_database.before-erase-$stamp.sqlite';
  await db.backupTo(backup);
  await db.eraseAllData();
  final photos = Directory('${dir.path}/cow_photos');
  if (await photos.exists()) await photos.delete(recursive: true);
  await MilkPriceFlag.clear();
  return backup;
}
