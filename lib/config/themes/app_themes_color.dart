import 'package:flutter/material.dart';

abstract final class SkillWaveAppColors {
  // === PRIMARY COLORS ===
  static const primary = Color.fromRGBO(22, 127, 113, 1);
  static const secondary = Color.fromRGBO(0, 145, 170, 1);
  static const accent = Color.fromRGBO(255, 203, 5, 1);
  static const blue_alpha= Color(0x334F46E5);
  static const purple_alpha= Color(0x334D4FCF);
  static const indigo_alpha= Color(0x3345A4F0);
  static const pink_alpha= Color(0x33EC4899);
  static const cyan_alpha=  Color(0x3350E3C2);

  // === TEXT COLORS ===
  static const textPrimary = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF6E6E73);
  static const textDisabled = Color(0xFFBDBDBD);
  static const textInverse = Colors.white;

  // === BACKGROUND COLORS ===
  static const background = Color(0xFFF9F9F9);
  static const surface = Color(0xFFFFFFFF);
  static const lightGreyBackground = Color(0xFFF1F1F1);
  static const lightBlueBackground = Color(0xFFF8FAFC);
  static const lightBlueAccent = Color(0xFFE0F2FE);

  // === BORDER COLORS ===
  static const border = Color(0xFFE0E0E0);
  static const inputBorder = Color(0xFFD1D1D6);

  // === STATUS COLORS ===
  static const red = Color.fromRGBO(214, 10, 11, 1);
  static const green = Color(0xFF4CAF50);
  static const yellow = Color(0xFFFFC107);
  static const blue = Color(0xFF2196F3);
  static const error = Color(0xFFFF3B30);
  static const success = Color(0xFF00C853);
  static const warning = Color(0xFFFF9800);
  static const info = Color(0xFF0288D1);

  // === SHADOWS ===
  static const shadow = Color.fromRGBO(0, 0, 0, 0.08);

  // === OTHERS ===
  static const lightBlue = Color.fromRGBO(213, 226, 245, 1);
  static const grey = Color.fromRGBO(145, 145, 145, 1);

  // === TEXT SPECIFIC ===
  static const headingText = Color(0xFF1D4ED8);
  static const bodyText = Color(0xFF4B5563); // gray-600

  // === GRADIENTS ===
  static const backgroundGradient = LinearGradient(
    colors: [lightBlueBackground, lightBlueAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient_2=LinearGradient(
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFE0F2FE),
      Color(0xFFEEF2FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


  static final Gradient blueGradient = const LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final Gradient purplePinkGradient = const LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const badgeGradient = LinearGradient(
    colors: [Color(0xFFDBEAFE), Color(0xFFE9D5FF)],
  );

  static const visitUsGradient = [Colors.blue, Colors.cyan];
  static const callUsGradient = [Colors.green, Colors.teal];
  static const emailUsGradient = [Colors.purple, Colors.pink];
  static const officeHoursGradient = [Colors.orange, Colors.red];
}
