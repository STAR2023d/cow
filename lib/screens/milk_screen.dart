import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

class MilkEntryScreen extends StatefulWidget {
  final AppDatabase db;
  const MilkEntryScreen({super.key, required this.db});

  @override
  State<MilkEntryScreen> createState() => _MilkEntryScreenState();
}

class _MilkEntryScreenState extends State<MilkEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litresController = TextEditingController();
  final _priceController = TextEditingController(text: '50');
  DateTime _selectedDate = DateTime.now();

  double get _cashPreview {
    final litres = double.tryParse(_litresController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 50;
    return litres * price;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
    print('date selected');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.db.insertMilkRecord(
      MilkRecordsCompanion.insert(
        date: _selectedDate,
        litres: double.parse(_litresController.text),
        pricePerLitre: Value(double.parse(_priceController.text)),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Milk record saved')));
    _litresController.clear();
    setState(() {});

    print('entry successful');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Milk Record')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _litresController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Litres'),
                validator: (v) => (double.tryParse(v ?? '') == null)
                    ? 'Enter a valid number'
                    : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Price per litre'),
                validator: (v) => (double.tryParse(v ?? '') == null)
                    ? 'Enter a valid number'
                    : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Text(
                'Cash: ${_cashPreview.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
