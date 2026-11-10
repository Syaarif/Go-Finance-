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
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.surface,
            surface: AppColors.canvas,
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
          backgroundColor: AppColors.negative,
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
          backgroundColor: AppColors.negative,
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
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 20, 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Kembali',
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: AppColors.deepGreen),
                  ),
                  Text('Buat Target Tabungan',
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(11, 0, 11, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buat tujuan baru',
                        style: AppTextStyles.sectionTitle.copyWith(fontSize: 17)),
                    const SizedBox(height: 3),
                    Text('Tentukan target dan jadwal menabungmu.',
                        style: AppTextStyles.footnote.copyWith(fontSize: 9)),
                    const SizedBox(height: 16),
                    const _FieldLabel('Nama Target'),
                    const SizedBox(height: 5),
                    _InputBox(
                      child: TextField(
                        key: const Key('field_savings_name'),
                        controller: _nameController,
                        style: AppTextStyles.inputText.copyWith(fontSize: 11),
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Beli Laptop',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    const _FieldLabel('Nominal Target'),
                    const SizedBox(height: 5),
                    _InputBox(
                      child: TextField(
                        key: const Key('field_savings_amount'),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() {}),
                        style: AppTextStyles.inputText.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Rp 0',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    const _FieldLabel('Tanggal Target'),
                    const SizedBox(height: 5),
                    _InputBox(
                      key: const Key('field_savings_target_date'),
                      onTap: _selectDate,
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              color: AppColors.primary, size: 17),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _targetDate == null
                                  ? 'Pilih tanggal target'
                                  : DateFormat('d MMMM yyyy', 'id_ID')
                                      .format(_targetDate!),
                              style: AppTextStyles.inputText.copyWith(
                                color: _targetDate == null
                                    ? AppColors.mutedText
                                    : AppColors.deepGreen,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.secondary, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 11),
                    const _FieldLabel('Interval Menabung'),
                    const SizedBox(height: 3),
                    Text('Pilih seberapa sering kamu ingin menabung.',
                        style: AppTextStyles.footnote.copyWith(fontSize: 9)),
                    const SizedBox(height: 7),
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
                        const SizedBox(width: 6),
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
                        const SizedBox(width: 6),
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
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppColors.softSurface,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          children: [
                            Text('Setiap',
                                style: AppTextStyles.fieldLabel.copyWith(
                                  fontSize: 9,
                                )),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 82,
                              height: 32,
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text('Hari',
                                style: AppTextStyles.fieldLabel.copyWith(
                                  fontSize: 9,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text('Masukkan jumlah hari, misalnya 14 atau 30.',
                          style: AppTextStyles.footnote.copyWith(fontSize: 8)),
                    ],
                    const SizedBox(height: 11),
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.softSurface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 15),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jadwal menabung: $intervalLabel',
                                    style: AppTextStyles.fieldLabel.copyWith(
                                      fontSize: 9,
                                    )),
                                Text('Kamu tetap bisa menabung kapan saja.',
                                    style: AppTextStyles.footnote.copyWith(
                                      fontSize: 8,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text('Ringkasan Target',
                        style: AppTextStyles.sectionTitle.copyWith(fontSize: 11)),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow('Target', formattedAmount),
                          const SizedBox(height: 3),
                          _SummaryRow('Jadwal', intervalLabel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 4, 11, 12),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  key: const Key('btn_save_savings_target'),
                  onPressed: _saveTarget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    elevation: 0,
                    textStyle: AppTextStyles.primaryButton.copyWith(
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
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
        style: AppTextStyles.fieldLabel.copyWith(fontSize: 9),
      );
}

class _InputBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _InputBox({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
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
      height: 32,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          backgroundColor: selected ? AppColors.primary : AppColors.surface,
          foregroundColor: selected ? AppColors.surface : AppColors.deepGreen,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: AppTextStyles.billMeta.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12),
              const SizedBox(width: 3),
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
          child: Text(label,
              style: AppTextStyles.footnote.copyWith(fontSize: 8)),
        ),
        Text(value,
            style: AppTextStyles.fieldLabel.copyWith(fontSize: 8)),
      ],
    );
  }
}