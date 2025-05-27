import 'package:flutter/material.dart';

abstract final class SkillWaveAppColors {
  // === PRIMARY COLORS ===
  static const primary = Color.fromRGBO(22, 127, 113, 1);
  static const secondary = Color.fromRGBO(0, 145, 170, 1);
  static const accent = Color.fromRGBO(255, 203, 5, 1); 

  // === TEXT COLORS ===
  static const textPrimary = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF6E6E73);
  static const textDisabled = Color(0xFFBDBDBD);
  static const textInverse = Colors.white;

  // === BACKGROUND COLORS ===
  static const background = Color(0xFFF9F9F9);
  static const surface = Color(0xFFFFFFFF);
  static const lightGreyBackground = Color(0xFFF1F1F1);

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
}
