import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(),
        displayMedium: GoogleFonts.poppins(),
        displaySmall: GoogleFonts.poppins(),
        headlineLarge: GoogleFonts.poppins(),
        headlineMedium: GoogleFonts.poppins(),
        headlineSmall: GoogleFonts.poppins(),
        titleLarge: GoogleFonts.poppins(),
        titleMedium: GoogleFonts.poppins(),
        titleSmall: GoogleFonts.poppins(),
        bodyLarge: GoogleFonts.poppins(),
        bodyMedium: GoogleFonts.poppins(),
        bodySmall: GoogleFonts.poppins(),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
    );
  }
}
