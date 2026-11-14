import 'package:cow/l10n/language_controller.dart';
import 'dart:io';
import 'package:cow/abstract/image_source.dart'; // abstracted file path
import 'package:cow/database/app_database.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CowAdd extends StatefulWidget {
  const CowAdd({super.key});

  @override
  State<CowAdd> createState() => _CowAddState();
}

class _CowAddState extends State<CowAdd> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture text input
  final _nameController = TextEditingController();

  String? _tag;
  String? _breed;
  int? _age;

  File? _selectedImage; // Stores the chosen image file
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
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
      builder: (context) => ImageSourceSheet(
        onSourceSelected: (source) {
          _getImage(source);
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newCow = CowCompanion(
        name: drift.Value(_nameController.text),
        tag: drift.Value(_tag),
        breed: drift.Value(_breed),
        age: drift.Value(_age),
        imagePath: drift.Value(_selectedImage?.path),
      );

      //CALL DATABASE INSTANCE
      final db = Provider.of<AppDatabase>(context, listen: false);
      //ADD NEW COW
      try {
        await db.insertCow(newCow);

        // Guard clause to ensure the widget is still in the UI tree
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.cowSaved(_nameController.text)),
            backgroundColor: context.farm.good,
          ),
        );

        // Optional: Clear form or pop screen here
        _formKey.currentState!.reset();
        _nameController.clear();
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.failedToSave('$error')),
            backgroundColor: context.farm.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.qaAddCow), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Selection Box
              GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.farm.muted),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              context.l10n.tapToUploadPhoto,
                              style: TextStyle(),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Tag Input Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: context.l10n.tagNumber,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                onSaved: (value) =>
                    _tag = value?.isEmpty == true ? null : value,
              ),
              const SizedBox(height: 16),

              // Name Input Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.cowName,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) =>
                    value!.isEmpty ? context.l10n.enterName : null,
              ),
              const SizedBox(height: 16),

              // Breed Input Field
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: context.l10n.breed,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.layers),
                ),
                // Displays the current selected breed value (initialize _breed as a String? variable)
                initialValue: _breed,
                hint: Text(context.l10n.selectBreed),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down_rounded, size: 28),
                borderRadius: BorderRadius.circular(12),
                // List of different major cattle breeds
                items: const [
                  DropdownMenuItem(value: 'Holstein', child: Text('Holstein')),
                  DropdownMenuItem(value: 'Jersey', child: Text('Jersey')),
                  DropdownMenuItem(value: 'Ayrshire', child: Text('Ayrshire')),
                  DropdownMenuItem(value: 'Friesien', child: Text('Friesien')),
                ],
                onSaved: (value) =>
                    _breed = value?.isEmpty == true ? null : value,
                onChanged: (String? value) {},
              ),
              const SizedBox(height: 16),

              // Age Input Field
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.l10n.ageInYears,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      num.tryParse(value) == null) {
                    return context.l10n.enterValidNumber;
                  }
                  return null;
                },
                onSaved: (value) => _age = (value != null && value.isNotEmpty)
                    ? int.tryParse(value)
                    : null,
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _submitForm,
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
                  label: Text(context.l10n.saveCow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
