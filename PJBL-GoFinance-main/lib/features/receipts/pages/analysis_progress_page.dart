import 'package:flutter/material.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_text_styles.dart';
import 'package:go_finance/features/receipts/pages/review_receipt_page.dart';

class AnalysisProgressPage extends StatefulWidget {
  const AnalysisProgressPage({super.key});

  @override
  State<AnalysisProgressPage> createState() => _AnalysisProgressPageState();
}

class _AnalysisProgressPageState extends State<AnalysisProgressPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const ReviewReceiptPage(),
          ),
        );
      }
    });
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(33, 22, 33, 20),
          child: AnimatedBuilder(
            animation: _progressController,
            builder: (context, _) {
              final progress = (_progressController.value * 100).floor();
              final isComplete = _progressController.isCompleted;

              return Column(
                children: [
                  Image.asset(
                    'assets/images/piggy_icon.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isComplete ? 'Analisis selesai' : 'Memproses struk',
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isComplete
                        ? 'Simulasi selesai. Hasil OCR belum tersedia.'
                      : 'Simulasi ekstraksi data transaksi...',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footnote.copyWith(fontSize: 9),
                  ),
                  const SizedBox(height: 52),
                  SizedBox(
                    width: 118,
                    height: 118,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            key: const Key('analysis_circular_progress'),
                            value: progress / 100,
                            strokeWidth: 9,
                            backgroundColor: AppColors.softSurface,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$progress%',
                          key: const Key('analysis_progress_value'),
                          style: AppTextStyles.pageTitle.copyWith(
                            color: AppColors.primary,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      key: const Key('analysis_linear_progress'),
                      value: progress / 100,
                      minHeight: 8,
                      backgroundColor: AppColors.softSurface,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _AnalysisStep(
                    label: 'Mengunggah foto',
                    isComplete: progress >= 30,
                    isActive: progress < 30,
                  ),
                  const SizedBox(height: 10),
                  _AnalysisStep(
                    label: 'Membaca merchant dan tanggal',
                    isComplete: progress >= 65,
                    isActive: progress >= 30 && progress < 65,
                  ),
                  const SizedBox(height: 10),
                  _AnalysisStep(
                    label: 'Menghitung total dan item',
                    isComplete: isComplete,
                    isActive: progress >= 65 && !isComplete,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: OutlinedButton(
                      key: const Key('btn_analysis_progress_bottom'),
                      onPressed: isComplete
                          ? () => Navigator.of(context).pop()
                          : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        disabledForegroundColor: AppColors.mutedText,
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        textStyle: AppTextStyles.footnote.copyWith(
                          fontSize: 9,
                        ),
                      ),
                      child: Text(
                        isComplete
                            ? 'Kembali ke halaman upload'
                            : 'Jangan tutup aplikasi dulu',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnalysisStep extends StatelessWidget {
  final String label;
  final bool isComplete;
  final bool isActive;

  const _AnalysisStep({
    required this.label,
    required this.isComplete,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.footnote.copyWith(
      color: isActive ? AppColors.deepGreen : AppColors.secondary,
      fontSize: 9,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        if (isComplete)
          const Icon(Icons.check_rounded, color: AppColors.primary, size: 15)
        else if (isActive)
          Text(
            '...',
            style: AppTextStyles.billMeta.copyWith(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}