import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/bottom_nav_bar.dart';
import 'package:go_finance/core/widgets/profile_action.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';
import 'package:go_finance/features/transactions/pages/add_transaction_page.dart';
import 'package:go_finance/features/home/widgets/tabungan_action_sheet.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';

/// Halaman Beranda / Home (01_Beranda).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _isBalanceVisible = true;
  int? _selectedChartDayIndex; // untuk tooltip interaktif pada chart

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }



  void _openAddTransaction() async {
    final provider = context.read<TransactionProvider>();
    final tx = await Navigator.of(context).push<TransactionModel>(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: const AddTransactionPage(),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
    if (tx != null) {
      provider.addTransaction(tx);
    }
  }

  void _openBillsPage() {
    AppBottomNav.navigateTo(context, NavTab.bills);
  }

  void _goToTransactionsTab() {
    AppBottomNav.navigateTo(context, NavTab.transactions);
  }

  void _showAiInsightSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _AiInsightModal(onAction: () {
        Navigator.pop(ctx);
        _goToTransactionsTab();
      }),
    );
  }

  void _showNotificationSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NotificationModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final recentTransactions = txProvider.filtered.take(3).toList();

    // Ambil saldo aktif & saldo tabungan langsung dari storage permanen
    final double dynamicBalance = txProvider.saldoAktif;
    final double savingsBalance = txProvider.saldoTabungan;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 1. TOP BAR =====
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.lg,
                  AppSpacing.pageHorizontal,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    // Piggy Logo
                    Image.asset(
                      'assets/images/piggy_coin.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.savings_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Go Finance',
                        style: AppTextStyles.pageTitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Notification Bell with interactive badge (Rounded Square)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        RoundedSquareIcon(
                          icon: Icons.notifications_none_rounded,
                          backgroundColor: AppColors.surface,
                          iconColor: AppColors.deepGreen,
                          size: 40,
                          iconSize: 20,
                          borderRadius: AppSpacing.radiusSm,
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
                          tooltip: 'Notifikasi',
                          onTap: _showNotificationSheet,
                        ),
                        Positioned(
                          top: 9,
                          right: 10,
                          child: IgnorePointer(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.negative,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Profile Action di pojok kanan atas
                    const ProfileAction(),
                  ],
                ),
              ),

              // ===== 2. GREETING =====
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.sm,
                  AppSpacing.pageHorizontal,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Halo, Wowowi',
                          style: AppTextStyles.pageTitle.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('👋', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Yuk, kelola keuanganmu dengan bijak.',
                      style: AppTextStyles.footnote.copyWith(
                        fontSize: 13,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== 3. SALDO AKTIF CARD =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: _SaldoAktifCard(
                  balance: dynamicBalance,
                  isVisible: _isBalanceVisible,
                  onToggleVisibility: () {
                    HapticFeedback.selectionClick();
                    setState(() => _isBalanceVisible = !_isBalanceVisible);
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ===== 4. SALDO TABUNGAN CARD =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: _SaldoTabunganCard(
                  balance: savingsBalance,
                  onTap: () => TabunganActionSheet.show(context),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ===== 5. EVALUASI KEUANGAN AI CARD =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: _AiEvaluationCard(
                  onTap: _showAiInsightSheet,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ===== 6. RINGKASAN 7 HARI TERAKHIR (CHART) =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: _ChartCard(
                  selectedDayIndex: _selectedChartDayIndex,
                  onSelectDay: (idx) {
                    setState(() {
                      _selectedChartDayIndex =
                          _selectedChartDayIndex == idx ? null : idx;
                    });
                  },
                  onDetailTap: _goToTransactionsTab,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ===== 7. QUICK ACTION BUTTONS =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.edit_note_rounded,
                        label: 'Catat Manual',
                        onTap: _openAddTransaction,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: 'Bayar Tagihan',
                        onTap: _openBillsPage,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ===== 8. TRANSAKSI TERBARU =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaksi Terbaru',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToTransactionsTab,
                      child: Text(
                        'Lihat semua',
                        style: AppTextStyles.sectionAction.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Transaction Items
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06234D1C),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(recentTransactions.length, (i) {
                      final tx = recentTransactions[i];
                      final isLast = i == recentTransactions.length - 1;
                      return Column(
                        children: [
                          _HomeTransactionTile(tx: tx),
                          if (!isLast)
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 56,
                              endIndent: AppSpacing.md,
                              color: AppColors.border.withOpacity(0.6),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: NavTab.home),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// CARD 1: SALDO AKTIF
// ───────────────────────────────────────────────────────────────
class _SaldoAktifCard extends StatelessWidget {
  final double balance;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const _SaldoAktifCard({
    required this.balance,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(balance);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusNav),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle pattern
          Positioned(
            right: -10,
            top: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header "SALDO AKTIF" + Eye toggle
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SALDO AKTIF',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onToggleVisibility,
                            child: Icon(
                              isVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white.withOpacity(0.85),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Nominal
                      Text(
                        isVisible ? formatted : 'Rp ••••••••',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Subtitle
                      Text(
                        'Pemasukan − pengeluaran − setoran tabungan',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Decorative Circle Graphic with piggy
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.18),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/piggy_coin.png',
                          width: 44,
                          height: 44,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.savings_rounded,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// CARD 2: SALDO TABUNGAN
// ───────────────────────────────────────────────────────────────
class _SaldoTabunganCard extends StatelessWidget {
  final double balance;
  final VoidCallback onTap;
  const _SaldoTabunganCard({
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBalance = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(balance);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06234D1C),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Piggy icon dengan rounded square container
              const RoundedSquareIcon(
                imageAsset: 'assets/images/piggy_coin.png',
                icon: Icons.savings_outlined,
                backgroundColor: AppColors.softSurface,
                iconColor: AppColors.primary,
                size: AppSpacing.billIconCircleSize,
                iconSize: 26,
                borderRadius: AppSpacing.radiusSm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo tabungan',
                      style: AppTextStyles.footnote.copyWith(
                        fontSize: 12,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedBalance,
                      style: AppTextStyles.billAmount.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// CARD 3: EVALUASI KEUANGAN AI
// ───────────────────────────────────────────────────────────────
class _AiEvaluationCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AiEvaluationCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06234D1C),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Bronze/Gold Star Icon dengan rounded square container
              const RoundedSquareIcon(
                icon: Icons.auto_awesome,
                backgroundColor: Color(0xFFFBF4E8),
                iconColor: Color(0xFFC28B38),
                size: AppSpacing.billIconCircleSize,
                iconSize: AppSpacing.billIconSize,
                borderRadius: AppSpacing.radiusSm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evaluasi Keuangan Bulan Ini',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Pengeluaran makan naik 8% dari bulan lalu.',
                      style: AppTextStyles.footnote.copyWith(
                        fontSize: 12,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Lihat ringkasan dan saran AI',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// CARD 4: RINGKASAN 7 HARI TERAKHIR (CHART)
// ───────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  final int? selectedDayIndex;
  final ValueChanged<int> onSelectDay;
  final VoidCallback onDetailTap;

  const _ChartCard({
    required this.selectedDayIndex,
    required this.onSelectDay,
    required this.onDetailTap,
  });

  static const List<Map<String, dynamic>> _chartData = [
    {'day': 'Sen', 'in': 180000, 'out': 120000},
    {'day': 'Sel', 'in': 140000, 'out': 220000},
    {'day': 'Rab', 'in': 320000, 'out': 110000},
    {'day': 'Kam', 'in': 190000, 'out': 195000},
    {'day': 'Jum', 'in': 280000, 'out': 130000},
    {'day': 'Sab', 'in': 450000, 'out': 180000},
    {'day': 'Min', 'in': 290000, 'out': 150000},
  ];

  @override
  Widget build(BuildContext context) {
    const double maxVal = 500000;
    const double chartHeight = 90.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06234D1C),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Judul & Detail link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan 7 Hari Terakhir',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: onDetailTap,
                child: Text(
                  'Detail',
                  style: AppTextStyles.sectionAction.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Tooltip jika hari tertentu ditekan
          if (selectedDayIndex != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_chartData[selectedDayIndex!]['day']}: Masuk Rp ${_formatShort(_chartData[selectedDayIndex!]['in'])}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Keluar Rp ${_formatShort(_chartData[selectedDayIndex!]['out'])}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

          // Bar chart
          SizedBox(
            height: chartHeight + 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_chartData.length, (i) {
                final d = _chartData[i];
                final double inH = (d['in'] / maxVal) * chartHeight;
                final double outH = (d['out'] / maxVal) * chartHeight;
                final bool isSelected = selectedDayIndex == i;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelectDay(i);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Dual bars
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // In bar (Green)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 10,
                            height: inH.clamp(8, chartHeight),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 1.5)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Out bar (Slate gray-green)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 10,
                            height: outH.clamp(8, chartHeight),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF5A7555)
                                  : const Color(0xFF7B8F77),
                              borderRadius: BorderRadius.circular(4),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 1.5)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Day label
                      Text(
                        d['day'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.deepGreen
                              : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Legend
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text('Pemasukan',
                  style: AppTextStyles.footnote.copyWith(fontSize: 11)),
              const SizedBox(width: AppSpacing.lg),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7B8F77),
                ),
              ),
              const SizedBox(width: 6),
              Text('Pengeluaran',
                  style: AppTextStyles.footnote.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatShort(dynamic val) {
    final n = (val as num).toInt();
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(0)}rb';
    }
    return n.toString();
  }
}

// ───────────────────────────────────────────────────────────────
// QUICK ACTION BUTTON
// ───────────────────────────────────────────────────────────────
class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
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
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
        HapticFeedback.lightImpact();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.softSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedSquareIcon(
                icon: widget.icon,
                backgroundColor: AppColors.surface,
                iconColor: AppColors.primary,
                size: 32,
                iconSize: 18,
                borderRadius: AppSpacing.radiusXs,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// HOME TRANSACTION TILE
// ───────────────────────────────────────────────────────────────
class _HomeTransactionTile extends StatelessWidget {
  final TransactionModel tx;
  const _HomeTransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final amountColor =
        tx.isIncome ? AppColors.primary : AppColors.deepGreen;
    final amountPrefix = tx.isIncome ? '+' : '−';
    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(tx.amount);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            RoundedSquareIcon(
              icon: tx.category.icon,
              backgroundColor: tx.category.iconBg,
              iconColor: tx.category.iconColor,
              size: 40,
              iconSize: 20,
              borderRadius: AppSpacing.radiusSm,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: AppTextStyles.billName.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hari ini · ${DateFormat('HH:mm').format(tx.date)}',
                    style: AppTextStyles.footnote.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix$formatted',
              style: AppTextStyles.billAmount.copyWith(
                color: amountColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// AI INSIGHT MODAL
// ───────────────────────────────────────────────────────────────
class _AiInsightModal extends StatelessWidget {
  final VoidCallback onAction;
  const _AiInsightModal({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const RoundedSquareIcon(
                icon: Icons.auto_awesome,
                backgroundColor: Color(0xFFFBF4E8),
                iconColor: Color(0xFFC28B38),
                size: 40,
                iconSize: 22,
                borderRadius: AppSpacing.radiusSm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Analisis AI Go Finance', style: AppTextStyles.sheetTitle),
                    Text('Berdasarkan pengeluaran bulan ini',
                        style: AppTextStyles.footnote),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Rekomendasi Pintar',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepGreen,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pengeluaran makanan & minuman kamu mencapai 42% dari total pengeluaran bulan ini. Coba batasi pesanan pesan-antar maksimal 2 kali seminggu untuk menghemat sekitar Rp 400.000.',
                  style: AppTextStyles.footnote.copyWith(
                    fontSize: 12,
                    color: AppColors.deepGreen,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Lihat Rincian Transaksi',
                style: AppTextStyles.primaryButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// NOTIFICATION MODAL
// ───────────────────────────────────────────────────────────────
class _NotificationModal extends StatelessWidget {
  const _NotificationModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Notifikasi', style: AppTextStyles.sheetTitle),
          const SizedBox(height: AppSpacing.md),
          _NotifTile(
            title: 'Tagihan Internet Jatuh Tempo',
            subtitle: 'Jatuh tempo pada 29 Oktober 2026 sebesar Rp 300.000',
            time: '2 jam lalu',
          ),
          _NotifTile(
            title: 'Gaji Masuk!',
            subtitle: 'Pemasukan Rp 3.500.000 berhasil dicatat.',
            time: 'Kemarin',
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('Tutup', style: AppTextStyles.primaryButton),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _NotifTile({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RoundedSquareIcon(
            icon: Icons.notifications_none_rounded,
            backgroundColor: AppColors.softSurface,
            iconColor: AppColors.primary,
            size: 36,
            iconSize: 18,
            borderRadius: AppSpacing.radiusSm,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.deepGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.footnote),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.footnote.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
