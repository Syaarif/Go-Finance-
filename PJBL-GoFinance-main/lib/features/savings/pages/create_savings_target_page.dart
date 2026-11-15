import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/features/savings/models/savings_target.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

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
      locale: Localizations.localeOf(context),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final onPrimary =
            isDark ? Colors.white : Theme.of(context).colorScheme.onPrimary;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
              onPrimary: onPrimary,
              surface: context.colors.canvas,
              onSurface: isDark
                  ? context.colors.textPrimary
                  : const ColorScheme.light().onSurface,
              onSurfaceVariant: isDark
                  ? context.colors.textPrimary
                  : const ColorScheme.light().onSurfaceVariant,
            ),
            datePickerTheme: isDark
                ? Theme.of(context).datePickerTheme.copyWith(
                      headerForegroundColor: context.colors.textPrimary,
                      weekdayStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: context.colors.textPrimary),
                      todayForegroundColor:
                          WidgetStatePropertyAll(context.colors.textPrimary),
                      todayBackgroundColor:
                          WidgetStatePropertyAll(context.colors.todayFill),
                      todayBorder: BorderSide(color: context.colors.todayRing),
                    )
                : Theme.of(context).datePickerTheme,
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _targetDate = date);
  }

  void _saveTarget() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _amount <= 0 || _targetDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.targetCreationIncomplete,
              style: AppTextStyles.primaryButton.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
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
          content: Text(AppLocalizations.of(context)!.customIntervalInvalid,
              style: AppTextStyles.primaryButton.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final formattedAmount = _amount > 0
        ? NumberFormat.currency(
            locale: locale,
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(_amount)
        : 'Rp 0';
    final intervalLabel = _isCustom
        ? l10n.everyDays(int.tryParse(_customIntervalController.text) ?? 0)
        : _intervalDays == 1
            ? l10n.everyDay
            : l10n.everyWeek;

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
                    tooltip: l10n.back,
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: AppSpacing.navIconSize,
                        color: context.colors.primaryText),
                  ),
                  Text(l10n.createSavingsTarget,
                      style: AppTextStyles.calendarHeader.copyWith(
                        color: context.colors.textPrimary,
                      )),
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
                    Text(
                      l10n.createNewGoal,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.setGoalSchedule,
                        style: AppTextStyles.footnote.copyWith(
                          color: context.colors.mutedText,
                        )),
                    const SizedBox(height: AppSpacing.xl),
                    _FieldLabel(l10n.targetName),
                    const SizedBox(height: AppSpacing.sm),
                    _InputBox(
                      child: TextField(
                        key: const Key('field_savings_name'),
                        controller: _nameController,
                        style: AppTextStyles.inputText.copyWith(
                          color: context.colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.sampleLaptop,
                          hintStyle: AppTextStyles.inputHint.copyWith(
                            color: context.colors.mutedText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _FieldLabel(l10n.targetAmount),
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
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rp 0',
                          hintStyle: AppTextStyles.inputHint.copyWith(
                            color: context.colors.mutedText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _FieldLabel(l10n.targetDateLabel),
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
                                  ? l10n.chooseTargetDate
                                  : DateFormat('d MMMM yyyy', locale)
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
                    _FieldLabel(l10n.savingInterval),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.chooseSavingFrequency,
                        style: AppTextStyles.footnote.copyWith(
                          color: context.colors.mutedText,
                        )),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _IntervalButton(
                            label: l10n.oneDay,
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
                            label: l10n.oneWeek,
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
                            label: l10n.custom,
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
                            Text(
                              l10n.every,
                              style: AppTextStyles.fieldLabel.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
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
                                  color: context.colors.textPrimary,
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
                            Text(
                              l10n.days,
                              style: AppTextStyles.fieldLabel.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.customIntervalHint,
                          style: AppTextStyles.footnote.copyWith(
                            color: context.colors.mutedText,
                          )),
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
                                Text(l10n.savingSchedule(intervalLabel),
                                    style: AppTextStyles.fieldLabel.copyWith(
                                      color: context.colors.textPrimary,
                                    )),
                                Text(l10n.saveAnytime,
                                    style: AppTextStyles.footnote.copyWith(
                                      color: context.colors.mutedText,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.goalSummary,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
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
                          _SummaryRow(l10n.target, formattedAmount),
                          const SizedBox(height: AppSpacing.xs),
                          _SummaryRow(l10n.schedule, intervalLabel),
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
                    textStyle: AppTextStyles.primaryButton.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusCard),
                    ),
                  ),
                  child: Text(l10n.saveTargetButton),
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
        style: AppTextStyles.fieldLabel.copyWith(
          color: context.colors.textPrimary,
        ),
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
          textStyle: AppTextStyles.cardActionButton.copyWith(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : context.colors.textPrimary,
          ),
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
          child: Text(
            label,
            style: AppTextStyles.footnote.copyWith(
              color: context.colors.mutedText,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.fieldLabel.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
