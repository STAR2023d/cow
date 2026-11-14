import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Saves [bytes] as [fileName] in `Documents/Mwauras Farm/` and returns
/// the file. An existing file with the same name is replaced.
Future<File> savePdf(Uint8List bytes, String fileName) async {
  final docs = await getApplicationDocumentsDirectory();
  final sep = Platform.pathSeparator;
  final dir = Directory('${docs.path}${sep}Mwauras Farm');
  await dir.create(recursive: true);
  return File('${dir.path}$sep$fileName').writeAsBytes(bytes, flush: true);
}

/// Opens [file] in the system's PDF viewer on desktop. Returns false when
/// it could not be opened (the file is still saved).
Future<bool> openFile(File file) async {
  final command = Platform.isLinux
      ? 'xdg-open'
      : Platform.isMacOS
      ? 'open'
      : Platform.isWindows
      ? 'explorer'
      : null;
  if (command == null) return false;
  try {
    final result = await Process.run(command, [file.path]);
    // explorer returns 1 even when it opens the file.
    return Platform.isWindows || result.exitCode == 0;
  } on ProcessException {
    return false;
  }
}
