import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:intl/intl.dart';

/// Halaman numpad custom untuk memasukkan nominal (03b_Numpad_Nominal).
class NumpadPage extends StatefulWidget {
  final double initialAmount;
  const NumpadPage({super.key, this.initialAmount = 0});

  @override
  State<NumpadPage> createState() => _NumpadPageState();
}

class _NumpadPageState extends State<NumpadPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  String _raw = ''; // nilai mentah sebagai string angka (tanpa separator)
  bool _hasDecimal = false;
  String _decimalPart = '';

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();

    // Inisialisasi jika ada nilai awal
    if (widget.initialAmount > 0) {
      _raw = widget.initialAmount.toInt().toString();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  String get _displayAmount {
    if (_raw.isEmpty && !_hasDecimal) return 'Rp 0';
    final intPart = _raw.isEmpty ? '0' : _raw;
    final formatted = _formatInt(intPart);
    if (_hasDecimal) {
      return 'Rp $formatted,$_decimalPart';
    }
    return 'Rp $formatted';
  }

  String _formatInt(String s) {
    if (s.isEmpty) return '0';
    final n = int.tryParse(s) ?? 0;
    return NumberFormat('#,###', 'id_ID').format(n);
  }

  double get _currentValue {
    if (_raw.isEmpty) return 0;
    if (_hasDecimal) {
      final dec = _decimalPart.isEmpty ? '0' : _decimalPart;
      return double.tryParse('${_raw.isEmpty ? "0" : _raw}.$dec') ?? 0;
    }
    return double.tryParse(_raw) ?? 0;
  }

  void _onKey(String key) {
    HapticFeedback.selectionClick();
    setState(() {
      if (key == ',') {
        // Toggle mode desimal
        if (!_hasDecimal) {
          _hasDecimal = true;
          if (_raw.isEmpty) _raw = '0';
        }
      } else if (key == '.') {
        // Hapus karakter terakhir
        _backspace();
      } else {
        // Angka 0-9
        if (_hasDecimal) {
          if (_decimalPart.length < 2) _decimalPart += key;
        } else {
          if (_raw.length < 12) _raw += key;
          // Hindari leading zeros
          if (_raw.length > 1 && _raw.startsWith('0')) {
            _raw = _raw.replaceFirst(RegExp(r'^0+'), '');
            if (_raw.isEmpty) _raw = '0';
          }
        }
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_hasDecimal) {
        if (_decimalPart.isNotEmpty) {
          _decimalPart = _decimalPart.substring(0, _decimalPart.length - 1);
        } else {
          _hasDecimal = false;
        }
      } else {
        if (_raw.isNotEmpty) {
          _raw = _raw.substring(0, _raw.length - 1);
        }
      }
    });
  }

  void _confirm() {
    if (_currentValue <= 0) {
      HapticFeedback.heavyImpact();
      return;
    }
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- App Bar ---
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal, 16,
                  AppSpacing.pageHorizontal, 0),
              child: Row(
                children: [
                  RoundedSquareIcon(
                    icon: Icons.chevron_left_rounded,
                    backgroundColor: AppColors.surface,
                    iconColor: AppColors.deepGreen,
                    size: 40,
                    iconSize: 22,
                    borderRadius: AppSpacing.radiusSm,
                    border: Border.all(color: AppColors.border),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Tambah Transaksi',
                      style: AppTextStyles.pageTitle),
                ],
              ),
            ),

            // --- Type toggle (dekoratif) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal, AppSpacing.lg,
                AppSpacing.pageHorizontal, 0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusCard - 3),
                        ),
                        alignment: Alignment.center,
                        child: Text('Pemasukan',
                            style: AppTextStyles.primaryButton
                                .copyWith(fontSize: 14)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('Pengeluaran',
                            style: AppTextStyles.inputHint
                                .copyWith(fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // --- Nominal Display ---
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.2),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: _anim, curve: Curves.easeOutCubic)),
                child: FadeTransition(
                  opacity: _anim,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _displayAmount,
                                key: ValueKey(_displayAmount),
                                style: AppTextStyles.nominalInputText
                                    .copyWith(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _backspace,
                          onLongPress: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              _raw = '';
                              _hasDecimal = false;
                              _decimalPart = '';
                            });
                          },
                          child: const RoundedSquareIcon(
                            icon: Icons.backspace_outlined,
                            backgroundColor: AppColors.softSurface,
                            iconColor: AppColors.mutedText,
                            size: 36,
                            iconSize: 18,
                            borderRadius: AppSpacing.radiusSm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ===== NUMPAD GRID =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal),
                child: _Numpad(onKey: _onKey),
              ),
            ),

            // ===== TOMBOL LANJUTKAN =====
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal, 0,
                AppSpacing.pageHorizontal, AppSpacing.lg),
              child: _ConfirmButton(
                enabled: _currentValue > 0,
                onTap: _confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// NUMPAD GRID
// ───────────────────────────────────────────────────────────────
class _Numpad extends StatelessWidget {
  final ValueChanged<String> onKey;
  const _Numpad({required this.onKey});

  static const _keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', ','],
  ];
  // . = backspace, , = decimal separator

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _keys.map((row) {
        return Expanded(
          child: Row(
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: _NumpadKey(keyLabel: key, onTap: () => onKey(key)),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumpadKey extends StatefulWidget {
  final String keyLabel;
  final VoidCallback onTap;
  const _NumpadKey({required this.keyLabel, required this.onTap});

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.90,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildChild() {
    final k = widget.keyLabel;
    if (k == '.') {
      // Backspace icon
      return const Icon(Icons.backspace_outlined,
          color: AppColors.deepGreen, size: 20);
    }
    if (k == ',') {
      return const Text(',',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.deepGreen,
          ));
    }
    return Text(
      k,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08234D1C),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: _buildChild(),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// CONFIRM BUTTON
// ───────────────────────────────────────────────────────────────
class _ConfirmButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;
  const _ConfirmButton({required this.enabled, required this.onTap});

  @override
  State<_ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<_ConfirmButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _ctrl.reverse() : null,
      onTapUp: widget.enabled
          ? (_) {
              _ctrl.forward();
              widget.onTap();
            }
          : null,
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.primary : AppColors.disabledSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            'Lanjutkan',
            style: AppTextStyles.primaryButton.copyWith(
              color: widget.enabled ? AppColors.surface : AppColors.mutedText,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
