import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/profile_action.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/pages/bills_page.dart';
import 'package:go_finance/features/home/pages/home_page.dart';
import 'package:go_finance/features/transactions/pages/transactions_page.dart';

/// Enum tab utama pada Bottom Navigation Go Finance.
enum NavTab { home, transactions, savings, bills }

// ===== BOTTOM NAV START: pakai di halaman lain =====
// Pada Scaffold: bottomNavigationBar: AppBottomNav(currentIndex: NavTab.bills)

/// Bottom Navigation Bar reusable Go Finance dengan tombol tengah "Scan".
class AppBottomNav extends StatelessWidget {
  final NavTab currentIndex;
  final ValueChanged<NavTab>? onTap;
  final VoidCallback? onScanTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.onScanTap,
  });

  /// Navigasi terpusat antar halaman utama aplikasi.
  static void navigateTo(BuildContext context, NavTab tab) {
    final Widget destination;
    switch (tab) {
      case NavTab.home:
        destination = const HomePage();
        break;
      case NavTab.transactions:
        destination = const TransactionsPage();
        break;
      case NavTab.savings:
        destination = const MainTabPlaceholderPage(
          tab: NavTab.savings,
          title: 'Tabungan',
          subtitle: 'Target dan progres tabunganmu akan tampil di sini.',
        );
        break;
      case NavTab.bills:
        destination = const BillsPage();
        break;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionDuration: const Duration(milliseconds: 180),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _handleTabTap(BuildContext context, NavTab tab) {
    if (onTap != null) {
      onTap!(tab);
      return;
    }
    if (tab == currentIndex) return;
    navigateTo(context, tab);
  }

  void _handleScanTap(BuildContext context) {
    if (onScanTap != null) {
      onScanTap!();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fitur Scan struk segera hadir.',
          style: AppTextStyles.primaryButton,
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Container(
          height: AppSpacing.bottomNavHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusNav),
            border: Border.all(
              color: AppColors.border,
              width: AppSpacing.borderThin,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: AppSpacing.md,
                offset: Offset(0, -AppSpacing.xxs),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavBarItem(
                  label: 'Beranda',
                  assetPath: 'assets/svg/nav_home.svg',
                  isActive: currentIndex == NavTab.home,
                  onTap: () => _handleTabTap(context, NavTab.home),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  label: 'Transaksi',
                  assetPath: 'assets/svg/nav_transactions.svg',
                  isActive: currentIndex == NavTab.transactions,
                  onTap: () => _handleTabTap(context, NavTab.transactions),
                ),
              ),
              // Tombol tengah FAB Scan (#347928)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: _ScanCenterButton(
                  onTap: () => _handleScanTap(context),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  label: 'Tabungan',
                  assetPath: 'assets/svg/nav_savings.svg',
                  isActive: currentIndex == NavTab.savings,
                  onTap: () => _handleTabTap(context, NavTab.savings),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  label: 'Tagihan',
                  assetPath: 'assets/svg/nav_bills.svg',
                  isActive: currentIndex == NavTab.bills,
                  onTap: () => _handleTabTap(context, NavTab.bills),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.label,
    required this.assetPath,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.mutedText;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                assetPath,
                width: AppSpacing.navIconSize,
                height: AppSpacing.navIconSize,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.navLabel(isActive: isActive),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanCenterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ScanCenterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppSpacing.fabSize,
          height: AppSpacing.fabSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/scan.svg',
                width: AppSpacing.xl,
                height: AppSpacing.xl,
                colorFilter: const ColorFilter.mode(
                  AppColors.surface,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text('Scan', style: AppTextStyles.scanLabel),
            ],
          ),
        ),
      ),
    );
  }
}

/// Halaman placeholder untuk tab selain Tagihan (Beranda, Transaksi, Tabungan).
class MainTabPlaceholderPage extends StatelessWidget {
  final NavTab tab;
  final String title;
  final String subtitle;

  const MainTabPlaceholderPage({
    super.key,
    required this.tab,
    required this.title,
    required this.subtitle,
  });

  String _iconAssetForTab(NavTab currentTab) {
    switch (currentTab) {
      case NavTab.home:
        return 'assets/svg/nav_home.svg';
      case NavTab.transactions:
        return 'assets/svg/nav_transactions.svg';
      case NavTab.savings:
        return 'assets/svg/nav_savings.svg';
      case NavTab.bills:
        return 'assets/svg/nav_bills.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.pageTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const ProfileAction(),
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusCard),
                      border: Border.all(
                        color: AppColors.border,
                        width: AppSpacing.borderThin,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoundedSquareIcon(
                          svgAsset: _iconAssetForTab(tab),
                          backgroundColor: AppColors.softSurface,
                          iconColor: AppColors.primary,
                          size: AppSpacing.billIconCircleSize,
                          iconSize: AppSpacing.billIconSize,
                          borderRadius: AppSpacing.radiusSm,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(title, style: AppTextStyles.sectionTitle),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          subtitle,
                          style: AppTextStyles.footnote,
                          textAlign: TextAlign.center,
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
      // ===== BOTTOM NAV START: pakai di halaman lain =====
      bottomNavigationBar: AppBottomNav(currentIndex: tab),
    );
  }
}

