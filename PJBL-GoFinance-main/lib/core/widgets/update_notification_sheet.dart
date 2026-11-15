import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_finance/core/services/app_update_service.dart';
import 'package:go_finance/theme/app_theme.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';

/// Modal bottom sheet interaktif untuk mengunduh dan menginstal update APK langsung di dalam aplikasi.
class UpdateNotificationSheet extends StatefulWidget {
  final AppUpdateInfo updateInfo;

  const UpdateNotificationSheet({
    super.key,
    required this.updateInfo,
  });

  static Future<void> show(BuildContext context, AppUpdateInfo info) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UpdateNotificationSheet(updateInfo: info),
    );
  }

  @override
  State<UpdateNotificationSheet> createState() =>
      _UpdateNotificationSheetState();
}

class _UpdateNotificationSheetState extends State<UpdateNotificationSheet> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _statusMessage = '';
  String? _errorMessage;

  Future<void> _startDirectUpdate() async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.05;
      _statusMessage = l10n.downloadPreparing;
      _errorMessage = null;
    });

    final success = await AppUpdateService.instance.downloadAndInstall(
      downloadUrl: widget.updateInfo.downloadUrl,
      onProgress: (
        progress,
        status, {
        receivedMegabytes,
        totalMegabytes,
      }) {
        if (!mounted) return;
        setState(() {
          _downloadProgress = progress;
          _statusMessage = switch (status) {
            AppUpdateProgressStatus.connecting => l10n.downloadConnecting,
            AppUpdateProgressStatus.downloading => l10n.downloadProgress(
                NumberFormat.decimalPattern(locale)
                    .format(receivedMegabytes ?? 0),
                NumberFormat.decimalPattern(locale).format(totalMegabytes ?? 0),
                (progress * 100).toInt(),
              ),
            AppUpdateProgressStatus.installing => l10n.openingInstaller,
          };
        });
      },
    );

    if (!mounted) return;

    if (!success) {
      setState(() {
        _isDownloading = false;
        _errorMessage = l10n.updateFailed;
      });
    } else {
      // Tunggu sebentar lalu tutup modal setelah dialog installer sistem terbuka
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', locale);
    final formattedDate = widget.updateInfo.commitDate != null
        ? dateFormat.format(widget.updateInfo.commitDate!.toLocal())
        : l10n.justNow;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 30,
            offset: Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar drag
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Icon & Title
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: AppTheme.primaryDarkGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.updateAvailable,
                              style: GoogleFonts.instrumentSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryDarkGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF81C784),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              l10n.newLabel,
                              style: GoogleFonts.instrumentSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.latestGithubVersion,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Card detail update
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FBF8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE0EFE4),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.commit_rounded,
                        size: 18,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.changeMessage,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.updateInfo.commitMessage.isNotEmpty
                        ? widget.updateInfo.commitMessage
                        : l10n.latestCommitFallback,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE0EFE4)),
                  const SizedBox(height: 12),

                  // Metadata row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildMetaItem(
                          icon: Icons.person_outline_rounded,
                          label: l10n.developer,
                          value: widget.updateInfo.authorName.isNotEmpty
                              ? widget.updateInfo.authorName
                              : l10n.githubTeam,
                        ),
                      ),
                      Expanded(
                        child: _buildMetaItem(
                          icon: Icons.tag_rounded,
                          label: l10n.commit,
                          value: widget.updateInfo.latestSha,
                        ),
                      ),
                      Expanded(
                        child: _buildMetaItem(
                          icon: Icons.access_time_rounded,
                          label: l10n.time,
                          value: formattedDate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Indikator Progress Unduhan jika sedang berjalan
            if (_isDownloading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA5D6A7), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _statusMessage,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryDarkGreen,
                          ),
                        ),
                        Text(
                          '${(_downloadProgress * 100).toInt()}%',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _downloadProgress,
                        minHeight: 8,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.installerInstructions,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              // Info ukuran APK
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.apkSizeInfo,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _errorMessage!,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade900,
                  ),
                ),
              ),
            ],

            // Tombol Utama: Update Langsung di APK
            ElevatedButton.icon(
              onPressed: _isDownloading ? null : _startDirectUpdate,
              icon: _isDownloading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.offline_bolt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
              label: Text(
                _isDownloading
                    ? l10n.downloadingProgress(
                        (_downloadProgress * 100).toInt(),
                      )
                    : l10n.directApkUpdate,
                style: GoogleFonts.instrumentSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                disabledBackgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),

            const SizedBox(height: 10),

            // Tombol Sekunder: Unduh via Browser / Nanti Saja
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isDownloading
                        ? null
                        : () async {
                            Navigator.of(context).pop();
                            await AppUpdateService.instance.launchDownloadUrl(
                              widget.updateInfo.downloadUrl,
                            );
                          },
                    icon: const Icon(
                      Icons.open_in_browser_rounded,
                      size: 16,
                      color: AppTheme.primaryDarkGreen,
                    ),
                    label: Text(
                      l10n.browserDownload,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDarkGreen,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: Color(0xFFC8E6C9),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: _isDownloading
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.laterLogin,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.instrumentSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.instrumentSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkGreen,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
