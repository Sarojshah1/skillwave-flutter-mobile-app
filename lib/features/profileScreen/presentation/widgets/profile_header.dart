
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDarkMode ? SkillWaveAppColors.blue_alpha:SkillWaveAppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: CachedNetworkImageProvider("http://10.0.2.2:3000/profile/${user.profilePicture}"),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text('${user.enrolledCourses.length} Enrolled', style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 16),
                    const Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text('${user.certificates.length} Certificates', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
