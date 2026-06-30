import 'dart:io';
import 'package:cow/abstract/image_source.dart'; // abstracted file path
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/daily_record.dart';
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
      Text("couldn't pick image");
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
        final insertedId = await db.insertCow(newCow);

        // Guard clause to ensure the widget is still in the UI tree
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_nameController.text} saved successfully (ID: $insertedId)!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Optional: Clear form or pop screen here
        _formKey.currentState!.reset();
        _nameController.clear();
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save data: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainDashboard.primaryNavy,
      appBar: AppBar(title: const Text('Add Cow'), centerTitle: true),
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
                    color: MainDashboard.cardNavy,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to Upload Cow Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Tag Input Field
              TextFormField(
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Tag Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                onSaved: (value) =>
                    _tag = value?.isEmpty == true ? null : value,
              ),
              const SizedBox(height: 16),

              // Name Input Field
              TextFormField(
                cursorColor: Colors.white,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cow Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // Breed Input Field
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.layers),
                ),
                // Displays the current selected breed value (initialize _breed as a String? variable)
                initialValue: _breed,
                hint: const Text('Select cow breed'),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down_rounded, size: 28),
                borderRadius: BorderRadius.circular(12),
                // List of different major cattle breeds
                items: const [
                  DropdownMenuItem(value: 'Holstein', child: Text('Holstein')),
                  DropdownMenuItem(value: 'Jersey', child: Text('Jersey')),
                  DropdownMenuItem(value: 'Ayrshire', child: Text('Ayrshire')),
                  DropdownMenuItem(value: 'Guernsey', child: Text('Guernsey')),
                  DropdownMenuItem(
                    value: 'Brown Swiss',
                    child: Text('Brown Swiss'),
                  ),
                  DropdownMenuItem(value: 'Brahman', child: Text('Brahman')),
                  DropdownMenuItem(value: 'Angus', child: Text('Angus')),
                  DropdownMenuItem(value: 'Hereford', child: Text('Hereford')),
                ],
                onSaved: (value) =>
                    _breed = value?.isEmpty == true ? null : value,
                onChanged: (String? value) {},
              ),
              const SizedBox(height: 16),

              // Age Input Field
              TextFormField(
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age (Years)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      num.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _age = (value != null && value.isNotEmpty)
                    ? int.tryParse(value)
                    : null,
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: MainDashboard.cardNavy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Cow',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(26, 220, 26, 26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
