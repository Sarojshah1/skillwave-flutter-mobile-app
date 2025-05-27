import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import '../styles/text_theme.dart';
import '../styles/input_theme.dart';
import '../styles/button_theme.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: SkillWaveAppColors.primary,
  scaffoldBackgroundColor: SkillWaveAppColors.textPrimary,
  inputDecorationTheme: buildInputTheme(),
  textTheme: skillWaveTextTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: SkillWaveAppColors.primary,
    primary: SkillWaveAppColors.primary,
    secondary: SkillWaveAppColors.accent,
    error: SkillWaveAppColors.red,
  ),
  useMaterial3: true,
);
