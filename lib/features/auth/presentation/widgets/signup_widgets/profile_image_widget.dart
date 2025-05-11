import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillwave/config/constants/app_assets.dart';

class ProfileImageWidget extends StatelessWidget {
  final File? profileImage;
  final Function(File) onImageSelected;

  const ProfileImageWidget({required this.profileImage, required this.onImageSelected, Key? key}) : super(key: key);

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      onImageSelected(File(pickedImage.path));
      Navigator.pop(context);
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera, color: Colors.blueAccent),
              title: Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => _pickImage(ImageSource.camera, context),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blueAccent),
              title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => _pickImage(ImageSource.gallery, context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerOptions(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : AssetImage(SkillWaveAppAssets.user) as ImageProvider,
            ),
          ),
          if (profileImage == null)
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add_a_photo, color: Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }
}

