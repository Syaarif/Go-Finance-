import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


import 'package:go_finance/features/transactions/providers/transaction_provider.dart';
import 'package:go_finance/theme/app_theme.dart';

/// Modal interaktif untuk Menabung (Setor) atau Mencairkan (Tarik) Tabungan.
/// Tersimpan permanen ke SharedPreferences.
class TabunganActionSheet extends StatefulWidget {
  const TabunganActionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
    final provider = context.read<TransactionProvider>();
    final rawText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final double? nominal = double.tryParse(rawText);

    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Masukkan nominal yang valid!',
            style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (_isSetor) {
      if (provider.saldoAktif < nominal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Saldo aktif tidak mencukupi untuk menabung ${currencyFormat.format(nominal)}!',
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final ok = provider.setorTabungan(nominal, catatan: _noteController.text.trim());
      if (ok) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🎉 Berhasil menabung ${currencyFormat.format(nominal)}! Saldo tersimpan permanen.',
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (provider.saldoTabungan < nominal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Saldo tabungan tidak mencukupi untuk ditarik!',
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final ok = provider.tarikTabungan(nominal, catatan: _noteController.text.trim());
      if (ok) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil mencairkan ${currencyFormat.format(nominal)} ke saldo aktif!',
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 30,
              offset: Offset(0, -10),
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
                    color: Colors.grey.shade300,
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
                        _isSetor ? 'Setor Tabungan' : 'Tarik Tabungan',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDarkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kelola uang tabunganmu secara nyata & persisten',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Toggle Tab Setor vs Tarik
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5ED),
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
                            color: _isSetor ? AppTheme.primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '+ Setor (Nabung)',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _isSetor ? Colors.white : AppTheme.primaryDarkGreen,
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
                            color: !_isSetor ? AppTheme.primaryDarkGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '- Tarik Tabungan',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: !_isSetor ? Colors.white : AppTheme.primaryDarkGreen,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBF8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2EFE3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo Aktif',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          currencyFormat.format(provider.saldoAktif),
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDarkGreen,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: const Color(0xFFD0E5D3),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Saldo Tabungan',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          currencyFormat.format(provider.saldoTabungan),
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32),
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
                'Nominal (Rp)',
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDarkGreen,
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
                  color: AppTheme.primaryDarkGreen,
                ),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: GoogleFonts.instrumentSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                  ),
                  hintText: '0',
                  filled: true,
                  fillColor: const Color(0xFFF7FBF8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD6EADA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD6EADA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Chip Pilihan Nominal Cepat
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _presetNominals.map((val) {
                    final label = currencyFormat.format(val).replaceAll(',00', '');
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(label),
                        labelStyle: GoogleFonts.instrumentSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDarkGreen,
                        ),
                        backgroundColor: const Color(0xFFEFF7EE),
                        side: const BorderSide(color: Color(0xFFCBE5CB)),
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
                'Tujuan / Catatan (Opsional)',
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDarkGreen,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: _isSetor ? 'Contoh: Beli laptop, Dana darurat' : 'Contoh: Keperluan mendesak',
                  hintStyle: GoogleFonts.instrumentSans(fontSize: 13, color: Colors.grey.shade500),
                  filled: true,
                  fillColor: const Color(0xFFF7FBF8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0EFE4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0EFE4)),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Tombol Konfirmasi
              ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(
                  _isSetor ? Icons.savings_rounded : Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  _isSetor ? 'Simpan ke Tabungan (Tersimpan Permanen)' : 'Cairkan ke Saldo Aktif',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSetor ? AppTheme.primaryGreen : AppTheme.primaryDarkGreen,
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
