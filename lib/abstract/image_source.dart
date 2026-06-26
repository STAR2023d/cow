import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 

class ImageSourceSheet extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;

  const ImageSourceSheet({
    super.key,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Choose Cow Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.blue),
            title: const Text('Upload from Gallery'),
            onTap: () {
              Navigator.pop(context); // Close the sheet
              onSourceSelected(ImageSource.gallery); // Return choice
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.green),
            title: const Text('Take a New Photo'),
            onTap: () {
              Navigator.pop(context); // Close the sheet
              onSourceSelected(ImageSource.camera); // Return choice
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
