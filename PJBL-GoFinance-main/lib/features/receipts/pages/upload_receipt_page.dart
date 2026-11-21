import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/core/widgets/bottom_nav_bar.dart';
import 'package:go_finance/features/receipts/pages/analysis_progress_page.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

class UploadReceiptPage extends StatefulWidget {
  final NavTab currentIndex;

  const UploadReceiptPage({
    super.key,
    this.currentIndex = NavTab.home,
  });

  @override
  State<UploadReceiptPage> createState() => _UploadReceiptPageState();
}

class _UploadReceiptPageState extends State<UploadReceiptPage> {
  PlatformFile? _selectedFile;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.primaryButton),
        backgroundColor: context.colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  Future<void> _pickReceipt() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (file == null) return;
    final size = file.lengthSync();
    if (size == null) {
      _showMessage('Ukuran file tidak dapat dibaca.');
      return;
    }
    if (size > 10 * 1024 * 1024) {
      _showMessage('Ukuran file maksimal 10 MB.');
      return;
    }
    setState(() => _selectedFile = file);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('btn_back_upload_receipt'),
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: l10n.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                    ),
                  ),
                  Text(
                    l10n.receiptAnalysisTitle,
                    style: AppTextStyles.pageTitle.copyWith(
                      color: context.colors.deepGreen,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
              child: _UploadProgress(
                uploadLabel: l10n.upload,
                reviewLabel: l10n.review,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.uploadReceiptFile,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: context.colors.deepGreen,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.receiptUploadInstructions,
                      style: AppTextStyles.footnote.copyWith(
                        color: context.colors.mutedText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _UploadDropZone(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _pickReceipt();
                      },
                    ),
                    const SizedBox(height: 17),
                    Text(
                      l10n.selectedFile,
                      style: AppTextStyles.fieldLabel.copyWith(
                        color: context.colors.deepGreen,
                        fontSize: 11,
                      ),
                    ),
                    if (_selectedFile != null) ...[
                      const SizedBox(height: 8),
                      _SelectedFileTile(
                        file: _selectedFile!,
                        onRemove: () => setState(() => _selectedFile = null),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          border: Border.all(color: context.colors.border),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Text(
                          l10n.noFileSelected,
                          style: AppTextStyles.footnote.copyWith(
                            color: context.colors.mutedText,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const _PhotoTip(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      key: const Key('btn_start_receipt_analysis'),
                      onPressed: _selectedFile != null
                          ? () {
                              HapticFeedback.mediumImpact();
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => AnalysisProgressPage(
                                    file: _selectedFile!,
                                    currentIndex: widget.currentIndex,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        disabledBackgroundColor: context.colors.disabledSurface,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        textStyle: AppTextStyles.primaryButton.copyWith(
                          fontSize: 13,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.startAiAnalysis),
                          const SizedBox(width: 8),
                          const Icon(Icons.auto_awesome, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.fileProcessingNotice,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footnote.copyWith(
                      color: context.colors.mutedText,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  final String uploadLabel;
  final String reviewLabel;

  const _UploadProgress({
    required this.uploadLabel,
    required this.reviewLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ProgressStep(
            number: '1',
            label: uploadLabel,
            isActive: true,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ProgressStep(
            number: '2',
            label: reviewLabel,
            isActive: false,
          ),
        ),
      ],
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _ProgressStep({
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground =
        isActive ? Theme.of(context).colorScheme.onPrimary : colors.secondary;
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? colors.primary : colors.softSurface,
        border: Border.all(
          color: isActive ? colors.primary : colors.border,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? colors.surface : colors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: AppTextStyles.billMeta.copyWith(
                color: isActive ? colors.primary : colors.surface,
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

class _UploadDropZone extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadDropZone({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CustomPaint(
      painter: _DashedBorderPainter(color: context.colors.brandBg),
      child: Material(
        color: context.colors.softSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: SizedBox(
            width: double.infinity,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: context.colors.billHighlight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: context.colors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tapToUploadReceipt,
                  style: AppTextStyles.fieldLabel.copyWith(
                    color: context.colors.deepGreen,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.supportedReceiptFormats,
                  style: AppTextStyles.footnote.copyWith(
                    color: context.colors.mutedText,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.maxFileSize,
                  style: AppTextStyles.footnote.copyWith(
                    color: context.colors.mutedText,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedFileTile extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onRemove;

  const _SelectedFileTile({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final size = file.lengthSync();
    final colors = context.colors;
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 40,
            decoration: BoxDecoration(
              color: colors.softSurface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Icon(
              Icons.description_outlined,
              color: colors.primaryText,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.fieldLabel.copyWith(
                    color: colors.deepGreen,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.receiptFileSize(
                    NumberFormat.decimalPattern(locale)
                        .format((size ?? 0) / (1024 * 1024)),
                  ),
                  style: AppTextStyles.footnote.copyWith(
                    color: colors.mutedText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: const Key('btn_remove_receipt_file'),
            onPressed: onRemove,
            tooltip: l10n.removeFile,
            constraints: const BoxConstraints.tightFor(width: 30, height: 30),
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              foregroundColor: colors.mutedText,
              side: BorderSide(color: colors.border),
              shape: const CircleBorder(),
            ),
            icon: const Icon(Icons.close_rounded, size: 16),
          ),
        ],
      ),
    );
  }
}

class _PhotoTip extends StatelessWidget {
  const _PhotoTip();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.softSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 19,
            height: 19,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.billHighlight,
              shape: BoxShape.circle,
            ),
            child: Text(
              '!',
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.receiptPhotoTipTitle,
                  style: AppTextStyles.fieldLabel.copyWith(
                    color: colors.deepGreen,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.receiptPhotoTipBody,
                  style: AppTextStyles.footnote.copyWith(
                    color: colors.mutedText,
                    fontSize: 9,
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppSpacing.radiusCard),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + 7).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + 5;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color;
}
