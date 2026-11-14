import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;

  const ImageSourceSheet({super.key, required this.onSourceSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              context.l10n.choosePhoto,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: context.farm.info),
            title: Text(context.l10n.fromGallery),
            onTap: () {
              Navigator.pop(context); // Close the sheet
              onSourceSelected(ImageSource.gallery); // Return choice
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: context.farm.good),
            title: Text(context.l10n.takePhoto),
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
