import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  Future<void> _showImageSourceSelector(BuildContext context) async {
    final mountedContext = context;
    showModalBottomSheet(
      context: mountedContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final bloc = context.read<ProfileBloc>();
    try {
      final XFile? imageFile = await picker.pickImage(source: source);
      print("Image picked: ${imageFile?.path}");

      if (imageFile != null) {
        print("Dispatching UpdateProfilePicture event");
        bloc.add(UpdateProfilePicture(File(imageFile.path)));
      } else {
        print("Image picking cancelled");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode
          ? SkillWaveAppColors.blue_alpha
          : SkillWaveAppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _showImageSourceSelector(context),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(
                    "http://10.0.2.2:3000/profile/${user.profilePicture}",
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${user.enrolledCourses.length} Enrolled',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${user.certificates.length} Certificates',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
