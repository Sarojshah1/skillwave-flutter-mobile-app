import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class EditProfileHeaderText extends StatelessWidget {
  const EditProfileHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Edit your profile",
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: SkillWaveAppColors.primary,
      ),
    );
  }
}
