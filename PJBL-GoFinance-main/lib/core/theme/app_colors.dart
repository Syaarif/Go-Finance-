import 'package:flutter/material.dart';

/// Design tokens warna resmi Go Finance.
/// Seluruh komponen wajib mengambil warna dari class ini (tanpa hardcode).
class AppColors {
  AppColors._();

  // Brand & Primary
  static const Color primary = Color(0xFF347928);
  static const Color brandBg = Color(0xFFC0EBA6);
  static const Color deepGreen = Color(0xFF234D1C);
  static const Color secondary = Color(0xFF42683A);

  // Surfaces & Borders
  static const Color canvas = Color(0xFFF5F9F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color softSurface = Color(0xFFEDF5E8);
  static const Color billHighlight = Color(0xFFE3F1DB);
  static const Color border = Color(0xFFD7E5D1);

  // Text & Neutral
  static const Color mutedText = Color(0xFF82917D);
  static const Color disabledSurface = Color(0xFFE4ECE0);

  // Semantic Status
  static const Color negative = Color(0xFFD9655B);
  static const Color warning = Color(0xFFE7BD50);
  static const Color warningText = Color(0xFFC89222);
  static const Color todayRing = Color(0xFFC28B38);
  static const Color todayFill = Color(0xFFF8F4E6);
  static const Color info = Color(0xFF6694B5);

  // Shadow sangat ringan (tanpa glow/gradient)
  static const Color cardShadow = Color(0x0A234D1C);
  static const Color scrim = Color(0x4D000000);
  static const Color transparent = Colors.transparent;

  // Legacy / Alias tokens (dari app_theme.dart)
  static const Color backgroundGreen = Color(0xFFC0EBA6);
  static const Color primaryDarkGreen = Color(0xFF234D1C);
  static const Color primaryGreen = Color(0xFF347928);
  static const Color textPlaceholder = Color(0x80000000);
  static const Color white = Colors.white;
  static const Color textGray = Color(0xFF666666);
}

