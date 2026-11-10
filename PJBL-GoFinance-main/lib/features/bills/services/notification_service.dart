import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:go_finance/features/bills/models/bill.dart';

/// Layanan notifikasi lokal terjadwal (H-7 dan H-1 pukul 09:00 waktu lokal).
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static bool get _isTestEnv =>
      Platform.environment.containsKey('FLUTTER_TEST');

  static const String _channelId = 'go_finance_bills_channel';
  static const String _channelName = 'Pengingat Tagihan';
  static const String _channelDesc =
      'Notifikasi pengingat tagihan H-7 dan H-1 sebelum jatuh tempo';

  /// ID deterministik berbasis `bill.id` (31-bit positif) untuk H-7.
  static int idForH7(String billId) => (billId.hashCode & 0x3FFFFFFF) * 2;

  /// ID deterministik berbasis `bill.id` (31-bit positif) untuk H-1.
  static int idForH1(String billId) => (billId.hashCode & 0x3FFFFFFF) * 2 + 1;

  /// Inisialisasi timezone, plugin notifikasi, dan permintaan izin Android 13+/iOS.
  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    if (_isTestEnv) {
      _initialized = true;
      return;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _plugin.initialize(settings);
      await requestPermissions();
      _initialized = true;
    } catch (_) {
      // Aman pada environment unit/widget test yang belum memiliki platform channel
      _initialized = true;
    }
  }

  /// Meminta izin notifikasi pada Android 13+ dan iOS.
  Future<void> requestPermissions() async {
    if (_isTestEnv) return;
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();

      final iosImpl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Abaikan bila platform tidak mendukung
    }
  }

  /// Menjadwalkan 2 notifikasi (H-7 & H-1 jam 09:00 lokal) untuk [bill].
  /// Jika waktu pengingat sudah terlewat, notifikasi tersebut tidak dijadwalkan.
  Future<void> scheduleBillReminders(Bill bill) async {
    if (!_initialized) {
      await init();
    }
    if (bill.isDone) return;

    final now = DateTime.now();
    final dueNineAm = DateTime(
      bill.dueDate.year,
      bill.dueDate.month,
      bill.dueDate.day,
      9,
      0,
    );

    final h7Date = dueNineAm.subtract(const Duration(days: 7));
    final h1Date = dueNineAm.subtract(const Duration(days: 1));

    final currencyFmt = NumberFormat.decimalPattern('id_ID');
    final dateFmt = DateFormat('d MMM yyyy', 'id_ID');
    final formattedNominal = currencyFmt.format(bill.amount);
    final formattedDate = dateFmt.format(bill.dueDate);
    final title = 'Tagihan ${bill.name} segera jatuh tempo';

    if (h7Date.isAfter(now)) {
      await _scheduleSingle(
        id: idForH7(bill.id),
        title: title,
        body: 'Rp $formattedNominal jatuh tempo $formattedDate (7 hari lagi)',
        scheduledLocal: h7Date,
      );
    }

    if (h1Date.isAfter(now)) {
      await _scheduleSingle(
        id: idForH1(bill.id),
        title: title,
        body: 'Rp $formattedNominal jatuh tempo $formattedDate (besok)',
        scheduledLocal: h1Date,
      );
    }
  }

  Future<void> _scheduleSingle({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledLocal,
  }) async {
    if (_isTestEnv) return;
    try {
      final tzDate = tz.TZDateTime.from(scheduledLocal, tz.local);
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      // Aman jika dipanggil di environment unit/widget test
    }
  }

  /// Membatalkan kedua jadwal notifikasi (H-7 dan H-1) milik [billId].
  Future<void> cancelBillReminders(String billId) async {
    if (_isTestEnv) return;
    try {
      await _plugin.cancel(idForH7(billId));
      await _plugin.cancel(idForH1(billId));
    } catch (_) {
      // Aman jika dipanggil di environment unit/widget test
    }
  }
}

