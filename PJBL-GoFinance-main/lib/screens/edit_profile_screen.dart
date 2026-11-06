import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/screens/profile_screen.dart';

/// Halaman Edit Profil (frontend only, dummy data).
/// Mengembalikan username baru (String) melalui `Navigator.pop`.
class EditProfileScreen extends StatefulWidget {
  final String currentUsername;
  final String currentEmail;

  const EditProfileScreen({
    super.key,
    required this.currentUsername,
    required this.currentEmail,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    _usernameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  String get _initial {
    final text = _usernameController.text.trim();
    return text.isNotEmpty ? text[0].toUpperCase() : '?';
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Simulasi ganti foto profil (tanpa package image_picker)
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        Widget option(IconData icon, String label) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: RoundedSquareIcon(
                icon: icon,
                backgroundColor: AppColors.softSurface,
                iconColor: ProfileColors.darkGreen,
                size: 40,
                iconSize: 20,
                borderRadius: AppSpacing.radiusSm,
              ),
              title: Text(
                label,
                style: GoogleFonts.instrumentSans(
                  fontSize: 15,
                  color: ProfileColors.darkGreen,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showSnack('$label (simulasi) — fitur unggah foto belum tersedia');
              },
            );

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Foto Profil',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ProfileColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                option(Icons.photo_camera_outlined, 'Ambil dari kamera'),
                option(Icons.photo_library_outlined, 'Pilih dari galeri'),
                option(Icons.delete_outline, 'Hapus foto'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final newName = _usernameController.text.trim();
    _showSnack('Profil berhasil diperbarui');
    Navigator.pop(context, newName);
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: ProfileColors.cardWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ProfileColors.darkGreen),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ProfileColors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ProfileColors.redAccent),
      ),
    );
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
          'Edit Profil',
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
              // ── Avatar ──
              Center(
                child: Column(
                  children: [
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _showPhotoOptions,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: ProfileColors.lightGreenBg,
                            child: Text(
                              _initial,
                              style: GoogleFonts.instrumentSans(
                                color: ProfileColors.darkGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 38,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ProfileColors.darkGreen,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusXs),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _showPhotoOptions,
                      child: Text(
                        'Ubah foto profil',
                        style: GoogleFonts.instrumentSans(
                          fontWeight: FontWeight.w600,
                          color: ProfileColors.darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Username ──
              _label('Username'),
              TextFormField(
                controller: _usernameController,
                style: GoogleFonts.instrumentSans(fontSize: 14, color: ProfileColors.darkGreen),
                decoration: _inputDecoration(hint: 'Masukkan username'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Username tidak boleh kosong';
                  if (value.length < 3) return 'Username minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Email (read-only) ──
              _label('Email'),
              TextFormField(
                initialValue: widget.currentEmail,
                readOnly: true,
                style: GoogleFonts.instrumentSans(fontSize: 14, color: ProfileColors.textGrey),
                decoration: _inputDecoration(),
                onTap: () => _showSnack('Email tidak dapat diubah di halaman ini'),
              ),
              const SizedBox(height: 32),

              // ── Tombol Simpan ──
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
                  onPressed: _save,
                  child: Text(
                    'Simpan perubahan',
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

