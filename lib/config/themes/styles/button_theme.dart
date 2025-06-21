import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: SkillWaveAppColors.primary,
    foregroundColor: SkillWaveAppColors.surface, // Ensures text/icon color is applied
    textStyle: textButtonStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  ),
);

final textButtonStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: SkillWaveAppColors.surface,
);
