import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:go_finance/core/services/aws_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/theme/app_theme.dart';
import 'package:go_finance/screens/login_screen.dart';
import 'package:go_finance/widgets/bounce_button.dart';
import 'package:go_finance/widgets/glow_input_field.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';
import 'package:go_finance/widgets/floating_widget.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isRegistering = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: Stack(
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
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 200),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.welcomeNew,
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
                                        l10n.registerSubtitle,
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
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 320),
                                  child: GlowInputField(
                                    controller: _emailController,
                                    label: l10n.emailFieldLabel,
                                    hint: l10n.emailHint,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 400),
                                  child: GlowInputField(
                                    controller: _passwordController,
                                    label: l10n.passwordFieldLabel,
                                    hint: '••••••••',
                                    isPassword: true,
                                  ),
                                ),
                                const SizedBox(height: 18),
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
                                          l10n.rememberMe,
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
                                      BounceButton(
                                        height: 50,
                                        borderRadius: 16,
                                        backgroundColor: AppTheme.primaryGreen,
                                        onPressed: _handleRegister,
                                        child: Text(
                                          _isRegistering
                                              ? 'Mendaftar...'
                                              : l10n.register,
                                          style: GoogleFonts.instrumentSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: -0.14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 22),
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
                                              text: l10n.existingAccountPrompt,
                                              style: GoogleFonts.instrumentSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.14,
                                                color: AppTheme.primaryGreen,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: l10n.login,
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

  Future<void> _handleRegister() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email.isEmpty || password.trim().isEmpty) {
      _showSnack(l10n.emailPasswordRequired, isError: true);
      return;
    }

    if (_isRegistering) return;
    setState(() => _isRegistering = true);

    try {
      final isConfirmed = await AwsAuthService.instance.signUp(
        email: email,
        password: password,
      );
      if (!mounted) return;
      setState(() => _isRegistering = false);

      if (!isConfirmed) {
        await _showOtpDialog(email);
        if (!mounted) return;
      }

      _showSnack(l10n.registerSuccess);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    } on CognitoClientException catch (e) {
      if (!mounted) return;
      setState(() => _isRegistering = false);
      _showSnack(e.message ?? 'Gagal mendaftar ke Cognito', isError: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRegistering = false);
      _showSnack('Gagal mendaftar: $e', isError: true);
    }
  }

  Future<void> _showOtpDialog(String email) async {
    final otpController = TextEditingController();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool confirming = false;
        String? errorText;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Verifikasi Kode OTP',
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w700),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Masukkan kode verifikasi yang dikirim ke $email.',
                  style: GoogleFonts.instrumentSans(fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Kode OTP (6 digit)',
                    errorText: errorText,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: confirming
                    ? null
                    : () async {
                        await AwsAuthService.instance
                            .resendConfirmationCode(email);
                        if (dialogCtx.mounted) {
                          setDialogState(() => errorText = null);
                        }
                      },
                child: const Text('Kirim Ulang'),
              ),
              ElevatedButton(
                onPressed: confirming
                    ? null
                    : () async {
                        final code = otpController.text.trim();
                        if (code.isEmpty) {
                          setDialogState(
                              () => errorText = 'Kode OTP wajib diisi');
                          return;
                        }
                        setDialogState(() {
                          confirming = true;
                          errorText = null;
                        });
                        try {
                          await AwsAuthService.instance
                              .confirmUser(email, code);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                        } catch (e) {
                          setDialogState(() {
                            confirming = false;
                            errorText = 'Kode OTP tidak valid: $e';
                          });
                        }
                      },
                child: Text(confirming ? 'Memverifikasi...' : 'Konfirmasi'),
              ),
            ],
          ),
        );
      },
    );
    otpController.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? Colors.red.shade700 : AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}