import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 44,
        backgroundColor: SkillWaveAppColors.primary.withOpacity(0.1),
        child: const Icon(
          Icons.person,
          size: 54,
          color: SkillWaveAppColors.primary,
        ),
      ),
    );
  }
}
