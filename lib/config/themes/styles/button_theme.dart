import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'text_theme.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: SkillWaveAppColors.primary,
    textStyle: textButtonStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

final textButtonStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: SkillWaveAppColors.surface,
);