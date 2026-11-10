import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';
import 'package:go_finance/features/transactions/pages/numpad_page.dart';

/// Halaman form tambah transaksi (03_Tambah_Transaksi).
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  TransactionType _type = TransactionType.pengeluaran;
  TransactionCategory? _selectedCategory;
  double _amount = 0;
  DateTime _date = DateTime.now();
  final _noteController = TextEditingController();
  final _noteFocus = FocusNode();

  String get _formattedAmount {
    if (_amount == 0) return 'Rp 0';
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(_amount);
  }

  String get _formattedDate {
    return DateFormat('d MMMM yyyy', 'id_ID').format(_date);
  }

  bool get _isValid =>
      _selectedCategory != null && _amount > 0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _noteController.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  Future<void> _openNumpad() async {
    final result = await Navigator.of(context).push<double>(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: NumpadPage(initialAmount: _amount),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (result != null) setState(() => _amount = result);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.surface,
            surface: AppColors.canvas,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickCategory() async {
    final result = await showModalBottomSheet<TransactionCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CategoryPicker(selected: _selectedCategory),
    );
    if (result != null) setState(() => _selectedCategory = result);
  }

  void _save() {
    if (!_isValid) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lengkapi kategori dan nominal terlebih dahulu.',
              style: AppTextStyles.primaryButton),
          backgroundColor: AppColors.negative,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _selectedCategory!.label,
      subtitle: _selectedCategory!.label,
      amount: _amount,
      type: _type,
      category: _selectedCategory!,
      date: DateTime(
        _date.year, _date.month, _date.day,
        DateTime.now().hour, DateTime.now().minute,
      ),
      note: _noteController.text.trim(),
    );
    Navigator.of(context).pop(tx);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              // ===== APP BAR =====
              _FormAppBar(onBack: () => Navigator.pop(context)),

              // ===== TYPE TOGGLE =====
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal, vertical: AppSpacing.sm),
                child: _TypeToggle(
                  selected: _type,
                  onChanged: (t) => setState(() => _type = t),
                ),
              ),

              // ===== FORM BODY =====
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageHorizontal),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, child) => FadeTransition(
                      opacity: _anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.06),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                            parent: _anim, curve: Curves.easeOutCubic)),
                        child: child,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.sm),

                        // --- Kategori ---
                        const _FieldLabel('Kategori'),
                        const SizedBox(height: AppSpacing.xs),
                        _CategoryField(
                          selected: _selectedCategory,
                          onTap: _pickCategory,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // --- Nominal ---
                        const _FieldLabel('Nominal'),
                        const SizedBox(height: AppSpacing.xs),
                        _AmountField(
                          amount: _formattedAmount,
                          onTap: _openNumpad,
                          isEmpty: _amount == 0,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // --- Tanggal ---
                        const _FieldLabel('Tanggal transaksi'),
                        const SizedBox(height: AppSpacing.xs),
                        _DateField(
                          date: _formattedDate,
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // --- Catatan ---
                        const _FieldLabel('Catatan (opsional)'),
                        const SizedBox(height: AppSpacing.xs),
                        _NoteField(
                          controller: _noteController,
                          focusNode: _noteFocus,
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // --- Tombol Simpan ---
                        _SaveButton(
                          enabled: _isValid,
                          onTap: _save,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Center(
                          child: Text(
                            'Data dapat diedit kembali di riwayat transaksi.',
                            style: AppTextStyles.footnote.copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
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
// SUB-WIDGET FORM
// ───────────────────────────────────────────────────────────────
class _FormAppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _FormAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal, 16, AppSpacing.pageHorizontal, 0),
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
              onBack();
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Text('Tambah Transaksi', style: AppTextStyles.pageTitle),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const _TypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.softSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: TransactionType.values.map((t) {
          final isActive = selected == t;
          final label = t == TransactionType.pemasukan ? 'Pemasukan' : 'Pengeluaran';
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onChanged(t);
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
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.surface : AppColors.mutedText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.fieldLabel);
  }
}

class _CategoryField extends StatelessWidget {
  final TransactionCategory? selected;
  final VoidCallback onTap;

  const _CategoryField({this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        HapticFeedback.selectionClick();
      },
      child: Container(
        height: AppSpacing.inputHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            if (selected != null) ...[
              RoundedSquareIcon(
                icon: selected!.icon,
                backgroundColor: selected!.iconBg,
                iconColor: selected!.iconColor,
                size: 32,
                iconSize: 18,
                borderRadius: AppSpacing.radiusXs,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(selected!.label, style: AppTextStyles.inputText),
              ),
            ] else ...[
              const RoundedSquareIcon(
                icon: Icons.emoji_emotions_outlined,
                backgroundColor: AppColors.softSurface,
                iconColor: AppColors.mutedText,
                size: 32,
                iconSize: 18,
                borderRadius: AppSpacing.radiusXs,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('Pilih kategori', style: AppTextStyles.inputHint),
              ),
            ],
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.mutedText, size: 18),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatefulWidget {
  final String amount;
  final VoidCallback onTap;
  final bool isEmpty;

  const _AmountField({
    required this.amount,
    required this.onTap,
    required this.isEmpty,
  });

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppSpacing.nominalInputHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: widget.isEmpty ? AppColors.border : AppColors.primary,
            width: widget.isEmpty ? 1.0 : 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.amount,
                style: widget.isEmpty
                    ? AppTextStyles.inputHint
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w500)
                    : AppTextStyles.nominalInputText,
              ),
            ),
            if (widget.isEmpty)
              FadeTransition(
                opacity: _pulse,
                child: Container(
                  width: 2, height: 22,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String date;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        HapticFeedback.selectionClick();
      },
      child: Container(
        height: AppSpacing.inputHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            const RoundedSquareIcon(
              icon: Icons.calendar_today_outlined,
              backgroundColor: AppColors.softSurface,
              iconColor: AppColors.primary,
              size: 32,
              iconSize: 16,
              borderRadius: AppSpacing.radiusXs,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(date, style: AppTextStyles.inputText),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.mutedText, size: 18),
          ],
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _NoteField({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 3,
        minLines: 3,
        style: AppTextStyles.inputText,
        decoration: InputDecoration(
          hintText: 'Contoh: uang makan siang',
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;
  const _SaveButton({required this.enabled, required this.onTap});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton>
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
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            'Simpan Transaksi',
            style: AppTextStyles.primaryButton.copyWith(
              color: widget.enabled ? AppColors.surface : AppColors.mutedText,
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// CATEGORY PICKER BOTTOM SHEET
// ───────────────────────────────────────────────────────────────
class _CategoryPicker extends StatelessWidget {
  final TransactionCategory? selected;
  const _CategoryPicker({this.selected});

  static const _cats = [
    TransactionCategory.makananMinuman,
    TransactionCategory.tagihan,
    TransactionCategory.transportasi,
    TransactionCategory.transfer,
    TransactionCategory.gaji,
    TransactionCategory.lainnya,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
      ),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Pilih Kategori', style: AppTextStyles.sheetTitle),
          const SizedBox(height: AppSpacing.lg),
          ..._cats.map((cat) {
            final isSelected = selected == cat;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, cat);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.softSurface : AppColors.canvas,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    RoundedSquareIcon(
                      icon: cat.icon,
                      backgroundColor: cat.iconBg,
                      iconColor: cat.iconColor,
                      size: 40,
                      iconSize: 20,
                      borderRadius: AppSpacing.radiusSm,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(cat.label, style: AppTextStyles.inputText),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
