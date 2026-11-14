import 'package:cow/l10n/language_controller.dart';
import 'package:flutter/material.dart';

/// Deletes at once and shows "[what] deleted" with an Undo button for a
/// few seconds. Undo calls [restore], which puts the same row back.
/// Quicker than asking first, and just as safe.
Future<void> deleteWithUndo(
  BuildContext context, {
  required String what,
  required Future<void> Function() delete,
  required Future<void> Function() restore,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  await delete();
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.deleted(what)),
        duration: const Duration(seconds: 6),
        // A snack bar with a button stays until tapped unless told not to.
        persist: false,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => restore(),
        ),
      ),
    );
}
