import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/theme/app_theme.dart';
import 'package:go_finance/screens/login_screen.dart';
import 'package:go_finance/widgets/bounce_button.dart';
import 'package:go_finance/widgets/glow_input_field.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';
import 'package:go_finance/widgets/floating_widget.dart';

/// Register Screen - "Daftar" dari Figma (node 187-1925)
/// Tata letak responsif mobile untuk Android & iOS (mendukung scroll saat keyboard aktif)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background SVG Texture
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg/bg_green.svg',
              fit: BoxFit.cover,
              placeholderBuilder: (_) =>
                  Container(color: AppTheme.backgroundGreen),
            ),
          ),

          // 2. Konten Responsif Mobile
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Piggy bank coin dengan animasi mengambang
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 100),
                                  child: Center(
                                    child: FloatingWidget(
                                      distance: 5.0,
                                      duration:
                                          const Duration(milliseconds: 2400),
                                      child: Image.asset(
                                        'assets/images/piggy_coin.png',
                                        width: 58,
                                        height: 66,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.savings_rounded,
                                          size: 58,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Headline & Subtitle
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 200),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selamat datang!',
                                        style: GoogleFonts.instrumentSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32,
                                          height: 1.25,
                                          letterSpacing: -0.32,
                                          color: AppTheme.primaryDarkGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Daftar untuk memulai perjalanan\nkamu bersama Go Finance!',
                                        style: GoogleFonts.instrumentSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          height: 1.42,
                                          letterSpacing: -0.14,
                                          color: AppTheme.primaryGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Kolom Form Email
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 320),
                                  child: GlowInputField(
                                    controller: _emailController,
                                    label: 'Email:',
                                    hint: 'nama@email.com',
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Kolom Form Password
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 400),
                                  child: GlowInputField(
                                    controller: _passwordController,
                                    label: 'Password:',
                                    hint: '••••••••',
                                    isPassword: true,
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Checkbox "Ingat saya"
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 480),
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _rememberMe = !_rememberMe,
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: _rememberMe
                                                ? AppTheme.primaryGreen
                                                : Colors.white,
                                            border: Border.all(
                                              color: AppTheme.primaryGreen,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x0C000000),
                                                blurRadius: 4,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: _rememberMe
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 13,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Ingat saya',
                                          style: GoogleFonts.instrumentSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: -0.14,
                                            color: AppTheme.primaryGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Panel Putih di Bagian Bawah
                          StaggeredFadeSlide(
                            delay: const Duration(milliseconds: 400),
                            offset: const Offset(0, 0.25),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x18000000),
                                    blurRadius: 24,
                                    offset: Offset(0, -6),
                                  ),
                                ],
                              ),
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    36,
                                    32,
                                    36,
                                    28,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Tombol "Daftar" dengan animasi Bounce
                                      BounceButton(
                                        height: 50,
                                        borderRadius: 16,
                                        backgroundColor: AppTheme.primaryGreen,
                                        onPressed: _handleRegister,
                                        child: Text(
                                          'Daftar',
                                          style: GoogleFonts.instrumentSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: -0.14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 22),

                                      // "Sudah punya akun? Masuk"
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  const LoginScreen(),
                                              transitionsBuilder:
                                                  (_, anim, __, child) =>
                                                      FadeTransition(
                                                opacity: anim,
                                                child: child,
                                              ),
                                              transitionDuration:
                                                  const Duration(
                                                milliseconds: 300,
                                              ),
                                            ),
                                          );
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Sudah punya akun? ',
                                              style: GoogleFonts.instrumentSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.14,
                                                color: AppTheme.primaryGreen,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Masuk',
                                                  style: GoogleFonts
                                                      .instrumentSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    letterSpacing: -0.14,
                                                    color:
                                                        AppTheme.primaryGreen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegister() {
    FocusScope.of(context).unfocus();
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email dan password harus diisi!',
            style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Akun berhasil dibuat! Silakan masuk.',
          style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
