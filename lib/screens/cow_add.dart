import 'dart:io';

import 'package:cow/abstract/image_source.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/l10n/language_controller.dart';
import 'package:cow/models/cow_age.dart';
import 'package:cow/services/cow_photos.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:cow/utils/format.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Breeds offered in the list. A cow saved with another breed keeps it.
const cowBreeds = ['Holstein', 'Jersey', 'Ayrshire', 'Friesian', 'Guernsey'];

/// Add a cow, or change one already saved when [cow] is given: name, tag,
/// breed, date of birth (or age in years when the date is not known) and
/// photo.
class CowAdd extends StatefulWidget {
  /// The cow to edit, or null to add a new one.
  final CowData? cow;

  /// The current time; replaced in tests.
  final DateTime Function() clock;

  const CowAdd({super.key, this.cow, this.clock = _now});

  static DateTime _now() => DateTime.now();

  @override
  State<CowAdd> createState() => _CowAddState();
}

class _CowAddState extends State<CowAdd> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _tag = TextEditingController();
  final _ageYears = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _breed;
  DateTime? _bornOn;

  /// True when the farmer types an age in years instead of a date.
  bool _byYears = false;

  /// Photo shown now: the saved one, or a newly picked file.
  String? _photo;
  bool _saving = false;

  bool get _editing => widget.cow != null;

  @override
  void initState() {
    super.initState();
    final cow = widget.cow;
    if (cow != null) {
      _name.text = cow.name;
      _tag.text = cow.tag ?? '';
      _breed = cow.breed;
      _bornOn = cow.bornOn;
      _photo = cow.imagePath;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _tag.dispose();
    _ageYears.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked != null) setState(() => _photo = picked.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotPickImage)));
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImageSourceSheet(onSourceSelected: _getImage),
    );
  }

  Future<void> _pickBirthDate() async {
    final today = widget.clock();
    final picked = await showDatePicker(
      context: context,
      initialDate: _bornOn ?? DateTime(today.year - 2, today.month, today.day),
      firstDate: DateTime(today.year - 30),
      lastDate: today,
      helpText: context.l10n.dateOfBirth,
    );
    if (picked != null) setState(() => _bornOn = picked);
  }

  /// The birth date to save: the picked date, or one worked out from the
  /// age in years.
  DateTime? get _birthDateToSave {
    if (!_byYears) return _bornOn;
    final years = int.tryParse(_ageYears.text.trim());
    if (years == null) return null;
    final now = widget.clock();
    return DateTime(now.year - years, now.month, now.day);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final db = context.read<AppDatabase>();
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final name = _name.text.trim();
    final tag = _tag.text.trim();
    try {
      // A newly picked photo is copied into the app's own folder.
      final old = widget.cow?.imagePath;
      var photo = _photo;
      if (photo != null && photo != old) photo = await keepCowPhoto(photo);
      final details = CowCompanion(
        name: drift.Value(name),
        tag: drift.Value(tag.isEmpty ? null : tag),
        breed: drift.Value(_breed),
        bornOn: drift.Value(_birthDateToSave),
        imagePath: drift.Value(photo),
      );
      if (_editing) {
        await db.updateCowDetails(widget.cow!.id, details);
        if (old != photo) await deleteCowPhoto(old);
      } else {
        await db.insertCow(details);
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(_editing ? l10n.cowUpdated(name) : l10n.cowSaved(name)),
          backgroundColor: context.farm.good,
        ),
      );
      if (_editing) {
        Navigator.pop(context);
        return;
      }
      _formKey.currentState!.reset();
      _name.clear();
      _tag.clear();
      _ageYears.clear();
      setState(() {
        _breed = null;
        _bornOn = null;
        _photo = null;
        _byYears = false;
        _saving = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.failedToSave('$error')),
          backgroundColor: context.farm.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final breeds = [
      ...cowBreeds,
      if (_breed != null && !cowBreeds.contains(_breed)) _breed!,
    ];
    final age = ageOn(_bornOn, widget.clock());

    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? l.editCow : l.qaAddCow),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _photoBox(),
              if (_photo != null)
                Align(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _photo = null),
                    icon: const Icon(Icons.hide_image_outlined),
                    label: Text(l.removePhoto),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('cow-name'),
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l.cowName,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.pets),
                ),
                validator: (v) =>
                    v == null || v.trim().length < 2 ? l.enterName : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('cow-tag'),
                controller: _tag,
                decoration: InputDecoration(
                  labelText: l.tagNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.tag),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _breed,
                decoration: InputDecoration(
                  labelText: l.breed,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.layers),
                ),
                hint: Text(l.selectBreed),
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                items: [
                  for (final b in breeds)
                    DropdownMenuItem(value: b, child: Text(b)),
                ],
                onChanged: (v) => setState(() => _breed = v),
              ),
              const SizedBox(height: 16),
              if (_byYears)
                TextFormField(
                  key: const ValueKey('cow-age-years'),
                  controller: _ageYears,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.ageInYears,
                    helperText: l.ageEstimateNote,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.cake_outlined),
                  ),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return null;
                    final n = int.tryParse(t);
                    return n == null || n < 0 || n > 30
                        ? l.enterValidNumber
                        : null;
                  },
                )
              else
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: l.dateOfBirth,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.cake_outlined),
                  ),
                  child: InkWell(
                    key: const ValueKey('cow-born-on'),
                    onTap: _pickBirthDate,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _bornOn == null
                                ? l.pickDateOfBirth
                                : '${shortDate(_bornOn!)}'
                                      '${age == null ? '' : ' (${ageLabel(l, age)})'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: _bornOn == null
                                  ? context.farm.muted
                                  : null,
                            ),
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => setState(() => _byYears = !_byYears),
                  child: Text(_byYears ? l.useDateOfBirth : l.dontKnowDate),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon(Icons.save_rounded),
                  label: Text(_editing ? l.saveChanges : l.saveCow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoBox() {
    final photo = _photo;
    final exists = photo != null && File(photo).existsSync();
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.farm.muted),
        ),
        child: exists
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(photo), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 40),
                  const SizedBox(height: 8),
                  Text(context.l10n.tapToUploadPhoto),
                ],
              ),
      ),
    );
  }
}
