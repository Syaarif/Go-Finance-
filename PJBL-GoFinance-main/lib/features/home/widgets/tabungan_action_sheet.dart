import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// Modal interaktif untuk Menabung (Setor) atau Mencairkan (Tarik) Tabungan.
/// Tersimpan permanen ke SharedPreferences.
class TabunganActionSheet extends StatefulWidget {
  const TabunganActionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.canvas.withValues(alpha: 0),
      builder: (_) => const TabunganActionSheet(),
    );
  }

  @override
  State<TabunganActionSheet> createState() => _TabunganActionSheetState();
}

class _TabunganActionSheetState extends State<TabunganActionSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSetor = true; // true = Nabung (Setor), false = Tarik Tabungan
  final List<double> _presetNominals = [25000, 50000, 100000, 250000, 500000];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _setPreset(double val) {
    HapticFeedback.selectionClick();
    setState(() {
      _amountController.text = val.toInt().toString();
    });
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? context.colors.negative : Colors.red.shade700;
    final provider = context.read<TransactionProvider>();
    final rawText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final double? nominal = double.tryParse(rawText);

    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.validAmount,
            style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (_isSetor) {
      if (provider.saldoAktif < nominal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.insufficientActiveBalance(currencyFormat.format(nominal)),
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final ok =
          provider.setorTabungan(nominal, catatan: _noteController.text.trim());
      if (ok) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.depositSuccess(currencyFormat.format(nominal)),
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: context.colors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (provider.saldoTabungan < nominal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.insufficientSavingsBalance,
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final ok =
          provider.tarikTabungan(nominal, catatan: _noteController.text.trim());
      if (ok) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.withdrawSuccess(currencyFormat.format(nominal)),
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: context.colors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<TransactionProvider>();
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark ? context.colors.cardShadow : const Color(0x26000000),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        isDark ? context.colors.border : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSetor ? l10n.depositTitle : l10n.withdrawTitle,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.savingManageDescription,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 12,
                          color: isDark
                              ? context.colors.mutedText
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: isDark
                        ? context.colors.mutedText
                        : Colors.grey.shade500,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Toggle Tab Setor vs Tarik
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? context.colors.softSurface
                      : const Color(0xFFF0F5ED),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isSetor = true);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isSetor
                                ? context.colors.primary
                                : context.colors.canvas.withValues(alpha: 0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              l10n.depositTab,
                              style: GoogleFonts.instrumentSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _isSetor
                                    ? Colors.white
                                    : context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isSetor = false);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isSetor
                                ? (isDark
                                    ? context.colors.primary
                                    : context.colors.deepGreen)
                                : context.colors.canvas.withValues(alpha: 0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              l10n.withdrawTab,
                              style: GoogleFonts.instrumentSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: !_isSetor
                                    ? Colors.white
                                    : context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Info Saldo saat ini
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isDark ? context.colors.surface : const Color(0xFFF9FBF8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? context.colors.border
                        : const Color(0xFFE2EFE3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.activeBalance,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11,
                            color: isDark
                                ? context.colors.mutedText
                                : Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          currencyFormat.format(provider.saldoAktif),
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: isDark
                          ? context.colors.border
                          : const Color(0xFFD0E5D3),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.savingsBalance,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11,
                            color: isDark
                                ? context.colors.mutedText
                                : Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          currencyFormat.format(provider.saldoTabungan),
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? context.colors.primaryText
                                : const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Input Nominal
              Text(
                l10n.amountCurrency,
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.instrumentSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: GoogleFonts.instrumentSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: context.colors.primaryText,
                  ),
                  hintText: '0',
                  filled: true,
                  fillColor: isDark
                      ? context.colors.softSurface
                      : const Color(0xFFF7FBF8),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark
                          ? context.colors.border
                          : const Color(0xFFD6EADA),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark
                          ? context.colors.border
                          : const Color(0xFFD6EADA),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Chip Pilihan Nominal Cepat
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _presetNominals.map((val) {
                    final label =
                        currencyFormat.format(val).replaceAll(',00', '');
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(label),
                        labelStyle: GoogleFonts.instrumentSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                        backgroundColor: isDark
                            ? context.colors.softSurface
                            : const Color(0xFFEFF7EE),
                        side: BorderSide(
                          color: isDark
                              ? context.colors.border
                              : const Color(0xFFCBE5CB),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () => _setPreset(val),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 14),

              // Catatan / Tujuan
              Text(
                l10n.optionalPurpose,
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText:
                      _isSetor ? l10n.depositExample : l10n.withdrawExample,
                  hintStyle: GoogleFonts.instrumentSans(
                    fontSize: 13,
                    color: isDark
                        ? context.colors.mutedText
                        : Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? context.colors.softSurface
                      : const Color(0xFFF7FBF8),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? context.colors.border
                          : const Color(0xFFE0EFE4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? context.colors.border
                          : const Color(0xFFE0EFE4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Tombol Konfirmasi
              ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(
                  _isSetor
                      ? Icons.savings_rounded
                      : Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  _isSetor ? l10n.savePermanently : l10n.withdrawToActive,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSetor || isDark
                      ? context.colors.primary
                      : context.colors.deepGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
