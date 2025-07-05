import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class ChangePasswordHeaderIcon extends StatelessWidget {
  const ChangePasswordHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.lock_reset,
        size: 64,
        color: SkillWaveAppColors.primary,
      ),
    );
  }
}
