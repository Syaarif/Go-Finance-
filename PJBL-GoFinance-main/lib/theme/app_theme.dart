import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:go_finance/core/theme/app_colors.dart';

class AppTheme {
  // Color constants (accessible as AppTheme.xxx)
  static const Color backgroundGreen = Color(0xFFC0EBA6);
  static const Color primaryDarkGreen = Color(0xFF234D1C);
  static const Color primaryGreen = Color(0xFF347928);
  static const Color white = Colors.white;
  static const Color textGray = Color(0xFF666666);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF347928),
        ),
        scaffoldBackgroundColor: const Color(0xFFC0EBA6),
        textTheme: GoogleFonts.instrumentSansTextTheme(),
      );
}
