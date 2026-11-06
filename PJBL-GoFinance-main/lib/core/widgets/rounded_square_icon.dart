import 'package:flutter/material.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/widgets/icon_container.dart';

/// Komponen ikon dengan background kotak bersudut membulat (rounded square)
/// sesuai standar desain Go Finance untuk ikon kecil pada menu, kategori,
/// kartu, daftar, dan tombol aksi.
class RoundedSquareIcon extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final String? imageAsset;
  final Widget? child;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final String? tooltip;
  final Key? actionKey;

  const RoundedSquareIcon({
    super.key,
    this.icon,
    this.svgAsset,
    this.imageAsset,
    this.child,
    this.backgroundColor = AppColors.softSurface,
    this.iconColor = AppColors.deepGreen,
    this.size = 40.0,
    this.iconSize = 20.0,
    this.borderRadius = AppSpacing.radiusSm,
    this.border,
    this.boxShadow,
    this.padding,
    this.onTap,
    this.tooltip,
    this.actionKey,
  });

  @override
  Widget build(BuildContext context) {
    return IconContainer(
      actionKey: actionKey,
      icon: icon,
      svgAsset: svgAsset,
      imageAsset: imageAsset,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      size: size,
      iconSize: iconSize,
      borderRadius: borderRadius,
      isCircular: false,
      border: border,
      boxShadow: boxShadow,
      padding: padding,
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }
}

