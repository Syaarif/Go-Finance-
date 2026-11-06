import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';

/// Reusable icon container standar sistem desain Go Finance.
///
/// Secara default menggunakan bentuk kotak dengan sudut membulat (rounded square).
/// Bentuk lingkaran ([isCircular] = true) hanya boleh digunakan untuk ikon
/// berukuran besar di tengah layar/modal (empty state, ilustrasi utama).
class IconContainer extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final String? imageAsset;
  final Widget? child;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final bool isCircular;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final String? tooltip;
  final Key? actionKey;

  const IconContainer({
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
    this.isCircular = false,
    this.border,
    this.boxShadow,
    this.padding,
    this.onTap,
    this.tooltip,
    this.actionKey,
  });

  Widget _buildIconContent() {
    if (child != null) {
      return child!;
    }
    if (svgAsset != null) {
      return SvgPicture.asset(
        svgAsset!,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }
    if (imageAsset != null) {
      return Image.asset(
        imageAsset!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => Icon(
          icon ?? Icons.savings_outlined,
          color: iconColor,
          size: iconSize,
        ),
      );
    }
    if (icon != null) {
      return Icon(
        icon,
        color: iconColor,
        size: iconSize,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        isCircular ? null : BorderRadius.circular(borderRadius);

    Widget container = Container(
      width: size,
      height: size,
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: effectiveBorderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: _buildIconContent(),
    );

    if (onTap != null) {
      container = Material(
        color: AppColors.transparent,
        child: InkWell(
          key: actionKey,
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          customBorder: isCircular ? const CircleBorder() : null,
          child: container,
        ),
      );
    }

    if (tooltip != null && tooltip!.isNotEmpty) {
      container = Tooltip(
        message: tooltip!,
        child: container,
      );
    }

    return container;
  }
}

