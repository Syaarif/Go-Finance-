import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/admin/admin_dashboard_screen.dart';
import 'package:go_finance/widgets/bounce_button.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

/// 00_Admin_Login — Halaman masuk khusus Admin via email
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  // Animasi shield icon
  late AnimationController _shieldPulseController;
  late Animation<double> _shieldPulse;

  // Animasi shake saat error
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  static const _adminEmail = 'admin@gofinance.id';
  static const _adminPassword = 'admin123';

  @override
  void initState() {
    super.initState();

    _shieldPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _shieldPulse = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _shieldPulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shieldPulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    // Simulasi pengecekan — ganti dengan API call jika sudah ada backend
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email == _adminEmail && pass == _adminPassword) {
      HapticFeedback.heavyImpact();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => const AdminDashboardScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
          ),
          transitionDuration: const Duration(milliseconds: 480),
        ),
      );
    } else {
      setState(() => _isLoading = false);
      HapticFeedback.vibrate();
      _shakeController.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email atau password salah. Coba lagi.',
            style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFFE63939),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // ── Latar gradien hijau ──
            Container(
              height: MediaQuery.of(context).size.height * 0.42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF15A147),
                    Color(0xFF257029),
                    Color(0xFF123D18),
                  ],
                ),
              ),
            ),

            // ── Lingkaran dekorasi (blurred circles) ──
            Positioned(
              top: -60, right: -60,
              child: Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              top: 40, left: -40,
              child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // ── Konten utama ──
            SafeArea(
              child: Column(
                children: [
                  // ── Bagian atas (shield + judul) ──
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Shield pulsing
                        StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 100),
                          child: ScaleTransition(
                            scale: _shieldPulse,
                            child: Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            'Admin Portal',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 280),
                          child: Text(
                            'Go Finance Admin Dashboard',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Card form ──
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (ctx, child) => Transform.translate(
                        offset: Offset(_shakeAnim.value, 0),
                        child: child,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 24,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 300),
                                  child: Text(
                                    'Masuk sebagai Admin',
                                    style: GoogleFonts.instrumentSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 360),
                                  child: Text(
                                    'Masukkan email dan password admin Anda',
                                    style: GoogleFonts.instrumentSans(
                                      fontSize: 13,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // ── Email field ──
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 420),
                                  child: _buildLabel('Email Admin'),
                                ),
                                const SizedBox(height: 8),
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 460),
                                  child: _AdminInputField(
                                    controller: _emailController,
                                    hint: 'admin@gofinance.id',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Email tidak boleh kosong';
                                      }
                                      if (!v.contains('@')) {
                                        return 'Format email tidak valid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ── Password field ──
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 500),
                                  child: _buildLabel('Password'),
                                ),
                                const SizedBox(height: 8),
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 540),
                                  child: _AdminInputField(
                                    controller: _passwordController,
                                    hint: 'Masukkan password',
                                    icon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF9E9E9E),
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Remember me + lupa pass ──
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 580),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20, height: 20,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) =>
                                              setState(() => _rememberMe = v!),
                                          activeColor: const Color(0xFF15A147),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          side: const BorderSide(
                                              color: Color(0xFFCCCCCC)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ingat saya',
                                        style: GoogleFonts.instrumentSans(
                                          fontSize: 13,
                                          color: const Color(0xFF555555),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Lupa Password?',
                                          style: GoogleFonts.instrumentSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF15A147),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ── Badge keamanan ──
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 620),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F8EE),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.verified_user_rounded,
                                          color: Color(0xFF15A147),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Dilindungi dengan keamanan 2 lapis',
                                            style: GoogleFonts.instrumentSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF15A147),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ── Tombol Login ──
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 680),
                                  child: _isLoading
                                      ? Container(
                                          height: 54,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF15A147),
                                                Color(0xFF257029),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: SizedBox(
                                              width: 24, height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            ),
                                          ),
                                        )
                                      : BounceButton(
                                          onPressed: _doLogin,
                                          backgroundColor: const Color(0xFF15A147),
                                          height: 54,
                                          borderRadius: 16,
                                          child: Text(
                                            'Masuk sebagai Admin',
                                            style: GoogleFonts.instrumentSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 20),

                                // ── Notice keamanan ──
                                StaggeredFadeSlide(
                                  delay: const Duration(milliseconds: 740),
                                  child: Center(
                                    child: Text(
                                      'Akses terbatas untuk administrator saja.\nAktivitas login dicatat dan dipantau.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: 11,
                                        color: const Color(0xFFAAAAAA),
                                        height: 1.6,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: GoogleFonts.instrumentSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
        ),
      );
}

// ─────────────────────────────────────────────────────────
// Input field reusable untuk admin screens
// ─────────────────────────────────────────────────────────
class _AdminInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AdminInputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  State<_AdminInputField> createState() => _AdminInputFieldState();
}

class _AdminInputFieldState extends State<_AdminInputField>
    with SingleTickerProviderStateMixin {
  final _focus = FocusNode();
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _focus.addListener(() {
      setState(() => _focused = _focus.hasFocus);
      if (_focused) {
        _glowCtrl.repeat(reverse: true);
      } else {
        _glowCtrl.stop();
        _glowCtrl.reset();
      }
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (ctx, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: const Color(0xFF15A147)
                        .withValues(alpha: 0.25 * _glowAnim.value),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: child,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focus,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        validator: widget.validator,
        style: GoogleFonts.instrumentSans(
          fontSize: 14,
          color: const Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.instrumentSans(
            color: const Color(0xFFA0A0A0),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: _focused ? const Color(0xFF15A147) : const Color(0xFF9E9E9E),
            size: 20,
          ),
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: _focused ? const Color(0xFFF5FBF7) : const Color(0xFFF7F8F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF15A147), width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE63939), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE63939), width: 1.8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
