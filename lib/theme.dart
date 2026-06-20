import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);

  static ThemeData get theme {
    return ThemeData(
      colorSchemeSeed: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF8F9FE),
      textTheme: GoogleFonts.poppinsTextTheme(),

    );
  }
}