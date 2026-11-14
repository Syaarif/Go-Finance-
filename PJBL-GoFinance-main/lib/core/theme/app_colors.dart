import 'package:flutter/material.dart';

/// Design tokens warna resmi Go Finance (versi terang, nilai asli).
/// Dipertahankan agar kode lama tetap jalan. Untuk widget yang harus
/// mengikuti tema, pakai context.colors (lihat AppPalette di bawah).
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

/// Palet yang berganti otomatis mengikuti tema (terang/gelap).
/// Pemakaian di widget: context.colors.surface, context.colors.border, dst.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.primaryText,
    required this.brandBg,
    required this.deepGreen,
    required this.secondary,
    required this.canvas,
    required this.surface,
    required this.softSurface,
    required this.billHighlight,
    required this.border,
    required this.textPrimary,
    required this.mutedText,
    required this.disabledSurface,
    required this.negative,
    required this.warning,
    required this.warningText,
    required this.todayRing,
    required this.todayFill,
    required this.info,
    required this.cardShadow,
    required this.scrim,
  });

  final Color primary; // tombol / fill (teks di atasnya putih)
  final Color primaryText; // hijau untuk teks & ikon aksen
  final Color brandBg;
  final Color deepGreen; // judul / heading
  final Color secondary;
  final Color canvas;
  final Color surface;
  final Color softSurface;
  final Color billHighlight;
  final Color border;
  final Color textPrimary;
  final Color mutedText;
  final Color disabledSurface;
  final Color negative;
  final Color warning;
  final Color warningText;
  final Color todayRing;
  final Color todayFill;
  final Color info;
  final Color cardShadow;
  final Color scrim;

  /// Nilai sama persis dengan AppColors (tampilan terang tidak berubah).
  static const AppPalette light = AppPalette(
    primary: AppColors.primary,
    primaryText: AppColors.primary,
    brandBg: AppColors.brandBg,
    deepGreen: AppColors.deepGreen,
    secondary: AppColors.secondary,
    canvas: AppColors.canvas,
    surface: AppColors.surface,
    softSurface: AppColors.softSurface,
    billHighlight: AppColors.billHighlight,
    border: AppColors.border,
    textPrimary: AppColors.deepGreen,
    mutedText: AppColors.mutedText,
    disabledSurface: AppColors.disabledSurface,
    negative: AppColors.negative,
    warning: AppColors.warning,
    warningText: AppColors.warningText,
    todayRing: AppColors.todayRing,
    todayFill: AppColors.todayFill,
    info: AppColors.info,
    cardShadow: AppColors.cardShadow,
    scrim: AppColors.scrim,
  );

  static const AppPalette dark = AppPalette(
    primary: Color(0xFF347928),
    primaryText: Color(0xFF7FCB67),
    brandBg: Color(0xFF2A4A22),
    deepGreen: Color(0xFFC0EBA6),
    secondary: Color(0xFF8CBF7C),
    canvas: Color(0xFF101A0E),
    surface: Color(0xFF172414),
    softSurface: Color(0xFF1E2E1A),
    billHighlight: Color(0xFF233620),
    border: Color(0xFF2E4229),
    textPrimary: Color(0xFFE6EFE2),
    mutedText: Color(0xFF9DAE98),
    disabledSurface: Color(0xFF1F2B1C),
    negative: Color(0xFFE8837A),
    warning: Color(0xFFE7BD50),
    warningText: Color(0xFFE7BD50),
    todayRing: Color(0xFFD9A04A),
    todayFill: Color(0xFF2B2616),
    info: Color(0xFF7FAACB),
    cardShadow: Color(0x33000000),
    scrim: Color(0x99000000),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? primaryText,
    Color? brandBg,
    Color? deepGreen,
    Color? secondary,
    Color? canvas,
    Color? surface,
    Color? softSurface,
    Color? billHighlight,
    Color? border,
    Color? textPrimary,
    Color? mutedText,
    Color? disabledSurface,
    Color? negative,
    Color? warning,
    Color? warningText,
    Color? todayRing,
    Color? todayFill,
    Color? info,
    Color? cardShadow,
    Color? scrim,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      primaryText: primaryText ?? this.primaryText,
      brandBg: brandBg ?? this.brandBg,
      deepGreen: deepGreen ?? this.deepGreen,
      secondary: secondary ?? this.secondary,
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      softSurface: softSurface ?? this.softSurface,
      billHighlight: billHighlight ?? this.billHighlight,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      mutedText: mutedText ?? this.mutedText,
      disabledSurface: disabledSurface ?? this.disabledSurface,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
      todayRing: todayRing ?? this.todayRing,
      todayFill: todayFill ?? this.todayFill,
      info: info ?? this.info,
      cardShadow: cardShadow ?? this.cardShadow,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      brandBg: Color.lerp(brandBg, other.brandBg, t)!,
      deepGreen: Color.lerp(deepGreen, other.deepGreen, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      softSurface: Color.lerp(softSurface, other.softSurface, t)!,
      billHighlight: Color.lerp(billHighlight, other.billHighlight, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      disabledSurface: Color.lerp(disabledSurface, other.disabledSurface, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      todayRing: Color.lerp(todayRing, other.todayRing, t)!,
      todayFill: Color.lerp(todayFill, other.todayFill, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

/// Jalan pintas: context.colors.surface
extension AppPaletteContext on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}