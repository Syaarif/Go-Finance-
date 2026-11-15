import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';
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

  Color _themeColor(Color lightColor, Color darkColor) =>
      Theme.of(context).brightness == Brightness.dark ? darkColor : lightColor;

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
        content: Text(AppLocalizations.of(context)!.passwordChangedSimulation),
        backgroundColor: context.colors.primary,
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
            color: _themeColor(
              ProfileColors.darkGreen,
              context.colors.textPrimary,
            ),
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
          borderSide:
              color == null ? BorderSide.none : BorderSide(color: color),
        );

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.instrumentSans(
        fontSize: 14,
        color: _themeColor(
          ProfileColors.darkGreen,
          context.colors.textPrimary,
        ),
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: context.colors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border(null),
        enabledBorder: border(null),
        focusedBorder: border(
          _themeColor(ProfileColors.darkGreen, context.colors.primary),
        ),
        errorBorder: border(
          _themeColor(ProfileColors.redAccent, context.colors.negative),
        ),
        focusedErrorBorder: border(
          _themeColor(ProfileColors.redAccent, context.colors.negative),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: _themeColor(
              ProfileColors.textGrey,
              context.colors.mutedText,
            ),
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
      backgroundColor: _themeColor(
        ProfileColors.background,
        context.colors.canvas,
      ),
      appBar: AppBar(
        backgroundColor: context.colors.canvas.withValues(alpha: 0),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          color: _themeColor(
            ProfileColors.darkGreen,
            context.colors.primaryText,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.security,
          style: GoogleFonts.instrumentSans(
            color: _themeColor(
              ProfileColors.darkGreen,
              context.colors.textPrimary,
            ),
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
                AppLocalizations.of(context)!.changePassword,
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: _themeColor(
                    ProfileColors.darkGreen,
                    context.colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.passwordGuidance,
                style: GoogleFonts.instrumentSans(
                  fontSize: 13,
                  color: _themeColor(
                    ProfileColors.textGrey,
                    context.colors.mutedText,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _label(AppLocalizations.of(context)!.oldPassword),
              _passwordField(
                controller: _oldController,
                hint: AppLocalizations.of(context)!.enterOldPassword,
                obscure: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return AppLocalizations.of(context)!.oldPasswordRequired;
                  }
                  if (v != _dummyOldPassword) {
                    return AppLocalizations.of(context)!.oldPasswordIncorrect;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _label(AppLocalizations.of(context)!.newPassword),
              _passwordField(
                controller: _newController,
                hint: AppLocalizations.of(context)!.enterNewPassword,
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return AppLocalizations.of(context)!.newPasswordRequired;
                  }
                  if (v.length < 8) {
                    return AppLocalizations.of(context)!.passwordMinLength;
                  }
                  if (!RegExp(r'[A-Za-z]').hasMatch(v) ||
                      !RegExp(r'\d').hasMatch(v)) {
                    return AppLocalizations.of(context)!
                        .passwordMustContainLettersAndNumbers;
                  }
                  if (v == _oldController.text) {
                    return AppLocalizations.of(context)!.newPasswordMustDiffer;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _label(AppLocalizations.of(context)!.confirmNewPassword),
              _passwordField(
                controller: _confirmController,
                hint: AppLocalizations.of(context)!.repeatNewPassword,
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return AppLocalizations.of(context)!
                        .passwordConfirmationRequired;
                  }
                  if (v != _newController.text) {
                    return AppLocalizations.of(context)!
                        .passwordConfirmationMismatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!
                    .demoPasswordNotice(_dummyOldPassword),
                style: GoogleFonts.instrumentSans(
                  fontSize: 12,
                  color: _themeColor(
                    ProfileColors.textGrey,
                    context.colors.mutedText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeColor(
                      ProfileColors.darkGreen,
                      context.colors.primary,
                    ),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _submit,
                  child: Text(
                    AppLocalizations.of(context)!.savePassword,
                    style: GoogleFonts.instrumentSans(
                        fontSize: 15, fontWeight: FontWeight.w600),
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
