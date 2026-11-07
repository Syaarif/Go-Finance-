import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Informasi pembaruan aplikasi dari GitHub.
class AppUpdateInfo {
  final bool hasUpdate;
  final String currentSha;
  final String latestSha;
  final String commitMessage;
  final String authorName;
  final DateTime? commitDate;
  final String releaseTagName;
  final String downloadUrl;
  final String releasePageUrl;

  const AppUpdateInfo({
    required this.hasUpdate,
    required this.currentSha,
    required this.latestSha,
    required this.commitMessage,
    required this.authorName,
    this.commitDate,
    required this.releaseTagName,
    required this.downloadUrl,
    required this.releasePageUrl,
  });

  factory AppUpdateInfo.noUpdate({
    required String currentSha,
    String releaseTagName = 'v1.0.0',
  }) {
    return AppUpdateInfo(
      hasUpdate: false,
      currentSha: currentSha,
      latestSha: currentSha,
      commitMessage: 'Aplikasi sudah versi terbaru.',
      authorName: '',
      releaseTagName: releaseTagName,
      downloadUrl: 'https://github.com/Syaarif/Go-Finance-/releases/latest',
      releasePageUrl: 'https://github.com/Syaarif/Go-Finance-/releases/tag/latest',
    );
  }
}

/// Service untuk memeriksa dan mengunduh pembaruan APK dari GitHub.
class AppUpdateService {
  AppUpdateService._();
  static final AppUpdateService instance = AppUpdateService._();

  // Commit SHA versi build yang sedang terpasang pada APK user
  static const String currentInstalledSha = '16bac3d';
  static const String currentInstalledVersion = '1.0.0';

  static const String repoOwner = 'Syaarif';
  static const String repoName = 'Go-Finance-';

  static const String fallbackDownloadUrl =
      'https://github.com/$repoOwner/$repoName/releases/download/latest/GoFinance-arm64-v8a-ringan.apk';
  static const String releasePageUrl =
      'https://github.com/$repoOwner/$repoName/releases/tag/latest';

  AppUpdateInfo? _cachedInfo;
  DateTime? _lastChecked;

  /// Memeriksa apakah ada pembaruan baru di GitHub.
  Future<AppUpdateInfo> checkForUpdate({bool forceRefresh = false}) async {
    // Cache hasil pemeriksaan selama 1 menit agar hemat request ke GitHub
    if (!forceRefresh &&
        _cachedInfo != null &&
        _lastChecked != null &&
        DateTime.now().difference(_lastChecked!) < const Duration(minutes: 1)) {
      return _cachedInfo!;
    }

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 8);

      final uri = Uri.parse(
        'https://api.github.com/repos/$repoOwner/$repoName/commits/main',
      );
      final request = await client.getUrl(uri);
      request.headers.set('User-Agent', 'GoFinanceApp-Flutter');
      request.headers.set('Accept', 'application/vnd.github.v3+json');

      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final json = jsonDecode(body) as Map<String, dynamic>;

        final latestFullSha = (json['sha'] as String?) ?? '';
        final latestShortSha = latestFullSha.length >= 7
            ? latestFullSha.substring(0, 7)
            : latestFullSha;

        final commitObj = json['commit'] as Map<String, dynamic>?;
        final commitMessage = (commitObj?['message'] as String?) ?? 'Pembaruan terbaru';
        final authorObj = commitObj?['author'] as Map<String, dynamic>?;
        final authorName = (authorObj?['name'] as String?) ?? 'Kontributor';
        final dateStr = authorObj?['date'] as String?;
        final commitDate = dateStr != null ? DateTime.tryParse(dateStr) : null;

        // Cek apakah commit terbaru berbeda dengan versi terpasang
        final bool isDifferentCommit =
            latestShortSha.isNotEmpty &&
            !currentInstalledSha.toLowerCase().startsWith(latestShortSha.toLowerCase()) &&
            !latestShortSha.toLowerCase().startsWith(currentInstalledSha.toLowerCase());

        _cachedInfo = AppUpdateInfo(
          hasUpdate: isDifferentCommit,
          currentSha: currentInstalledSha,
          latestSha: latestShortSha,
          commitMessage: commitMessage.split('\n').first.trim(),
          authorName: authorName,
          commitDate: commitDate,
          releaseTagName: 'latest',
          downloadUrl: fallbackDownloadUrl,
          releasePageUrl: releasePageUrl,
        );
        _lastChecked = DateTime.now();
        return _cachedInfo!;
      }
    } catch (e) {
      debugPrint('[AppUpdateService] Error checking for update: $e');
    }

    // Jika offline atau gagal fetch, kembalikan status aman tanpa update
    return AppUpdateInfo.noUpdate(currentSha: currentInstalledSha);
  }

  /// Membuka tautan unduhan APK di browser HP pengguna.
  Future<bool> launchDownloadUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('[AppUpdateService] Failed to open download url: $e');
      return false;
    }
  }
}
