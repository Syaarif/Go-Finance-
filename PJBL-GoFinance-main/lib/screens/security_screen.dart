import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/profile_screen.dart';

/// Halaman Keamanan — UI ubah password (validasi lokal saja).
/// Tidak mengubah password autentikasi sungguhan.
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  // Dummy password lama untuk simulasi validasi
  static const String _dummyOldPassword = 'password123';

  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password berhasil diubah (simulasi)'),
        backgroundColor: const Color(0xFF347928),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    _oldController.clear();
    _newController.clear();
    _confirmController.clear();
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: ProfileColors.darkGreen,
          ),
        ),
      );

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    OutlineInputBorder border(Color? color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: color == null ? BorderSide.none : BorderSide(color: color),
        );

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.instrumentSans(fontSize: 14, color: ProfileColors.darkGreen),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: ProfileColors.cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border(null),
        enabledBorder: border(null),
        focusedBorder: border(ProfileColors.darkGreen),
        errorBorder: border(ProfileColors.redAccent),
        focusedErrorBorder: border(ProfileColors.redAccent),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: ProfileColors.textGrey,
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          color: ProfileColors.darkGreen,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Keamanan',
          style: GoogleFonts.instrumentSans(
            color: ProfileColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Password',
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: ProfileColors.darkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gunakan minimal 8 karakter dengan kombinasi huruf dan angka.',
                style: GoogleFonts.instrumentSans(fontSize: 13, color: ProfileColors.textGrey),
              ),
              const SizedBox(height: 24),

              _label('Password lama'),
              _passwordField(
                controller: _oldController,
                hint: 'Masukkan password lama',
                obscure: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password lama wajib diisi';
                  if (v != _dummyOldPassword) return 'Password lama salah';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _label('Password baru'),
              _passwordField(
                controller: _newController,
                hint: 'Masukkan password baru',
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password baru wajib diisi';
                  if (v.length < 8) return 'Password minimal 8 karakter';
                  if (!RegExp(r'[A-Za-z]').hasMatch(v) || !RegExp(r'\d').hasMatch(v)) {
                    return 'Password harus mengandung huruf dan angka';
                  }
                  if (v == _oldController.text) {
                    return 'Password baru tidak boleh sama dengan password lama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _label('Konfirmasi password baru'),
              _passwordField(
                controller: _confirmController,
                hint: 'Ulangi password baru',
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                  if (v != _newController.text) return 'Konfirmasi password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Mode demo: password lama dummy adalah "$_dummyOldPassword".',
                style: GoogleFonts.instrumentSans(fontSize: 12, color: ProfileColors.textGrey),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProfileColors.darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Simpan password',
                    style: GoogleFonts.instrumentSans(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

