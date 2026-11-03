import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/theme/app_colors.dart';

/// Design tokens tipografi Go Finance menggunakan Instrument Sans.
/// Nominal dan angka kalender memakai `FontFeature.tabularFigures()`.
class AppTextStyles {
  AppTextStyles._();

  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  // Judul halaman ("Kalender Tagihan")
  static TextStyle get pageTitle => GoogleFonts.instrumentSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        letterSpacing: -0.3,
      );

  // Header bulan kalender ("Oktober 2026")
  static TextStyle get calendarHeader => GoogleFonts.instrumentSans(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        letterSpacing: -0.2,
      );

  // Tanggal terpilih di sebelah header bulan ("· 20 Okt")
  static TextStyle get calendarSelectedSubtitle => GoogleFonts.instrumentSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
        fontFeatures: _tabular,
      );

  // Label hari Min..Sab
  static TextStyle get weekdayLabel => GoogleFonts.instrumentSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedText,
      );

  // Angka tanggal kalender biasa
  static TextStyle get calendarDay => GoogleFonts.instrumentSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.deepGreen,
        fontFeatures: _tabular,
      );

  // Angka tanggal kalender yang memiliki tagihan / hari ini / terpilih
  static TextStyle get calendarDayBold => GoogleFonts.instrumentSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        fontFeatures: _tabular,
      );

  static TextStyle get calendarDaySelected => GoogleFonts.instrumentSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.surface,
        fontFeatures: _tabular,
      );

  // Section header ("Tagihan Mendatang")
  static TextStyle get sectionTitle => GoogleFonts.instrumentSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        letterSpacing: -0.2,
      );

  // Link aksi kecil ("Lihat semua")
  static TextStyle get sectionAction => GoogleFonts.instrumentSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  // Kartu tagihan: nama tagihan
  static TextStyle get billName => GoogleFonts.instrumentSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
      );

  // Kartu tagihan: nominal ("Rp 300.000") dengan tabularFigures
  static TextStyle get billAmount => GoogleFonts.instrumentSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        fontFeatures: _tabular,
      );

  // Kartu tagihan: jatuh tempo & sisa hari
  static TextStyle get billMeta => GoogleFonts.instrumentSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        fontFeatures: _tabular,
      );

  static TextStyle get billRemainingDays => GoogleFonts.instrumentSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        fontFeatures: _tabular,
      );

  // Badge status PENDING / OVERDUE
  static TextStyle badgeStatus(Color color) => GoogleFonts.instrumentSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.3,
      );

  // Tombol kecil di dalam kartu ("Bayar sekarang")
  static TextStyle get cardActionButton => GoogleFonts.instrumentSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
      );

  // Teks catatan bawah & empty state
  static TextStyle get footnote => GoogleFonts.instrumentSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.mutedText,
      );

  // Bottom sheet & Form
  static TextStyle get sheetTitle => GoogleFonts.instrumentSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
      );

  static TextStyle get fieldLabel => GoogleFonts.instrumentSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
      );

  static TextStyle get inputText => GoogleFonts.instrumentSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.deepGreen,
      );

  static TextStyle get nominalInputText => GoogleFonts.instrumentSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        fontFeatures: _tabular,
      );

  static TextStyle get inputHint => GoogleFonts.instrumentSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
      );

  static TextStyle get errorText => GoogleFonts.instrumentSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.negative,
      );

  static TextStyle get primaryButton => GoogleFonts.instrumentSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.surface,
      );

  // Bottom Navigation
  static TextStyle navLabel({required bool isActive}) =>
      GoogleFonts.instrumentSans(
        fontSize: 11,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        color: isActive ? AppColors.primary : AppColors.mutedText,
      );

  static TextStyle get scanLabel => GoogleFonts.instrumentSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.surface,
      );
}

