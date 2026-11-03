import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/theme/app_theme.dart';
import 'package:go_finance/screens/login_screen.dart';
import 'package:go_finance/screens/register_screen.dart';
import 'package:go_finance/widgets/bounce_button.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';
import 'package:go_finance/widgets/floating_widget.dart';

/// Onboarding Screen - "Beranda awal 4" dari Figma (node 187-1890)
/// Disesuaikan secara responsif untuk layar perangkat mobile Android & iOS
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Area atas: Logo, Headline, Subtitle, dan Tanaman Pot
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36, 20, 36, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo "Go Finance"
                        StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 100),
                          offset: const Offset(0, -0.2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/piggy_icon.png',
                                width: 24,
                                height: 26,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.savings_rounded,
                                  size: 24,
                                  color: AppTheme.primaryDarkGreen,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Go Finance',
                                style: GoogleFonts.instrumentSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  letterSpacing: -0.20,
                                  color: AppTheme.primaryDarkGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Headline & Subtitle
                        StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 220),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tumbuh lebih\ncerdas, Menjadi\nlebih kaya',
                                style: GoogleFonts.instrumentSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34,
                                  height: 1.18,
                                  letterSpacing: -0.36,
                                  color: AppTheme.primaryDarkGreen,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Perjalanan kamu mengelola keuangan\nlebih baik dimulai dari sini!',
                                style: GoogleFonts.instrumentSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  height: 1.42,
                                  letterSpacing: -0.16,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tanaman dalam pot tepat di atas panel putih
                        Expanded(
                          child: Center(
                            child: StaggeredFadeSlide(
                              delay: const Duration(milliseconds: 320),
                              child: FloatingWidget(
                                distance: 4.0,
                                duration: const Duration(milliseconds: 2800),
                                child: Image.asset(
                                  'assets/images/plant.png',
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomCenter,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.eco_rounded,
                                    size: 160,
                                    color: AppTheme.primaryGreen
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Panel Putih di Bagian Bawah
                StaggeredFadeSlide(
                  delay: const Duration(milliseconds: 380),
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
                        padding: const EdgeInsets.fromLTRB(36, 32, 36, 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol "Daftar"
                            BounceButton(
                              height: 50,
                              borderRadius: 16,
                              backgroundColor: AppTheme.primaryGreen,
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const RegisterScreen(),
                                    transitionsBuilder: (_, anim, __, child) =>
                                        FadeTransition(
                                          opacity: anim,
                                          child: child,
                                        ),
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                  ),
                                );
                              },
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

                            // Link "Sudah punya akun? Masuk"
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const LoginScreen(),
                                    transitionsBuilder: (_, anim, __, child) =>
                                        FadeTransition(
                                          opacity: anim,
                                          child: child,
                                        ),
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                                        style: GoogleFonts.instrumentSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          letterSpacing: -0.14,
                                          color: AppTheme.primaryGreen,
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
        ],
      ),
    );
  }
}
