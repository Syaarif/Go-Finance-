import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/theme/app_theme.dart';

class AnimatedInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final bool isPassword;

  const AnimatedInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Default: TRANSPARAN (tidak ada border hijau sebelum disentuh)
          // Fokus: Border hijau halus saat disentuh/diklik
          color: _isFocused ? AppTheme.primaryGreen : Colors.transparent,
          width: 1.6,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: AppTheme.primaryGreen.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          else
            const BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      padding: const EdgeInsets.only(left: 18, right: 12, top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: -0.14,
                    color: _isFocused
                        ? AppTheme.primaryGreen
                        : const Color(0x99000000),
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.isPassword && _obscureText,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E2D1A),
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.instrumentSans(
                      fontSize: 14,
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
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              splashRadius: 18,
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
  }
}
