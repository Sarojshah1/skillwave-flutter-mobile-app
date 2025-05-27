import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

extension SkillWaveTextTheme on TextTheme {
  TextStyle get heading1 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: SkillWaveAppColors.textPrimary,
  );

  TextStyle get body => const TextStyle(
    fontSize: 16,
    color: SkillWaveAppColors.textSecondary,
  );

  TextStyle get caption => const TextStyle(
    fontSize: 12,
    color: SkillWaveAppColors.grey,
  );

  TextStyle get button => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: SkillWaveAppColors.textInverse,
  );
}