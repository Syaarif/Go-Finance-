import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// State tombol Simpan pada sheet Tambah Tagihan.
enum SubmitButtonState { normal, disabled, error }

/// Modal Bottom Sheet "Tambah Tagihan".
class AddBillSheet extends StatefulWidget {
  const AddBillSheet({super.key});

  /// Menampilkan modal bottom sheet Tambah Tagihan.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      barrierColor: context.colors.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusSheet),
        ),
      ),
      builder: (_) => const AddBillSheet(),
    );
  }

  @override
  State<AddBillSheet> createState() => _AddBillSheetState();
}

class _AddBillSheetState extends State<AddBillSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDueDate;
  String? _nameError;
  String? _amountError;
  String? _dateError;
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _amountController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  int get _parsedAmount {
    final digits = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return int.tryParse(digits) ?? 0;
  }

  bool get _isFormComplete =>
      _nameController.text.trim().isNotEmpty &&
      _parsedAmount > 0 &&
      _selectedDueDate != null;

  SubmitButtonState get _buttonState {
    if (_hasAttemptedSubmit &&
        (_nameError != null || _amountError != null || _dateError != null)) {
      return SubmitButtonState.error;
    }
    if (!_isFormComplete) {
      return SubmitButtonState.disabled;
    }
    return SubmitButtonState.normal;
  }

  void _onFieldChanged() {
    if (_hasAttemptedSubmit) {
      _validateFields();
    } else {
      setState(() {});
    }
  }

  bool _validateFields() {
    final name = _nameController.text.trim();
    final amount = _parsedAmount;

    setState(() {
      final l10n = AppLocalizations.of(context)!;
      _nameError = name.isEmpty ? l10n.billNameRequired : null;
      _amountError = amount <= 0 ? l10n.billAmountMustBePositive : null;
      _dateError = _selectedDueDate == null ? l10n.billDateRequired : null;
    });

    return _nameError == null && _amountError == null && _dateError == null;
  }

  Future<void> _pickDueDate() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<BillProvider>();
    final initial = _selectedDueDate ?? provider.today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(provider.today.year - 1, 1, 1),
      lastDate: DateTime(provider.today.year + 5, 12, 31),
      builder: (ctx, child) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: ctx.colors.primary,
              onPrimary: Colors.white,
              surface: isDark ? ctx.colors.canvas : ctx.colors.surface,
              onSurface: isDark ? ctx.colors.textPrimary : ctx.colors.deepGreen,
              onSurfaceVariant: isDark
                  ? ctx.colors.textPrimary
                  : const ColorScheme.light().onSurfaceVariant,
            ),
            datePickerTheme: isDark
                ? Theme.of(ctx).datePickerTheme.copyWith(
                      headerForegroundColor: ctx.colors.textPrimary,
                      weekdayStyle: Theme.of(ctx)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: ctx.colors.textPrimary),
                      todayForegroundColor:
                          WidgetStatePropertyAll(ctx.colors.textPrimary),
                      todayBackgroundColor:
                          WidgetStatePropertyAll(ctx.colors.todayFill),
                      todayBorder: BorderSide(color: ctx.colors.todayRing),
                    )
                : Theme.of(ctx).datePickerTheme,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
        if (_hasAttemptedSubmit) {
          _dateError = null;
        }
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _hasAttemptedSubmit = true);
    if (!_validateFields()) return;

    final provider = context.read<BillProvider>();
    await provider.addBill(
      name: _nameController.text.trim(),
      amount: _parsedAmount,
      dueDate: _selectedDueDate!,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final buttonState = _buttonState;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.lg,
          AppSpacing.pageHorizontal,
          AppSpacing.xxl + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: AppSpacing.calendarDaySize,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header sheet
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.addBillTitle,
                  style: AppTextStyles.sheetTitle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: context.colors.mutedText,
                    size: AppSpacing.billIconSize,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 1. Nominal (Tinggi 56, paling menonjol, otomatis format titik ribuan)
            Text(
              l10n.billAmount,
              style: AppTextStyles.fieldLabel.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: AppSpacing.nominalInputHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.softSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: _amountError != null
                      ? context.colors.negative
                      : context.colors.primary,
                  width: AppSpacing.borderRing,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Rp ',
                    style: AppTextStyles.nominalInputText.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      key: const Key('input_bill_amount'),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ThousandsSeparatorInputFormatter(locale),
                      ],
                      style: AppTextStyles.nominalInputText.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            NumberFormat.decimalPattern(locale).format(300000),
                        hintStyle: AppTextStyles.nominalInputText.copyWith(
                          color: context.colors.mutedText,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_amountError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _amountError!,
                style: AppTextStyles.errorText.copyWith(
                  color: context.colors.negative,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // 2. Nama Tagihan (Tinggi 52)
            Text(
              l10n.billName,
              style: AppTextStyles.fieldLabel.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: AppSpacing.inputHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: _nameError != null
                      ? context.colors.negative
                      : context.colors.border,
                  width: AppSpacing.borderThin,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                key: const Key('input_bill_name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.inputText.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l10n.billNameExample,
                  hintStyle: AppTextStyles.inputHint.copyWith(
                    color: context.colors.mutedText,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_nameError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _nameError!,
                style: AppTextStyles.errorText.copyWith(
                  color: context.colors.negative,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // 3. Tanggal Jatuh Tempo (showDatePicker, Tinggi 52)
            Text(
              l10n.billDueDate,
              style: AppTextStyles.fieldLabel.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Material(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: InkWell(
                key: const Key('input_bill_due_date'),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                onTap: _pickDueDate,
                child: Container(
                  height: AppSpacing.inputHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: _dateError != null
                          ? context.colors.negative
                          : context.colors.border,
                      width: AppSpacing.borderThin,
                    ),
                  ),
                  child: Row(
                    children: [
                      RoundedSquareIcon(
                        icon: Icons.calendar_today_outlined,
                        backgroundColor: context.colors.softSurface,
                        iconColor: context.colors.primaryText,
                        size: 32,
                        iconSize: 16,
                        borderRadius: AppSpacing.radiusXs,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _selectedDueDate != null
                              ? _formatFullDate(_selectedDueDate!, locale)
                              : l10n.chooseDueDate,
                          style: _selectedDueDate != null
                              ? AppTextStyles.inputText.copyWith(
                                  color: context.colors.textPrimary,
                                )
                              : AppTextStyles.inputHint.copyWith(
                                  color: context.colors.mutedText,
                                ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: context.colors.mutedText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_dateError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _dateError!,
                style: AppTextStyles.errorText.copyWith(
                  color: context.colors.negative,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),

            // Info kecil pengingat otomatis
            Row(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: AppSpacing.lg,
                  color: context.colors.mutedText,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.billReminderInfo,
                    style: AppTextStyles.footnote.copyWith(
                      color: context.colors.mutedText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Tombol Simpan (state: default, disabled, error)
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                key: const Key('btn_save_bill'),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonBackgroundColor(
                    buttonState,
                    context,
                  ),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Text(
                  buttonState == SubmitButtonState.error
                      ? l10n.checkInputAndSave
                      : l10n.save,
                  style: AppTextStyles.primaryButton.copyWith(
                    color: buttonState == SubmitButtonState.disabled
                        ? context.colors.mutedText
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _buttonBackgroundColor(
    SubmitButtonState state,
    BuildContext context,
  ) {
    switch (state) {
      case SubmitButtonState.normal:
        return context.colors.primary;
      case SubmitButtonState.disabled:
        return context.colors.disabledSurface;
      case SubmitButtonState.error:
        return context.colors.negative;
    }
  }

  static String _formatFullDate(DateTime date, String locale) =>
      DateFormat('d MMMM yyyy', locale).format(date);
}

/// Formatter otomatis pemisah ribuan titik (`300.000`).
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  _ThousandsSeparatorInputFormatter(String locale)
      : _formatter = NumberFormat.decimalPattern(locale);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.tryParse(digitsOnly);
    if (number == null) return oldValue;

    final formatted = _formatter.format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
