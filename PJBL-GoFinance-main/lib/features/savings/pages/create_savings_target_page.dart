import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/features/savings/models/savings_target.dart';

class CreateSavingsTargetPage extends StatefulWidget {
  const CreateSavingsTargetPage({super.key});

  @override
  State<CreateSavingsTargetPage> createState() =>
      _CreateSavingsTargetPageState();
}

class _CreateSavingsTargetPageState extends State<CreateSavingsTargetPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _customIntervalController = TextEditingController(text: '14');
  DateTime? _targetDate;
  int _intervalDays = 7;
  bool _isCustom = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _customIntervalController.dispose();
    super.dispose();
  }

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;

  Future<void> _selectDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? today.add(const Duration(days: 30)),
      firstDate: today,
      lastDate: DateTime(today.year + 15),
      locale: const Locale('id', 'ID'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.colors.primary,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
            surface: context.colors.canvas,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _targetDate = date);
  }

  void _saveTarget() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _amount <= 0 || _targetDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lengkapi nama, nominal, dan tanggal target.',
              style: AppTextStyles.primaryButton),
          backgroundColor: context.colors.negative,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final customDays = int.tryParse(_customIntervalController.text) ?? 0;
    if (_isCustom && (customDays < 1 || customDays > 365)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interval khusus harus 1 sampai 365 hari.',
              style: AppTextStyles.primaryButton),
          backgroundColor: context.colors.negative,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      SavingsTarget(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        amount: _amount,
        targetDate: _targetDate!,
        intervalDays: _isCustom ? customDays : _intervalDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = _amount > 0
        ? NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(_amount)
        : 'Rp 0';
    final intervalLabel = _isCustom
        ? 'Setiap ${_customIntervalController.text} hari'
        : _intervalDays == 1
            ? 'Setiap 1 hari'
            : 'Setiap 1 minggu';

    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Kembali',
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: AppSpacing.navIconSize,
                        color: context.colors.primaryText),
                  ),
                  Text('Buat Target Tabungan',
                      style: AppTextStyles.calendarHeader),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  0,
                  AppSpacing.pageHorizontal,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buat tujuan baru', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Tentukan target dan jadwal menabungmu.',
                        style: AppTextStyles.footnote),
                    const SizedBox(height: AppSpacing.xl),
                    const _FieldLabel('Nama Target'),
                    const SizedBox(height: AppSpacing.sm),
                    _InputBox(
                      child: TextField(
                        key: const Key('field_savings_name'),
                        controller: _nameController,
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText: 'Contoh: Beli Laptop',
                          hintStyle: AppTextStyles.inputHint,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _FieldLabel('Nominal Target'),
                    const SizedBox(height: AppSpacing.sm),
                    _InputBox(
                      child: TextField(
                        key: const Key('field_savings_amount'),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (_) => setState(() {}),
                        style: AppTextStyles.inputText.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rp 0',
                          hintStyle: AppTextStyles.inputHint,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _FieldLabel('Tanggal Target'),
                    const SizedBox(height: AppSpacing.sm),
                    _InputBox(
                      key: const Key('field_savings_target_date'),
                      onTap: _selectDate,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_outlined,
                              color: context.colors.primaryText,
                              size: AppSpacing.navIconSize),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _targetDate == null
                                  ? 'Pilih tanggal target'
                                  : DateFormat('d MMMM yyyy', 'id_ID')
                                      .format(_targetDate!),
                              style: AppTextStyles.inputText.copyWith(
                                color: _targetDate == null
                                    ? context.colors.mutedText
                                    : context.colors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: context.colors.primaryText,
                              size: AppSpacing.navIconSize),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _FieldLabel('Interval Menabung'),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Pilih seberapa sering kamu ingin menabung.',
                        style: AppTextStyles.footnote),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _IntervalButton(
                            label: '1 Hari',
                            selected: !_isCustom && _intervalDays == 1,
                            onTap: () => setState(() {
                              _isCustom = false;
                              _intervalDays = 1;
                            }),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _IntervalButton(
                            label: '1 Minggu',
                            selected: !_isCustom && _intervalDays == 7,
                            onTap: () => setState(() {
                              _isCustom = false;
                              _intervalDays = 7;
                            }),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _IntervalButton(
                            label: 'Custom',
                            icon: Icons.edit_outlined,
                            selected: _isCustom,
                            onTap: () => setState(() => _isCustom = true),
                          ),
                        ),
                      ],
                    ),
                    if (_isCustom) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: context.colors.softSurface,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          children: [
                            Text('Setiap', style: AppTextStyles.fieldLabel),
                            const SizedBox(width: AppSpacing.sm),
                            SizedBox(
                              width: 82,
                              height: AppSpacing.actionButtonHeight,
                              child: TextField(
                                key: const Key('field_custom_interval'),
                                controller: _customIntervalController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlign: TextAlign.center,
                                onChanged: (_) => setState(() {}),
                                style: AppTextStyles.inputText.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: context.colors.surface,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusXs),
                                    borderSide: BorderSide(
                                        color: context.colors.primaryText),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusXs),
                                    borderSide: BorderSide(
                                        color: context.colors.primaryText),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Hari', style: AppTextStyles.fieldLabel),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Masukkan jumlah hari, misalnya 14 atau 30.',
                          style: AppTextStyles.footnote),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: context.colors.softSurface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: context.colors.primaryText,
                              size: AppSpacing.navIconSize),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jadwal menabung: $intervalLabel',
                                    style: AppTextStyles.fieldLabel),
                                Text('Kamu tetap bisa menabung kapan saja.',
                                    style: AppTextStyles.footnote),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Ringkasan Target', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        border: Border.all(color: context.colors.border),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow('Target', formattedAmount),
                          const SizedBox(height: AppSpacing.xs),
                          _SummaryRow('Jadwal', intervalLabel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.xs,
                AppSpacing.pageHorizontal,
                AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  key: const Key('btn_save_savings_target'),
                  onPressed: _saveTarget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 0,
                    textStyle: AppTextStyles.primaryButton,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusCard),
                    ),
                  ),
                  child: const Text('Simpan Target'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: AppTextStyles.fieldLabel,
      );
}

class _InputBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _InputBox({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          height: AppSpacing.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _IntervalButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _IntervalButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          backgroundColor:
              selected ? context.colors.primary : context.colors.surface,
          foregroundColor: selected
              ? Theme.of(context).colorScheme.onPrimary
              : context.colors.textPrimary,
          side: BorderSide(
            color: selected ? context.colors.primary : context.colors.border,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusNav)),
          textStyle: AppTextStyles.cardActionButton,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSpacing.navIconSize),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(child: Text(label, maxLines: 1)),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.footnote),
        ),
        Text(value, style: AppTextStyles.fieldLabel),
      ],
    );
  }
}
