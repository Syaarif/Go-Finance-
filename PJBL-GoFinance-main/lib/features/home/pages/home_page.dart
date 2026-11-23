import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
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
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// Halaman Beranda / Home (01_Beranda).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _isBalanceVisible = true;
  int? _selectedChartDayIndex;
  String _userName = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await AwsApiService.instance.getMyProfile();
      if (!mounted) return;
      final fullName =
          (profile['full_name'] ?? profile['name'] ?? '').toString().trim();
      if (fullName.isNotEmpty) {
        setState(() => _userName = fullName.split(' ').first);
      }
    } catch (_) {}
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
            ).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
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

  void _showAiInsightSheet(List<TransactionModel> transactions) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.canvas.withValues(alpha: 0),
      isScrollControlled: true,
      builder: (ctx) => _AiInsightModal(
        transactions: transactions,
        onAction: () {
          Navigator.pop(ctx);
          _goToTransactionsTab();
        },
      ),
    );
  }

  void _showNotificationSheet(List<TransactionModel> transactions) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.canvas.withValues(alpha: 0),
      builder: (_) => _NotificationModal(transactions: transactions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final txProvider = context.watch<TransactionProvider>();
    final allTransactions = txProvider.allTransactions;
    final recentTransactions = allTransactions.take(3).toList();

    final double dynamicBalance = txProvider.saldoAktif;
    final double savingsBalance = txProvider.saldoTabungan;

    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.lg,
                  AppSpacing.pageHorizontal,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/piggy_coin.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.savings_rounded,
                        color: context.colors.primaryText,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Go Finance',
                        style: AppTextStyles.pageTitle.copyWith(
                          color: context.colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        RoundedSquareIcon(
                          icon: Icons.notifications_none_rounded,
                          backgroundColor: context.colors.surface,
                          iconColor: context.colors.textPrimary,
                          size: 40,
                          iconSize: 20,
                          borderRadius: AppSpacing.radiusSm,
                          border: Border.all(
                            color: context.colors.border,
                            width: AppSpacing.borderThin,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.cardShadow,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          tooltip: l10n.notifications,
                          onTap: () => _showNotificationSheet(allTransactions),
                        ),
                        if (recentTransactions.isNotEmpty)
                          Positioned(
                            top: 9,
                            right: 10,
                            child: IgnorePointer(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: context.colors.negative,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const ProfileAction(),
                  ],
                ),
              ),
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
                          l10n.greeting(_userName),
                          style: AppTextStyles.pageTitle.copyWith(
                            color: context.colors.textPrimary,
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
                      l10n.homeGreetingSubtitle,
                      style: AppTextStyles.footnote.copyWith(
                        fontSize: 13,
                        color: context.colors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: _AiEvaluationCard(
                  transactions: allTransactions,
                  onTap: () => _showAiInsightSheet(allTransactions),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: _ChartCard(
                  transactions: allTransactions,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.edit_note_rounded,
                        label: l10n.manualEntry,
                        onTap: _openAddTransaction,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: l10n.payBill,
                        onTap: _openBillsPage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.recentTransactions,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToTransactionsTab,
                      child: Text(
                        l10n.seeAll,
                        style: AppTextStyles.sectionAction.copyWith(
                          color: context.colors.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                    border: Border.all(color: context.colors.border),
                    boxShadow: [
                      BoxShadow(
                        color:
                            context.colors.deepGreen.withValues(alpha: 0.024),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: recentTransactions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.xl,
                          ),
                          child: Center(
                            child: Text(
                              'Belum ada transaksi tercatat.',
                              style: AppTextStyles.footnote.copyWith(
                                color: context.colors.mutedText,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children:
                              List.generate(recentTransactions.length, (i) {
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
                                    color: context.colors.border
                                        .withValues(alpha: 0.6),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatted = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(balance);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusNav),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? context.colors.primaryText : Colors.white,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.activeBalance.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
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
                              color: Colors.white.withValues(alpha: 0.85),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
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
                      Text(
                        l10n.balanceCalculation,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.surface,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/piggy_coin.png',
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.savings_rounded,
                        color: context.colors.primaryText,
                        size: 32,
                      ),
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

class _SaldoTabunganCard extends StatelessWidget {
  final double balance;
  final VoidCallback onTap;
  const _SaldoTabunganCard({
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final formattedBalance = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(balance);
    return Material(
      color: context.colors.surface,
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
            border: Border.all(color: context.colors.border),
            boxShadow: [
              BoxShadow(
                color: context.colors.deepGreen.withValues(alpha: 0.024),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              RoundedSquareIcon(
                imageAsset: 'assets/images/piggy_coin.png',
                icon: Icons.savings_outlined,
                backgroundColor: context.colors.softSurface,
                iconColor: context.colors.primaryText,
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
                      l10n.savingsBalance,
                      style: AppTextStyles.footnote.copyWith(
                        fontSize: 12,
                        color: context.colors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedBalance,
                      style: AppTextStyles.billAmount.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiEvaluationCard extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onTap;

  const _AiEvaluationCard({
    required this.transactions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();

    final double totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final String summaryText = transactions.isEmpty
        ? 'Catat transaksi pertamamu untuk analisis otomatis'
        : 'Total pengeluaran tercatat: ${NumberFormat.currency(locale: locale, symbol: 'Rp ', decimalDigits: 0).format(totalExpense)}';

    return Material(
      color: context.colors.surface,
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
            border: Border.all(color: context.colors.border),
            boxShadow: [
              BoxShadow(
                color: context.colors.deepGreen.withValues(alpha: 0.024),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedSquareIcon(
                icon: Icons.auto_awesome,
                backgroundColor:
                    isDark ? context.colors.todayFill : const Color(0xFFFBF4E8),
                iconColor:
                    isDark ? context.colors.todayRing : const Color(0xFFC28B38),
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
                      l10n.monthlyAiEvaluation,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      summaryText,
                      style: AppTextStyles.footnote.copyWith(
                        fontSize: 12,
                        color: context.colors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.aiSummaryHint,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.primaryText,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final List<TransactionModel> transactions;
  final int? selectedDayIndex;
  final ValueChanged<int> onSelectDay;
  final VoidCallback onDetailTap;

  const _ChartCard({
    required this.transactions,
    required this.selectedDayIndex,
    required this.onSelectDay,
    required this.onDetailTap,
  });

  List _buildLast7DaysData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      double income = 0;
      double expense = 0;
      for (final tx in transactions) {
        if (tx.date.year == day.year &&
            tx.date.month == day.month &&
            tx.date.day == day.day) {
          if (tx.isIncome) {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }
      }
      return {
        'date': day,
        'in': income.round(),
        'out': expense.round(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outflowColor =
        isDark ? context.colors.mutedText : const Color(0xFF7B8F77);

    final chartData = _buildLast7DaysData();
    int highest = 100000;
    for (final d in chartData) {
      final inVal = d['in'] as int;
      final outVal = d['out'] as int;
      if (inVal > highest) highest = inVal;
      if (outVal > highest) highest = outVal;
    }
    final double maxVal = highest.toDouble();
    const double chartHeight = 90.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.deepGreen.withValues(alpha: 0.024),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.lastSevenDays,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: context.colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: onDetailTap,
                child: Text(
                  l10n.detail,
                  style: AppTextStyles.sectionAction.copyWith(
                    color: context.colors.primaryText,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (selectedDayIndex != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              decoration: BoxDecoration(
                color: context.colors.softSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: context.colors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.chartIncome(
                      DateFormat('EEE', locale).format(
                        chartData[selectedDayIndex!]['date'] as DateTime,
                      ),
                      _formatShort(
                        chartData[selectedDayIndex!]['in'] as int,
                        locale,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primaryText,
                    ),
                  ),
                  Text(
                    l10n.chartExpense(
                      _formatShort(
                        chartData[selectedDayIndex!]['out'] as int,
                        locale,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: chartHeight + 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(chartData.length, (i) {
                final d = chartData[i];
                final int inVal = d['in'] as int;
                final int outVal = d['out'] as int;
                final double inH = inVal == 0
                    ? 6
                    : ((inVal / maxVal) * chartHeight).clamp(8, chartHeight);
                final double outH = outVal == 0
                    ? 6
                    : ((outVal / maxVal) * chartHeight).clamp(8, chartHeight);
                final bool isSelected = selectedDayIndex == i;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelectDay(i);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 10,
                            height: inH,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.colors.primary
                                  : context.colors.primary
                                      .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(4),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 1.5)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 10,
                            height: outH,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                      ? context.colors.mutedText
                                      : const Color(0xFF5A7555))
                                  : outflowColor,
                              borderRadius: BorderRadius.circular(4),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 1.5)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('EEE', locale).format(d['date'] as DateTime),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? context.colors.textPrimary
                              : context.colors.mutedText,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.income,
                style: AppTextStyles.footnote.copyWith(
                  color: context.colors.mutedText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: outflowColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.expense,
                style: AppTextStyles.footnote.copyWith(
                  color: context.colors.mutedText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatShort(int value, String locale) =>
      NumberFormat.compact(locale: locale).format(value);
}

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
            color: context.colors.softSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedSquareIcon(
                icon: widget.icon,
                backgroundColor: context.colors.surface,
                iconColor: context.colors.primaryText,
                size: 32,
                iconSize: 18,
                borderRadius: AppSpacing.radiusXs,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTransactionTile extends StatelessWidget {
  final TransactionModel tx;
  const _HomeTransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final amountColor =
        tx.isIncome ? context.colors.primaryText : context.colors.textPrimary;
    final amountPrefix = tx.isIncome ? '+' : '−';
    final formatted = NumberFormat.currency(
      locale: locale,
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
                    style: AppTextStyles.billName.copyWith(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.todayAt(DateFormat.jm(locale).format(tx.date)),
                    style: AppTextStyles.footnote.copyWith(
                      color: context.colors.mutedText,
                      fontSize: 11,
                    ),
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

class _AiInsightModal extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onAction;

  const _AiInsightModal({
    required this.transactions,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final fmt = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final double totalIn = transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final double totalOut = transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);

    final String insightText = transactions.isEmpty
        ? 'Belum ada data transaksi untuk dievaluasi. Mulai catat pemasukan dan pengeluaranmu agar sistem dapat menganalisis pola keuanganmu.'
        : 'Total pemasukanmu ${fmt.format(totalIn)} dan pengeluaranmu ${fmt.format(totalOut)}. Pertahankan rasio tabungan minimal 20% dari pemasukan bulanan.';

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
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
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              RoundedSquareIcon(
                icon: Icons.auto_awesome,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? context.colors.todayFill
                    : const Color(0xFFFBF4E8),
                iconColor: Theme.of(context).brightness == Brightness.dark
                    ? context.colors.todayRing
                    : const Color(0xFFC28B38),
                size: 40,
                iconSize: 22,
                borderRadius: AppSpacing.radiusSm,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiAnalysisTitle,
                      style: AppTextStyles.sheetTitle.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      l10n.aiBasedOnMonth,
                      style: AppTextStyles.footnote.copyWith(
                        color: context.colors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.softSurface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.smartRecommendation,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  insightText,
                  style: AppTextStyles.footnote.copyWith(
                    fontSize: 12,
                    color: context.colors.textPrimary,
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
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                l10n.viewTransactionDetails,
                style: AppTextStyles.primaryButton.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationModal extends StatelessWidget {
  final List<TransactionModel> transactions;
  const _NotificationModal({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final fmt = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final recent = transactions.take(3).toList();

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
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
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            l10n.notifications,
            style: AppTextStyles.sheetTitle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                'Belum ada notifikasi aktivitas terbaru.',
                style: AppTextStyles.footnote.copyWith(
                  color: context.colors.mutedText,
                ),
              ),
            )
          else
            ...recent.map(
              (tx) => _NotifTile(
                title: tx.isIncome ? 'Pemasukan Tercatat' : 'Pengeluaran Tercatat',
                subtitle: '${tx.title} • ${fmt.format(tx.amount)}',
                time: DateFormat('dd MMM, HH:mm', locale).format(tx.date),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                l10n.close,
                style: AppTextStyles.primaryButton.copyWith(
                  color: Colors.white,
                ),
              ),
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
          RoundedSquareIcon(
            icon: Icons.notifications_none_rounded,
            backgroundColor: context.colors.softSurface,
            iconColor: context.colors.primaryText,
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
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.footnote.copyWith(
                    color: context.colors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.footnote.copyWith(
              color: context.colors.mutedText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}