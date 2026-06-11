import 'package:flutter/material.dart';

abstract final class AppColors {
  // @TODO: Delete START =========== Legacy Brand Palette ===========
  // Brand Palette
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
  // @TODO: Delete END =========== Legacy Brand Palette ===========

  // Design System - Light

  // Primary
  static const colorPrimaryLight = Color(0xFFa8d8f0);
  static const colorPrimaryDark = Color(0xFF5ba8d4);
  static const colorPrimaryText = Color(0xFF1a3a4a);
  static const colorPrimaryShadow = Color(0x595ba8d4);
  static const colorPrimaryFocus = Color(0x805ba8d4);

  // Secondary
  static const colorSecondaryLight = Color(0xFFd4c5f0);
  static const colorSecondaryDark = Color(0xFF9b82d4);
  static const colorSecondaryText = Color(0xFF2a1a4a);
  static const colorSecondaryShadow = Color(0x599b82d4);
  static const colorSecondaryFocus = Color(0x809b82d4);

  // Tertiary
  static const colorTertiaryLight = Color(0xFFf0c5d4);
  static const colorTertiaryDark = Color(0xFFd47a9b);
  static const colorTertiaryText = Color(0xFF4a1a2a);
  static const colorTertiaryShadow = Color(0x59d47a9b);
  static const colorTertiaryFocus = Color(0x80d47a9b);

  // Success
  static const colorSuccessLight = Color(0xFFb8f0d4);
  static const colorSuccessDark = Color(0xFF5dc490);
  static const colorSuccessText = Color(0xFF1a4a30);
  static const colorSuccessShadow = Color(0x595dc490);
  static const colorSuccessFocus = Color(0x805dc490);

  // Warning
  static const colorWarningLight = Color(0xFFf0dca8);
  static const colorWarningDark = Color(0xFFd4a84a);
  static const colorWarningText = Color(0xFF4a2e00);
  static const colorWarningShadow = Color(0x59d4a84a);
  static const colorWarningFocus = Color(0x80d4a84a);

  // Error
  static const colorErrorLight = Color(0xFFf0b8b8);
  static const colorErrorDark = Color(0xFFd45c5c);
  static const colorErrorText = Color(0xFF4a1010);
  static const colorErrorShadow = Color(0x59d45c5c);
  static const colorErrorFocus = Color(0x80d45c5c);

  // Info
  static const colorInfoLight = Color(0xFFb8c8f0);
  static const colorInfoDark = Color(0xFF5c7cd4);
  static const colorInfoText = Color(0xFF1a2a4a);
  static const colorInfoShadow = Color(0x595c7cd4);
  static const colorInfoFocus = Color(0x805c7cd4);

  // Neutral
  static const colorNeutral100 = Color(0xFFf4f6f9);
  static const colorNeutral200 = Color(0xFFe2e5ea);
  static const colorNeutral300 = Color(0xFFc8cdd8);
  static const colorNeutral400 = Color(0xFF9aa0ad);
  static const colorNeutral500 = Color(0xFF555e6e);
  static const colorNeutral600 = Color(0xFF3a404e);
  static const colorNeutral900 = Color(0xFF1a2030);

  // Design System - Dark
  static const darkColorPrimaryLight = Color(0xFF3a7fa8);
  static const darkColorPrimaryDark = Color(0xFF1a4f6e);
  static const darkColorPrimaryText = Color(0xFFd8f0ff);
  static const darkColorPrimaryShadow = Color(0x663a7fa8);
  static const darkColorPrimaryFocus = Color(0x8c3a7fa8);

  static const darkColorSecondaryLight = Color(0xFF6a52a8);
  static const darkColorSecondaryDark = Color(0xFF3a2a6e);
  static const darkColorSecondaryText = Color(0xFFead8ff);
  static const darkColorSecondaryShadow = Color(0x666a52a8);
  static const darkColorSecondaryFocus = Color(0x8c6a52a8);

  static const darkColorTertiaryLight = Color(0xFFa85278);
  static const darkColorTertiaryDark = Color(0xFF6e2a48);
  static const darkColorTertiaryText = Color(0xFFffd8ea);
  static const darkColorTertiaryShadow = Color(0x66a85278);
  static const darkColorTertiaryFocus = Color(0x8ca85278);

  static const darkColorSuccessLight = Color(0xFF3a9468);
  static const darkColorSuccessDark = Color(0xFF1a5a3a);
  static const darkColorSuccessText = Color(0xFFd8ffe8);
  static const darkColorSuccessShadow = Color(0x663a9468);
  static const darkColorSuccessFocus = Color(0x8c3a9468);

  static const darkColorWarningLight = Color(0xFFa87e2a);
  static const darkColorWarningDark = Color(0xFF6e4e00);
  static const darkColorWarningText = Color(0xFFfff0c8);
  static const darkColorWarningShadow = Color(0x66a87e2a);
  static const darkColorWarningFocus = Color(0x8ca87e2a);

  static const darkColorErrorLight = Color(0xFFa83a3a);
  static const darkColorErrorDark = Color(0xFF6e1a1a);
  static const darkColorErrorText = Color(0xFFffd8d8);
  static const darkColorErrorShadow = Color(0x66a83a3a);
  static const darkColorErrorFocus = Color(0x8ca83a3a);

  static const darkColorInfoLight = Color(0xFF3a5ca8);
  static const darkColorInfoDark = Color(0xFF1a3070);
  static const darkColorInfoText = Color(0xFFd8e8ff);
  static const darkColorInfoShadow = Color(0x663a5ca8);
  static const darkColorInfoFocus = Color(0x8c3a5ca8);

  static const darkColorNeutral100 = Color(0xFF1e2230);
  static const darkColorNeutral200 = Color(0xFF2a2e38);
  static const darkColorNeutral300 = Color(0xFF3a404e);
  static const darkColorNeutral400 = Color(0xFF4a5060);
  static const darkColorNeutral500 = Color(0xFFa8b0c0);
  static const darkColorNeutral600 = Color(0xFFc8d0e0);
  static const darkColorNeutral900 = Color(0xFFf0f4ff);

  // Border Radius
  static const radiusSm = 6.0;
  static const radiusMd = 10.0;
  static const radiusLg = 16.0;
  static const radiusFull = 9999.0;
}
