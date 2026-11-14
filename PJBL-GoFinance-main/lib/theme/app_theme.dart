import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_finance/core/theme/app_colors.dart';

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
        textTheme: ThemeData().textTheme.apply(
              fontFamily: GoogleFonts.instrumentSans().fontFamily,
            ),
        extensions: const [AppPalette.light],
      );

  static ThemeData get darkTheme {
    const p = AppPalette.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF347928),
        brightness: Brightness.dark,
      ).copyWith(
        primary: p.primaryText,
        onPrimary: p.canvas,
        surface: p.surface,
        onSurface: p.textPrimary,
        outline: p.border,
        error: p.negative,
      ),
      scaffoldBackgroundColor: p.canvas,
      dividerColor: p.border,
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
            fontFamily: GoogleFonts.instrumentSans().fontFamily,
            bodyColor: p.textPrimary,
            displayColor: p.textPrimary,
          ),
      extensions: const [p],
    );
  }
}