import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/services/aws_auth_service.dart';
import 'package:go_finance/features/home/pages/home_page.dart';
import 'package:go_finance/theme/app_theme.dart';
import 'package:go_finance/screens/onboarding_screen.dart';
import 'package:go_finance/screens/login_screen.dart';
import 'package:go_finance/screens/admin/admin_dashboard_screen.dart';
import 'package:go_finance/widgets/floating_widget.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// Splash Screen - "Beranda awal 2" dari Figma (node 84:313)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _progressAnim;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeIn),
      ),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.95, curve: Curves.easeInOutCubic),
      ),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted && !_isNavigating) {
        _navigateAfterSplash();
      }
    });
  }

  Future<void> _navigateAfterSplash() async {
    _isNavigating = true;
    Widget targetScreen = const OnboardingScreen();

    try {
      final auth = AwsAuthService.instance;
      final hasSession = await auth.restoreSession();
      if (hasSession) {
        final admin = await auth.isAdmin();
        if (admin) {
          targetScreen = const AdminDashboardScreen();
        } else {
          final status = await auth.getUserStatus();
          if (status == 'active') {
            if (auth.onLoginSuccess != null) {
              await auth.onLoginSuccess!();
            }
            targetScreen = const HomePage();
          } else {
            targetScreen = const LoginScreen();
          }
        }
      }
    } catch (_) {
      targetScreen = const OnboardingScreen();
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => targetScreen,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/svg/bg_green.svg',
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) =>
                      Container(color: AppTheme.backgroundGreen),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingWidget(
                              distance: 6.0,
                              duration: const Duration(milliseconds: 2200),
                              child: Image.asset(
                                'assets/images/piggy_splash.png',
                                width: 150,
                                height: 175,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen
                                        .withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.savings_rounded,
                                    size: 80,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Go Finance',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.instrumentSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 36,
                                height: 44 / 36,
                                letterSpacing: -0.36,
                                color: AppTheme.primaryDarkGreen,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.splashTagline,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.instrumentSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: -0.14,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SizedBox(
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _progressAnim.value,
                              backgroundColor:
                                  AppTheme.primaryGreen.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryGreen,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}