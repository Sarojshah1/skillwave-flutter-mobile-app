import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
const TextTheme skillWaveTextTheme = TextTheme(
  headlineLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  bodyMedium: TextStyle(
    fontSize: 16,
    color: SkillWaveAppColors.textSecondary,
  ),
  labelSmall: TextStyle(
    fontSize: 12,
    color: SkillWaveAppColors.grey,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: SkillWaveAppColors.surface,
  ),
);
