import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/features/transactions/models/transaction_model.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';

class ReviewReceiptPage extends StatefulWidget {
  final String initialMerchant;
  final double initialAmount;
  final TransactionCategory initialCategory;
  final DateTime? initialDate;
  final String sourceFileName;

  const ReviewReceiptPage({
    super.key,
    this.initialMerchant = 'Indomaret',
    this.initialAmount = 45000,
    this.initialCategory = TransactionCategory.belanja,
    this.initialDate,
    this.sourceFileName = 'struk_indomaret.jpg',
  });

  @override
  State<ReviewReceiptPage> createState() => _ReviewReceiptPageState();
}

class _ReviewReceiptPageState extends State<ReviewReceiptPage> {
  late String _merchant;
  late double _amount;
  late TransactionCategory _category;
  late DateTime _date;

  String get _formattedAmount => NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(_amount);

  String get _formattedDate => DateFormat('d MMM yyyy', 'id_ID').format(_date);

  @override
  void initState() {
    super.initState();
    _merchant = widget.initialMerchant;
    _amount = widget.initialAmount;
    _category = widget.initialCategory;
    _date = widget.initialDate ?? DateTime(2025, 4, 12);
  }

  Future<String?> _showTextEditor({
    required String title,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title, style: AppTextStyles.sheetTitle),
        content: TextField(
          autofocus: true,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    return value;
  }

  Future<void> _editMerchant() async {
    final value = await _showTextEditor(
      title: 'Nama Merchant',
      initialValue: _merchant,
    );
    if (value != null && value.trim().isNotEmpty) {
      setState(() => _merchant = value.trim());
    }
  }

  Future<void> _editAmount() async {
    final value = await _showTextEditor(
      title: 'Nominal Total',
      initialValue: _amount.toStringAsFixed(0),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
    final amount = double.tryParse(value ?? '');
    if (amount != null && amount > 0) setState(() => _amount = amount);
  }

  Future<void> _editCategory() async {
    const categories = [
      TransactionCategory.belanja,
      TransactionCategory.makananMinuman,
      TransactionCategory.transportasi,
      TransactionCategory.tagihan,
      TransactionCategory.lainnya,
    ];
    final selected = await showModalBottomSheet<TransactionCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Kategori', style: AppTextStyles.sheetTitle),
            const SizedBox(height: 12),
            ...categories.map(
              (category) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: category.iconBg,
                  child:
                      Icon(category.icon, color: category.iconColor, size: 20),
                ),
                title: Text(category.label, style: AppTextStyles.fieldLabel),
                trailing: category == _category
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(sheetContext, category),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _category = selected);
  }

  Future<void> _editDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
    if (selected != null) setState(() => _date = selected);
  }

  void _saveTransaction() {
    if (_merchant.trim().isEmpty || _amount <= 0) return;

    context.read<TransactionProvider>().addTransaction(
          TransactionModel(
            id: 'receipt_${DateTime.now().microsecondsSinceEpoch}',
            title: _merchant,
            subtitle: _category.label,
            amount: _amount,
            type: TransactionType.pengeluaran,
            category: _category,
            date: _date,
            note: 'Struk: ${widget.sourceFileName}',
          ),
        );

    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Transaksi $_merchant berhasil disimpan.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('btn_back_review_receipt'),
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Kembali',
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.deepGreen,
                    ),
                  ),
                  Text(
                    'Periksa Hasil AI',
                    style: AppTextStyles.pageTitle.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(19, 0, 19, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ReviewProgress(),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.softSurface,
                        border: Border.all(color: AppColors.border),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 23),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ekstraksi berhasil',
                                  style: AppTextStyles.fieldLabel.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Periksa kembali data sebelum disimpan.',
                                  style: AppTextStyles.footnote.copyWith(
                                    fontSize: 9,
                                  ),
                                ),
                                Text(
                                  'Data contoh; OCR/AI belum terhubung.',
                                  style: AppTextStyles.footnote.copyWith(
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Draft transaksi',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Hasil AI bisa kamu edit jika ada yang kurang tepat.',
                      style: AppTextStyles.footnote.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 15),
                    _ReviewField(
                      key: const Key('review_merchant_field'),
                      label: 'Nama Merchant',
                      value: _merchant,
                      onEdit: _editMerchant,
                    ),
                    const SizedBox(height: 7),
                    _ReviewField(
                      key: const Key('review_amount_field'),
                      label: 'Nominal Total',
                      value: _formattedAmount,
                      onEdit: _editAmount,
                    ),
                    const SizedBox(height: 14),
                    _ReviewField(
                      key: const Key('review_category_field'),
                      label: 'Kategori',
                      value: _category.label,
                      leadingIcon: _category.icon,
                      onEdit: _editCategory,
                    ),
                    const SizedBox(height: 14),
                    _ReviewField(
                      key: const Key('review_date_field'),
                      label: 'Tanggal Transaksi',
                      value: _formattedDate,
                      leadingIcon: Icons.calendar_today_outlined,
                      onEdit: _editDate,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Ketuk ikon pensil untuk mengubah data.',
                          style: AppTextStyles.footnote.copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.softSurface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined,
                              color: AppColors.secondary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sumber: ${widget.sourceFileName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.footnote.copyWith(
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 5, 19, 12),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  key: const Key('btn_confirm_save_receipt'),
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    textStyle: AppTextStyles.primaryButton.copyWith(
                      fontSize: 13,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: const Text('Konfirmasi & Simpan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewProgress extends StatelessWidget {
  const _ReviewProgress();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _ReviewStep(
            number: '1',
            label: 'Upload',
            isActive: false,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _ReviewStep(
            number: '2',
            label: 'Review',
            isActive: true,
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _ReviewStep({
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? AppColors.surface : AppColors.secondary;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.softSurface,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.surface : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: AppTextStyles.billMeta.copyWith(
                color: isActive ? AppColors.primary : AppColors.surface,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.billMeta.copyWith(
              color: foreground,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? leadingIcon;
  final VoidCallback onEdit;

  const _ReviewField({
    super.key,
    required this.label,
    required this.value,
    required this.onEdit,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 5),
        Container(
          height: 53,
          padding: const EdgeInsets.only(left: 10, right: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.softSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    leadingIcon,
                    color: AppColors.secondary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  key: ValueKey('value_$label'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.inputText.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onEdit();
                },
                tooltip: 'Ubah $label',
                constraints:
                    const BoxConstraints.tightFor(width: 36, height: 36),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.secondary, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
