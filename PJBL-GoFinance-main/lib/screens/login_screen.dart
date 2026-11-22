import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:go_finance/core/services/app_update_service.dart';
import 'package:go_finance/core/services/aws_auth_service.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
import 'package:go_finance/core/widgets/login_update_banner.dart';
import 'package:go_finance/core/widgets/update_notification_sheet.dart';
import 'package:go_finance/features/home/pages/home_page.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';
import 'package:go_finance/theme/app_theme.dart';
import 'package:go_finance/screens/register_screen.dart';
import 'package:go_finance/screens/admin/admin_login_screen.dart';
import 'package:go_finance/widgets/bounce_button.dart';
import 'package:go_finance/widgets/glow_input_field.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';
import 'package:go_finance/widgets/floating_widget.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  AppUpdateInfo? _updateInfo;
  bool _isCheckingUpdate = false;
  bool _isUpdateBannerDismissed = false;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate({bool force = false}) async {
    setState(() => _isCheckingUpdate = true);
    final info =
        await AppUpdateService.instance.checkForUpdate(forceRefresh: force);
    if (!mounted) return;
    setState(() {
      _updateInfo = info;
      _isCheckingUpdate = false;
    });

    if (info.hasUpdate && !_isUpdateBannerDismissed && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ModalRoute.of(context)?.isCurrent == true) {
          UpdateNotificationSheet.show(context, info);
        }
      });
    }
  }

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
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: FloatingWidget(
                                          distance: 5.0,
                                          duration: const Duration(
                                              milliseconds: 2400),
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
                                      Positioned(
                                        right: 0,
                                        child: Tooltip(
                                          message: l10n.checkGithubUpdates,
                                          child: InkWell(
                                            onTap: () {
                                              if (_updateInfo != null &&
                                                  _updateInfo!.hasUpdate) {
                                                UpdateNotificationSheet.show(
                                                    context, _updateInfo!);
                                              } else {
                                                _checkForUpdate(force: true);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.checkingGithubUpdates,
                                                      style: GoogleFonts
                                                          .instrumentSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    backgroundColor:
                                                        AppTheme.primaryGreen,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              }
                                            },
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: _updateInfo
                                                              ?.hasUpdate ==
                                                          true
                                                      ? const Color(0xFF81C784)
                                                      : const Color(0xFFE0E0E0),
                                                  width: 1.2,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0x0C000000),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Icon(
                                                    Icons.sync_rounded,
                                                    size: 20,
                                                    color: _isCheckingUpdate
                                                        ? Colors.grey
                                                        : AppTheme
                                                            .primaryDarkGreen,
                                                  ),
                                                  if (_updateInfo?.hasUpdate ==
                                                      true)
                                                    Positioned(
                                                      top: -2,
                                                      right: -2,
                                                      child: Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              BoxShape.circle,
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
                                const SizedBox(height: 20),
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 200),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.welcomeBack,
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
                                        l10n.loginSubtitle,
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
                                const SizedBox(height: 24),
                                if (!_isUpdateBannerDismissed &&
                                    (_updateInfo?.hasUpdate == true ||
                                        _isCheckingUpdate))
                                  StaggeredFadeSlide(
                                    delay: const Duration(milliseconds: 250),
                                    child: LoginUpdateBanner(
                                      updateInfo: _updateInfo,
                                      isChecking: _isCheckingUpdate,
                                      onDismiss: () => setState(
                                        () => _isUpdateBannerDismissed = true,
                                      ),
                                      onCheckUpdate: () =>
                                          _checkForUpdate(force: true),
                                    ),
                                  ),
                                const SizedBox(height: 12),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(
                                          () => _rememberMe = !_rememberMe,
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        child: Row(
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
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
                                      GestureDetector(
                                        onTap: _handleForgotPassword,
                                        behavior: HitTestBehavior.opaque,
                                        child: Text(
                                          l10n.forgotPassword,
                                          style: GoogleFonts.instrumentSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            letterSpacing: -0.14,
                                            color: AppTheme.primaryGreen,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        onPressed: _handleLogin,
                                        child: Text(
                                          _isLoggingIn
                                              ? 'Memproses...'
                                              : l10n.login,
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
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  const AdminLoginScreen(),
                                              transitionsBuilder:
                                                  (_, anim, __, child) =>
                                                      FadeTransition(
                                                opacity: anim,
                                                child: child,
                                              ),
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 350),
                                            ),
                                          );
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.6),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: AppTheme.primaryGreen
                                                  .withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .admin_panel_settings_rounded,
                                                size: 16,
                                                color:
                                                    AppTheme.primaryDarkGreen,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Masuk sebagai Admin',
                                                style:
                                                    GoogleFonts.instrumentSans(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppTheme.primaryDarkGreen,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  const RegisterScreen(),
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
                                              text: l10n.noAccountPrompt,
                                              style: GoogleFonts.instrumentSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.14,
                                                color: AppTheme.primaryGreen,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: l10n.register,
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

  void _handleForgotPassword() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.passwordRecoveryMessage,
          style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showLoginSnack(l10n.emailPasswordRequired, isError: true);
      return;
    }

    if (_isLoggingIn) return;
    setState(() => _isLoggingIn = true);

    try {
      await AwsAuthService.instance.signIn(email, password);
      final profile = await AwsApiService.instance.getMyProfile();
      if (!mounted) return;

      final String status = profile['status'] ?? 'pending';

      if (status == 'pending') {
        setState(() => _isLoggingIn = false);
        await AwsAuthService.instance.signOut();
        _showStatusDialog(
          title: 'Menunggu Persetujuan Admin',
          message:
              'Akun kamu sudah terdaftar, namun masih menunggu persetujuan dari Admin sebelum dapat digunakan.',
          icon: Icons.hourglass_top_rounded,
          color: Colors.orange.shade700,
        );
        return;
      }

      if (status == 'suspended') {
        setState(() => _isLoggingIn = false);
        await AwsAuthService.instance.signOut();
        _showStatusDialog(
          title: 'Akun Dinonaktifkan',
          message:
              'Akun kamu dinonaktifkan oleh Admin karena terindikasi aktivitas spam.',
          icon: Icons.block_rounded,
          color: Colors.red.shade700,
        );
        return;
      }

      await context.read<TransactionProvider>().syncFromAws();
      if (!mounted) return;
      setState(() => _isLoggingIn = false);

      _showLoginSnack(l10n.loginSuccess);
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ),
        (route) => false,
      );
    } on CognitoClientException catch (e) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showLoginSnack(e.message ?? 'Email atau password salah', isError: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showLoginSnack('Gagal terhubung ke server: $e', isError: true);
    }
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: color),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.instrumentSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.instrumentSans(fontSize: 13.5, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showLoginSnack(String message, {bool isError = false}) {
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