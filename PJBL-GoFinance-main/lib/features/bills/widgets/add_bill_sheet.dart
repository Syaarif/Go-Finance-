import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';

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
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.scrim,
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
      _nameError = name.isEmpty ? 'Nama tagihan wajib diisi' : null;
      _amountError = amount <= 0 ? 'Nominal harus lebih dari Rp 0' : null;
      _dateError =
          _selectedDueDate == null ? 'Tanggal jatuh tempo wajib dipilih' : null;
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
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.surface,
              onSurface: AppColors.deepGreen,
            ),
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
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header sheet
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tambah Tagihan', style: AppTextStyles.sheetTitle),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.mutedText,
                    size: AppSpacing.billIconSize,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 1. Nominal (Tinggi 56, paling menonjol, otomatis format titik ribuan)
            Text('Nominal Tagihan', style: AppTextStyles.fieldLabel),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: AppSpacing.nominalInputHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: _amountError != null
                      ? AppColors.negative
                      : AppColors.primary,
                  width: AppSpacing.borderRing,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text('Rp ', style: AppTextStyles.nominalInputText),
                  Expanded(
                    child: TextField(
                      key: const Key('input_bill_amount'),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ThousandsSeparatorInputFormatter(),
                      ],
                      style: AppTextStyles.nominalInputText,
                      decoration: InputDecoration(
                        hintText: '300.000',
                        hintStyle: AppTextStyles.nominalInputText.copyWith(
                          color: AppColors.mutedText,
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
              Text(_amountError!, style: AppTextStyles.errorText),
            ],
            const SizedBox(height: AppSpacing.lg),

            // 2. Nama Tagihan (Tinggi 52)
            Text('Nama Tagihan', style: AppTextStyles.fieldLabel),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: AppSpacing.inputHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: _nameError != null
                      ? AppColors.negative
                      : AppColors.border,
                  width: AppSpacing.borderThin,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                key: const Key('input_bill_name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Mis. Internet rumah, Listrik, Streaming',
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_nameError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(_nameError!, style: AppTextStyles.errorText),
            ],
            const SizedBox(height: AppSpacing.lg),

            // 3. Tanggal Jatuh Tempo (showDatePicker, Tinggi 52)
            Text('Tanggal Jatuh Tempo', style: AppTextStyles.fieldLabel),
            const SizedBox(height: AppSpacing.sm),
            Material(
              color: AppColors.surface,
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
                          ? AppColors.negative
                          : AppColors.border,
                      width: AppSpacing.borderThin,
                    ),
                  ),
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
                      child: Text(
                        _selectedDueDate != null
                            ? _formatFullDate(_selectedDueDate!)
                            : 'Pilih tanggal jatuh tempo',
                        style: _selectedDueDate != null
                            ? AppTextStyles.inputText
                            : AppTextStyles.inputHint,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.mutedText,
                    ),
                  ],
                  ),
                ),
              ),
            ),
            if (_dateError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(_dateError!, style: AppTextStyles.errorText),
            ],
            const SizedBox(height: AppSpacing.md),

            // Info kecil pengingat otomatis
            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: AppSpacing.lg,
                  color: AppColors.mutedText,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Pengingat otomatis 7 hari & 1 hari sebelum jatuh tempo.',
                    style: AppTextStyles.footnote,
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
                  backgroundColor: _buttonBackgroundColor(buttonState),
                  foregroundColor: AppColors.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Text(
                  buttonState == SubmitButtonState.error
                      ? 'Periksa Input & Simpan'
                      : 'Simpan',
                  style: AppTextStyles.primaryButton.copyWith(
                    color: buttonState == SubmitButtonState.disabled
                        ? AppColors.mutedText
                        : AppColors.surface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _buttonBackgroundColor(SubmitButtonState state) {
    switch (state) {
      case SubmitButtonState.normal:
        return AppColors.primary;
      case SubmitButtonState.disabled:
        return AppColors.disabledSurface;
      case SubmitButtonState.error:
        return AppColors.negative;
    }
  }

  static String _formatFullDate(DateTime date) {
    try {
      return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMMM yyyy').format(date);
    }
  }
}

/// Formatter otomatis pemisah ribuan titik (`300.000`).
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern('id_ID');

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

