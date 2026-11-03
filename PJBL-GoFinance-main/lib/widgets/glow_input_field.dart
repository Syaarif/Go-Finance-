import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/theme/app_theme.dart';

/// Input field dengan animasi "Light / Glow Effect" yang memukau saat diklik / diisi
class GlowInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final bool isPassword;

  const GlowInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<GlowInputField> createState() => _GlowInputFieldState();
}

class _GlowInputFieldState extends State<GlowInputField>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _glowController;
  late Animation<double> _pulseAnim;
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // Animasi denyut cahaya (pulsing light / glow)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnim = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _glowController.repeat(reverse: true);
      } else {
        _glowController.stop();
        _glowController.reset();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        final glowIntensity = _isFocused ? _pulseAnim.value : 0.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // Border: Di kondisi idle = TRANSPARAN / putih bersih (sesuai Figma)
            // Saat fokus / ngetik = Border hijau neon menyala dengan efek glowing
            border: Border.all(
              color: _isFocused
                  ? Color.lerp(
                      const Color(0xFF347928),
                      const Color(0xFF68D34B),
                      glowIntensity,
                    )!
                  : Colors.transparent,
              width: _isFocused ? 2.0 : 1.0,
            ),
            boxShadow: [
              if (_isFocused) ...[
                // Efek Cahaya / Light Glow luar
                BoxShadow(
                  color: const Color(0xFF347928).withOpacity(0.35 * glowIntensity),
                  blurRadius: 16 * glowIntensity + 6,
                  spreadRadius: 2.5 * glowIntensity,
                  offset: const Offset(0, 2),
                ),
                // Halo cahaya hijau lembut
                BoxShadow(
                  color: const Color(0xFF74E353).withOpacity(0.20 * glowIntensity),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ] else
                const BoxShadow(
                  color: Color(0x0E000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
            ],
          ),
          padding: const EdgeInsets.only(left: 20, right: 14, top: 8, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Label ("Email:" / "Password:")
                    Row(
                      children: [
                        Text(
                          widget.label,
                          style: GoogleFonts.instrumentSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: -0.14,
                            color: _isFocused
                                ? const Color(0xFF234D1C)
                                : const Color(0x8A000000),
                          ),
                        ),
                        if (_isFocused) ...[
                          const SizedBox(width: 6),
                          // Indikator lampu kecil aktif
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF48B32F),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF48B32F).withOpacity(0.8),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Kolom Textfield
                    TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      keyboardType: widget.keyboardType,
                      obscureText: widget.isPassword && _obscureText,
                      cursorColor: AppTheme.primaryGreen,
                      cursorWidth: 2,
                      cursorRadius: const Radius.circular(2),
                      style: GoogleFonts.instrumentSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2D1A),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: widget.hint,
                        hintStyle: GoogleFonts.instrumentSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black26,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey<bool>(_obscureText),
                      size: 20,
                      color: _isFocused
                          ? AppTheme.primaryGreen
                          : const Color(0xFF758A70),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
