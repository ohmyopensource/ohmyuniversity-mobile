import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String _heading = 'Outfit';
  static const String _body = 'Quicksand';

  static TextTheme get textTheme => const TextTheme(
    displayLarge:  TextStyle(fontFamily: _heading),
    displayMedium: TextStyle(fontFamily: _heading),
    displaySmall:  TextStyle(fontFamily: _heading),
    headlineLarge: TextStyle(fontFamily: _heading),
    headlineMedium: TextStyle(fontFamily: _heading),
    headlineSmall: TextStyle(fontFamily: _heading),
    titleLarge:    TextStyle(fontFamily: _heading),
    titleMedium:   TextStyle(fontFamily: _body),
    titleSmall:    TextStyle(fontFamily: _body),
    bodyLarge:     TextStyle(fontFamily: _body),
    bodyMedium:    TextStyle(fontFamily: _body),
    bodySmall:     TextStyle(fontFamily: _body),
    labelLarge:    TextStyle(fontFamily: _body),
    labelMedium:   TextStyle(fontFamily: _body),
    labelSmall:    TextStyle(fontFamily: _body),
  );
}