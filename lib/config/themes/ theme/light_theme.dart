import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import '../styles/input_theme.dart';
import '../styles/button_theme.dart';
import '../styles/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: SkillWaveAppColors.primary,
  scaffoldBackgroundColor: SkillWaveAppColors.surface,
  inputDecorationTheme: buildInputTheme(),
  textTheme: skillWaveTextTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: SkillWaveAppColors.primary,
    primary: SkillWaveAppColors.primary,
    secondary: SkillWaveAppColors.accent,
    error: SkillWaveAppColors.red,
  ),
  useMaterial3: true,
);