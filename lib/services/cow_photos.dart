import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Cow photos are copied into the app's own folder, so they stay when the
/// phone clears the picker's temporary copy.

Future<Directory> _photoDir([Directory? base]) async {
  final root = base ?? await getApplicationSupportDirectory();
  final dir = Directory('${root.path}/cow_photos');
  await dir.create(recursive: true);
  return dir;
}

/// Copies the picked photo at [pickedPath] into the app's photo folder and
/// returns the new path. [base] replaces the app folder in tests.
Future<String> keepCowPhoto(String pickedPath, {Directory? base}) async {
  final dir = await _photoDir(base);
  final dot = pickedPath.lastIndexOf('.');
  final ext = dot > pickedPath.lastIndexOf('/')
      ? pickedPath.substring(dot)
      : '.jpg';
  final target = '${dir.path}/${DateTime.now().microsecondsSinceEpoch}$ext';
  await File(pickedPath).copy(target);
  return target;
}

/// Deletes a photo the app copied earlier. Photos stored elsewhere (from
/// before photos were copied) are left alone.
Future<void> deleteCowPhoto(String? path, {Directory? base}) async {
  if (path == null) return;
  final dir = await _photoDir(base);
  if (!path.startsWith('${dir.path}/')) return;
  final f = File(path);
  if (await f.exists()) await f.delete();
}
