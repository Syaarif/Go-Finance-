import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/features/receipts/pages/analysis_progress_page.dart';

class UploadReceiptPage extends StatefulWidget {
  const UploadReceiptPage({super.key});

  @override
  State<UploadReceiptPage> createState() => _UploadReceiptPageState();
}

class _UploadReceiptPageState extends State<UploadReceiptPage> {
  bool _hasSelectedFile = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.primaryButton),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
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
                    key: const Key('btn_back_upload_receipt'),
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Kembali',
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.deepGreen,
                    ),
                  ),
                  Text(
                    'AI Analisis Struk',
                    style: AppTextStyles.pageTitle.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 2, 18, 12),
              child: _UploadProgress(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unggah file struk',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Pilih foto atau PDF bukti transaksi kamu.',
                      style: AppTextStyles.footnote.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 15),
                    _UploadDropZone(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showMessage(
                          'Pemilih file akan tersedia setelah integrasi.',
                        );
                      },
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'File dipilih',
                      style: AppTextStyles.fieldLabel.copyWith(fontSize: 11),
                    ),
                    if (_hasSelectedFile) ...[
                      const SizedBox(height: 8),
                      _SelectedFileTile(
                        onRemove: () => setState(() => _hasSelectedFile = false),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Text(
                          'Belum ada file dipilih',
                          style: AppTextStyles.footnote,
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
                      onPressed: _hasSelectedFile
                          ? () {
                              HapticFeedback.mediumImpact();
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      const AnalysisProgressPage(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.disabledSurface,
                        foregroundColor: AppColors.surface,
                        textStyle: AppTextStyles.primaryButton.copyWith(
                          fontSize: 13,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Mulai Analisis AI'),
                          SizedBox(width: 8),
                          Icon(Icons.auto_awesome, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'File akan diproses setelah kamu menekan tombol.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footnote.copyWith(fontSize: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  const _UploadProgress();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _ProgressStep(
            number: '1',
            label: 'Upload',
            isActive: true,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _ProgressStep(
            number: '2',
            label: 'Review',
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
    final foreground = isActive ? AppColors.surface : AppColors.secondary;
    return Container(
      height: 28,
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
            width: 15,
            height: 15,
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

class _UploadDropZone extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadDropZone({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Material(
        color: AppColors.softSurface,
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
                  decoration: const BoxDecoration(
                    color: AppColors.billHighlight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ketuk untuk Unggah File Struk',
                  style: AppTextStyles.fieldLabel.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Mendukung format JPG, PNG, PDF',
                  style: AppTextStyles.footnote.copyWith(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Ukuran maksimal 10 MB',
                  style: AppTextStyles.footnote.copyWith(fontSize: 9),
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
  final VoidCallback onRemove;

  const _SelectedFileTile({required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
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
                  'struk_indomaret.jpg',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.fieldLabel.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  'JPG · 2,4 MB',
                  style: AppTextStyles.footnote.copyWith(fontSize: 9),
                ),
              ],
            ),
          ),
          IconButton(
            key: const Key('btn_remove_receipt_file'),
            onPressed: onRemove,
            tooltip: 'Hapus file',
            constraints: const BoxConstraints.tightFor(width: 30, height: 30),
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              foregroundColor: AppColors.mutedText,
              side: const BorderSide(color: AppColors.border),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.softSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 19,
            height: 19,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.billHighlight,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '!',
              style: TextStyle(
                color: AppColors.primary,
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
                  'Pastikan struk terlihat jelas',
                  style: AppTextStyles.fieldLabel.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 2),
                Text(
                  'dan semua informasi terbaca agar hasil analisis AI lebih akurat.',
                  style: AppTextStyles.footnote.copyWith(fontSize: 9),
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
      ..color = AppColors.brandBg
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
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}