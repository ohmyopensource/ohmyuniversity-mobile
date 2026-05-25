import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final color = brightness == Brightness.dark ? Colors.white : Colors.black;

    final quicksand = GoogleFonts.quicksandTextTheme().apply(
      bodyColor: color,
      displayColor: color,
    );

    return quicksand.copyWith(
      displayLarge: GoogleFonts.outfit(textStyle: quicksand.displayLarge),
      displayMedium: GoogleFonts.outfit(textStyle: quicksand.displayMedium),
      displaySmall: GoogleFonts.outfit(textStyle: quicksand.displaySmall),

      headlineLarge: GoogleFonts.outfit(textStyle: quicksand.headlineLarge),
      headlineMedium: GoogleFonts.outfit(textStyle: quicksand.headlineMedium),
      headlineSmall: GoogleFonts.outfit(textStyle: quicksand.headlineSmall),

      titleLarge: GoogleFonts.outfit(textStyle: quicksand.titleLarge),
      titleMedium: GoogleFonts.outfit(textStyle: quicksand.titleMedium),
      titleSmall: GoogleFonts.outfit(textStyle: quicksand.titleSmall),
    );
  }
}
