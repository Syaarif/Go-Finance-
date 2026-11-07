import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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

/// Service untuk memeriksa, mengunduh secara langsung, dan menginstal pembaruan APK dari GitHub.
class AppUpdateService {
  AppUpdateService._();
  static final AppUpdateService instance = AppUpdateService._();

  static const MethodChannel _installerChannel =
      MethodChannel('com.gofinance.app/installer');

  // Versi build basis yang pernah dipasang user
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

    return AppUpdateInfo.noUpdate(currentSha: currentInstalledSha);
  }

  /// Mengunduh file APK langsung di dalam aplikasi dengan progress bar,
  /// lalu otomatis membuka dialog instalasi sistem Android.
  Future<bool> downloadAndInstall({
    required String downloadUrl,
    required void Function(double progress, String statusText) onProgress,
  }) async {
    try {
      onProgress(0.05, 'Menghubungkan ke GitHub...');

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 20);

      // Ikuti redirect URL jika diarahkan ke AWS S3 / CDN GitHub
      Uri targetUri = Uri.parse(downloadUrl);
      HttpClientRequest req = await client.getUrl(targetUri);
      req.headers.set('User-Agent', 'GoFinanceApp-Flutter');
      HttpClientResponse resp = await req.close();

      int redirectCount = 0;
      while ((resp.isRedirect || resp.statusCode == 302 || resp.statusCode == 301) &&
          redirectCount < 5) {
        redirectCount++;
        final location = resp.headers.value(HttpHeaders.locationHeader);
        if (location == null) break;
        targetUri = Uri.parse(location);
        req = await client.getUrl(targetUri);
        resp = await req.close();
      }

      if (resp.statusCode != 200) {
        throw Exception('Gagal mengunduh: status ${resp.statusCode}');
      }

      final contentLength = resp.contentLength;
      final int totalBytes = contentLength > 0
          ? contentLength
          : (9.4 * 1024 * 1024).toInt(); // Estimasi 9.4 MB jika chunked

      final tempDir = await getTemporaryDirectory();
      final apkFile = File('${tempDir.path}/gofinance_update.apk');
      if (await apkFile.exists()) {
        try {
          await apkFile.delete();
        } catch (_) {}
      }

      final fileSink = apkFile.openWrite();
      int receivedBytes = 0;

      await for (final chunk in resp) {
        fileSink.add(chunk);
        receivedBytes += chunk.length;
        final double p = (receivedBytes / totalBytes).clamp(0.0, 0.98);
        final mbRec = (receivedBytes / (1024 * 1024)).toStringAsFixed(1);
        final mbTot = (totalBytes / (1024 * 1024)).toStringAsFixed(1);
        onProgress(p, 'Mengunduh APK: $mbRec MB / $mbTot MB (${(p * 100).toInt()}%)');
      }

      await fileSink.flush();
      await fileSink.close();

      onProgress(1.0, 'Membuka pemasang paket Android...');

      // Panggil Native MethodChannel untuk meluncurkan Action View installer
      final bool? success = await _installerChannel.invokeMethod<bool>(
        'installApk',
        {'filePath': apkFile.path},
      );

      return success ?? false;
    } catch (e) {
      debugPrint('[AppUpdateService] Direct install failed, fallback: $e');
      return await launchDownloadUrl(downloadUrl);
    }
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
