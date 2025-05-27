import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

InputDecorationTheme buildInputTheme() => InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: SkillWaveAppColors.grey),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: SkillWaveAppColors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: SkillWaveAppColors.primary),
  ),
  filled: true,
  fillColor: SkillWaveAppColors.grey,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);