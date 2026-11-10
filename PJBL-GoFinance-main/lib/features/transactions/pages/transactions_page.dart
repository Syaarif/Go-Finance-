import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/bottom_nav_bar.dart';
import 'package:go_finance/core/widgets/icon_container.dart';
import 'package:go_finance/core/widgets/profile_action.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';
import 'package:go_finance/features/transactions/pages/add_transaction_page.dart';

/// Halaman utama daftar transaksi (02_Transaksi).
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {
  late final AnimationController _headerAnim;
  late final AnimationController _listAnim;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
    _listAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _listAnim.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _TransactionsView();
  }
}

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();

  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView>
    with TickerProviderStateMixin {
  late final AnimationController _fabAnim;
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 10;
      if (show != _showShadow) setState(() => _showShadow = show);
    });
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openAddTransaction() async {
    final provider = context.read<TransactionProvider>();
    await Navigator.of(context).push<TransactionModel>(
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
    ).then((tx) {
      if (tx != null) provider.addTransaction(tx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final grouped = provider.groupedByDate;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Column(
        children: [
          // ===== STICKY HEADER =====
          _StickyHeader(
            showShadow: _showShadow,
            searchController: _searchController,
            onAddTap: _openAddTransaction,
          ),

          // ===== CONTENT LIST =====
          Expanded(
            child: grouped.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: AppSpacing.pageHorizontal,
                      right: AppSpacing.pageHorizontal,
                      bottom: AppSpacing.xxl,
                    ),
                    itemCount: grouped.length,
                    itemBuilder: (ctx, i) {
                      final date = grouped.keys.elementAt(i);
                      final txList = grouped[date]!;
                      return _TransactionGroup(
                        date: date,
                        transactions: txList,
                        animIndex: i,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: NavTab.transactions),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// STICKY HEADER (judul + tab + search + kategori chip)
// ───────────────────────────────────────────────────────────────
class _StickyHeader extends StatelessWidget {
  final bool showShadow;
  final TextEditingController searchController;
  final VoidCallback onAddTap;

  const _StickyHeader({
    required this.showShadow,
    required this.searchController,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.deepGreen.withValues(alpha: 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: judul + tombol tambah + profil
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Transaksi',
                      style: AppTextStyles.pageTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _AddButton(onTap: onAddTap),
                  const SizedBox(width: AppSpacing.sm),
                  const ProfileAction(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Tab Harian / Mingguan / Bulanan
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal),
              child: _PeriodTabBar(),
            ),
            const SizedBox(height: AppSpacing.md),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal),
              child: _SearchBar(controller: searchController),
            ),
            const SizedBox(height: AppSpacing.md),
            // Category chips (horizontal scroll)
            const _CategoryChips(),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.88,
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
        child: const RoundedSquareIcon(
          icon: Icons.add_rounded,
          backgroundColor: AppColors.primary,
          iconColor: AppColors.surface,
          size: 40,
          iconSize: 22,
          borderRadius: AppSpacing.radiusSm,
          tooltip: 'Tambah Transaksi',
        ),
      ),
    );
  }
}

class _PeriodTabBar extends StatelessWidget {
  const _PeriodTabBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final tabs = ['Harian', 'Mingguan', 'Bulanan'];
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.softSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = provider.selectedTabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                provider.setTab(i);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusCard - 3),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.surface : AppColors.mutedText,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TransactionProvider>();
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),
          const Icon(Icons.search_rounded,
              color: AppColors.mutedText, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: provider.setSearch,
              style: AppTextStyles.inputText.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari transaksi...',
                hintStyle: AppTextStyles.inputHint.copyWith(fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                provider.setSearch('');
              },
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Icon(Icons.close_rounded,
                    color: AppColors.mutedText, size: 16),
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final cats = [
      TransactionCategory.semua,
      TransactionCategory.makananMinuman,
      TransactionCategory.tagihan,
      TransactionCategory.lainnya,
    ];
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final cat = cats[i];
          final isSelected = provider.selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              provider.setCategory(cat);
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                cat.shortLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.surface : AppColors.mutedText,
                  fontFamily: 'InstrumentSans',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// GROUP PER TANGGAL
// ───────────────────────────────────────────────────────────────
class _TransactionGroup extends StatefulWidget {
  final DateTime date;
  final List<TransactionModel> transactions;
  final int animIndex;

  const _TransactionGroup({
    required this.date,
    required this.transactions,
    required this.animIndex,
  });

  @override
  State<_TransactionGroup> createState() => _TransactionGroupState();
}

class _TransactionGroupState extends State<_TransactionGroup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350 + widget.animIndex * 60),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.animIndex * 50), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Hari Ini';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year &&
        d.month == yesterday.month &&
        d.day == yesterday.day) {
      return 'Kemarin';
    }
    return DateFormat('d MMMM yyyy', 'id_ID').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacing.lg, bottom: AppSpacing.sm),
              child: Text(
                _formatDate(widget.date),
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 14),
              ),
            ),
            Container(
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
                children: List.generate(widget.transactions.length, (i) {
                  final tx = widget.transactions[i];
                  final isLast = i == widget.transactions.length - 1;
                  return Column(
                    children: [
                      _TransactionTile(tx: tx),
                      if (!isLast)
                        Divider(
                          height: 1,
                          thickness: 1,
                          indent: 56,
                          endIndent: AppSpacing.md,
                          color: AppColors.border.withValues(alpha: 0.6),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatefulWidget {
  final TransactionModel tx;
  const _TransactionTile({required this.tx});

  @override
  State<_TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<_TransactionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
    return formatted;
  }

  String _formatTime(DateTime d) => DateFormat('HH:mm').format(d);

  void _showDetail(BuildContext ctx) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => _TransactionDetailSheet(tx: widget.tx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.tx;
    final amountColor =
        tx.isIncome ? AppColors.primary : AppColors.negative;
    final amountPrefix = tx.isIncome ? '+' : '−';

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.reverse(),
      onTapUp: (_) {
        _pressCtrl.forward();
        _showDetail(context);
      },
      onTapCancel: () => _pressCtrl.forward(),
      child: ScaleTransition(
        scale: _pressCtrl,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          child: Row(
            children: [
              // Ikon kategori (rounded square)
              RoundedSquareIcon(
                icon: tx.category.icon,
                backgroundColor: tx.category.iconBg,
                iconColor: tx.category.iconColor,
                size: 40,
                iconSize: 20,
                borderRadius: AppSpacing.radiusSm,
              ),
              const SizedBox(width: AppSpacing.md),
              // Judul & subtitle
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
                      tx.subtitle,
                      style: AppTextStyles.footnote.copyWith(fontSize: 11),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Nominal & waktu
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$amountPrefix${_formatAmount(tx.amount)}',
                    style: AppTextStyles.billAmount.copyWith(
                      color: amountColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(tx.date),
                    style: AppTextStyles.footnote.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// DETAIL SHEET
// ───────────────────────────────────────────────────────────────
class _TransactionDetailSheet extends StatelessWidget {
  final TransactionModel tx;
  const _TransactionDetailSheet({required this.tx});

  String _formatAmount(double amount) => NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(amount);

  @override
  Widget build(BuildContext context) {
    final amountColor = tx.isIncome ? AppColors.primary : AppColors.negative;
    final amountPrefix = tx.isIncome ? '+' : '−';
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Ikon besar
          IconContainer(
            icon: tx.category.icon,
            backgroundColor: tx.category.iconBg,
            iconColor: tx.category.iconColor,
            size: 60,
            iconSize: 30,
            borderRadius: AppSpacing.radiusCard,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(tx.title, style: AppTextStyles.sheetTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$amountPrefix${_formatAmount(tx.amount)}',
            style: AppTextStyles.pageTitle.copyWith(
              color: amountColor,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DetailRow(
              label: 'Tanggal',
              value: DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(tx.date)),
          _DetailRow(label: 'Kategori', value: tx.category.label),
          _DetailRow(
              label: 'Tipe',
              value: tx.isIncome ? 'Pemasukan' : 'Pengeluaran'),
          if (tx.note != null && tx.note!.isNotEmpty)
            _DetailRow(label: 'Catatan', value: tx.note!),
          const SizedBox(height: AppSpacing.xl),
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: AppTextStyles.footnote),
          ),
          Expanded(
            child: Text(value,
                style: AppTextStyles.inputText.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// EMPTY STATE
// ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconContainer(
            icon: Icons.receipt_long_outlined,
            backgroundColor: AppColors.softSurface,
            iconColor: AppColors.primary,
            size: 72,
            iconSize: 36,
            isCircular: true,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Tidak ada transaksi',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
          const SizedBox(height: AppSpacing.xs),
          Text('Belum ada transaksi pada periode ini.',
              style: AppTextStyles.footnote),
        ],
      ),
    );
  }
}
