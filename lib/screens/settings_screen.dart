import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/screens/widgets/erase_data_dialog.dart';
import 'package:cow/screens/widgets/settings_choices.dart';
import 'package:cow/settings/farm_name.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Farm name, language and screen colours; erasing all data at the bottom.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: context.read<FarmNameController>().name ?? '',
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _saveName({bool reset = false}) async {
    if (!reset && !_formKey.currentState!.validate()) return;
    if (reset) _name.clear();
    FocusScope.of(context).unfocus();
    await context.read<FarmNameController>().setName(reset ? null : _name.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.farmNameSaved)));
  }

  Widget _heading(String text, {Color? color}) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color ?? context.farm.muted,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasCustom = context.watch<FarmNameController>().name != null;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _heading(l.farmName),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: TextFormField(
                key: const ValueKey('farm-name'),
                controller: _name,
                textCapitalization: TextCapitalization.words,
                maxLength: FarmNameController.maxLength,
                decoration: InputDecoration(
                  hintText: l.appTitle,
                  helperText: l.farmNameHelp,
                  prefixIcon: const Icon(Icons.agriculture),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = v?.trim().length ?? 0;
                  return n < FarmNameController.minLength ||
                          n > FarmNameController.maxLength
                      ? l.farmNameLength
                      : null;
                },
                onFieldSubmitted: (_) => _saveName(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _saveName,
                  icon: const Icon(Icons.save),
                  label: Text(l.save),
                ),
                if (hasCustom)
                  TextButton(
                    onPressed: () => _saveName(reset: true),
                    child: Text(l.useDefaultName),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const LanguageChoice(),
          const ThemeChoice(),
          const Divider(),
          _heading(l.dangerZone, color: context.farm.danger),
          ListTile(
            leading: Icon(Icons.delete_forever, color: context.farm.danger),
            title: Text(
              l.eraseAllData,
              style: TextStyle(color: context.farm.danger),
            ),
            subtitle: Text(l.eraseWhatStays),
            onTap: () =>
                showEraseDataDialog(context, context.read<AppDatabase>()),
          ),
        ],
      ),
    );
  }
}
