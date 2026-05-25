import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand palette
  static const antiFlashWhite = Color(0xFFF8FAFC);
  static const darkTeal = Color(0xFF0E3B43);
  static const pineBlue = Color(0xFF357266);
  static const amberFlame = Color(0xFFF5B700);
  static const slateDark = Color(0xFF0F172A);

  // Semantic aliases
  static const background = antiFlashWhite;
  static const primary = darkTeal;
  static const secondary = pineBlue;
  static const cta = amberFlame;
  static const textPrimary = slateDark;

  // Exam Status
  static const examPassed = Color(0xFF34A853);
  static const examFailed = Color(0xFFEA4335);
  static const examBooked = amberFlame;
  static const examPending = Color(0xFF9AA0A6);

  // Calendar Tags
  static const labelBlue = Color(0xFF4285F4);
  static const labelGreen = Color(0xFF34A853);
  static const labelYellow = amberFlame;
  static const labelRed = Color(0xFFEA4335);
  static const labelPurple = Color(0xFF9C27B0);
  static const labelOrange = Color(0xFFFF6D00);
}
