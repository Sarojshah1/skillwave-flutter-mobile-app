import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import '../styles/input_theme.dart';
import '../styles/button_theme.dart';
import '../styles/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: SkillWaveAppColors.primary,
  scaffoldBackgroundColor: SkillWaveAppColors.surface,

  colorScheme: ColorScheme.fromSeed(
    seedColor: SkillWaveAppColors.primary,
    brightness: Brightness.light,
    primary: SkillWaveAppColors.primary,
    secondary: SkillWaveAppColors.accent,
    background: SkillWaveAppColors.surface,
    surface: Colors.white,
    error: SkillWaveAppColors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
    onError: Colors.white,
  ),

  // Input fields
  inputDecorationTheme: buildInputTheme().copyWith(
    filled: true,
    fillColor: Colors.grey[200],
    hintStyle: const TextStyle(color: Colors.black54),
    labelStyle: const TextStyle(color: Colors.black87),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurple),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  // Text
  textTheme: skillWaveTextTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),

  // App bar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: SkillWaveAppColors.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),
);
