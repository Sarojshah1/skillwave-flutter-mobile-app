import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import '../styles/text_theme.dart';
import '../styles/input_theme.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: SkillWaveAppColors.textPrimary,
  primaryColor: SkillWaveAppColors.primary,

  colorScheme: ColorScheme.fromSeed(
    seedColor: SkillWaveAppColors.primary,
    brightness: Brightness.dark,
    primary: SkillWaveAppColors.primary,
    secondary: SkillWaveAppColors.accent,
    background: SkillWaveAppColors.textPrimary,
    surface: Colors.grey[850]!,
    error: SkillWaveAppColors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
  ),

  // Input fields
  inputDecorationTheme: buildInputTheme().copyWith(
    filled: true,
    fillColor: Colors.grey[900],
    hintStyle: const TextStyle(color: Colors.white70),
    labelStyle: const TextStyle(color: Colors.white),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white38),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  // Text
  textTheme: skillWaveTextTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),

  // App bar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Elevated buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: SkillWaveAppColors.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),
);
