import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class ChangePasswordHeaderText extends StatelessWidget {
  const ChangePasswordHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Change your password",
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: SkillWaveAppColors.primary,
      ),
    );
  }
}
