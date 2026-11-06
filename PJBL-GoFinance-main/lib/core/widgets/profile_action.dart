import 'package:flutter/material.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/screens/profile_screen.dart';

/// Tombol aksi profil pengguna yang konsisten di pojok kanan atas
/// pada setiap halaman utama Go Finance.
class ProfileAction extends StatelessWidget {
  final IconData icon;
  final String? svgAsset;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final VoidCallback? onTap;
  final String tooltip;

  const ProfileAction({
    super.key,
    this.icon = Icons.person_outline_rounded,
    this.svgAsset,
    this.backgroundColor = AppColors.surface,
    this.iconColor = AppColors.deepGreen,
    this.size = 40.0,
    this.iconSize = 20.0,
    this.borderRadius = AppSpacing.radiusSm,
    this.onTap,
    this.tooltip = 'Profil & Pengaturan',
  });

  void _defaultNavigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoundedSquareIcon(
      actionKey: const Key('btn_open_profile'),
      icon: icon,
      svgAsset: svgAsset,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      size: size,
      iconSize: iconSize,
      borderRadius: borderRadius,
      border: Border.all(
        color: AppColors.border,
        width: AppSpacing.borderThin,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
      tooltip: tooltip,
      onTap: onTap ?? () => _defaultNavigateToProfile(context),
    );
  }
}

