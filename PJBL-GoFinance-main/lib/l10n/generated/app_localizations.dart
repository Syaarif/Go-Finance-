import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @smallTextSize.
  ///
  /// In id, this message translates to:
  /// **'Kecil'**
  String get smallTextSize;

  /// No description provided for @mediumTextSize.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get mediumTextSize;

  /// No description provided for @largeTextSize.
  ///
  /// In id, this message translates to:
  /// **'Besar'**
  String get largeTextSize;

  /// No description provided for @languageSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikut sistem'**
  String get languageSystem;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In id, this message translates to:
  /// **'Mengikuti Sistem'**
  String get themeSystem;

  /// No description provided for @timezonePickerTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Zona Waktu'**
  String get timezonePickerTitle;

  /// No description provided for @timezoneChanged.
  ///
  /// In id, this message translates to:
  /// **'Zona waktu diubah ke {timezone}'**
  String timezoneChanged(Object timezone);

  /// No description provided for @themePickerTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Tema'**
  String get themePickerTitle;

  /// No description provided for @themeChanged.
  ///
  /// In id, this message translates to:
  /// **'Tema diubah ke {theme}'**
  String themeChanged(Object theme);

  /// No description provided for @themeSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Tema gagal disimpan. Coba lagi.'**
  String get themeSaveFailed;

  /// No description provided for @textSizePickerTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Ukuran Teks'**
  String get textSizePickerTitle;

  /// No description provided for @textSizeSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Ukuran teks gagal disimpan. Coba lagi.'**
  String get textSizeSaveFailed;

  /// No description provided for @languagePickerTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get languagePickerTitle;

  /// No description provided for @languageSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Bahasa gagal disimpan. Coba lagi.'**
  String get languageSaveFailed;

  /// No description provided for @emailDetailsTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Email'**
  String get emailDetailsTitle;

  /// No description provided for @registeredEmail.
  ///
  /// In id, this message translates to:
  /// **'Email terdaftar:'**
  String get registeredEmail;

  /// No description provided for @verificationStatus.
  ///
  /// In id, this message translates to:
  /// **'Status verifikasi:'**
  String get verificationStatus;

  /// No description provided for @verified.
  ///
  /// In id, this message translates to:
  /// **'Terverifikasi'**
  String get verified;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @logoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar Akun'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar dari aplikasi Go Finance?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @logoutAction.
  ///
  /// In id, this message translates to:
  /// **'Ya, Keluar'**
  String get logoutAction;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil & Pengaturan'**
  String get profileSettingsTitle;

  /// No description provided for @accountSection.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get accountSection;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @timezone.
  ///
  /// In id, this message translates to:
  /// **'Zona waktu'**
  String get timezone;

  /// No description provided for @security.
  ///
  /// In id, this message translates to:
  /// **'Keamanan'**
  String get security;

  /// No description provided for @preferencesSection.
  ///
  /// In id, this message translates to:
  /// **'Preferensi'**
  String get preferencesSection;

  /// No description provided for @theme.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @textSize.
  ///
  /// In id, this message translates to:
  /// **'Ukuran teks'**
  String get textSize;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @notificationsSection.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notificationsSection;

  /// No description provided for @transactionNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi transaksi'**
  String get transactionNotifications;

  /// No description provided for @transactionNotificationsEnabled.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi transaksi diaktifkan'**
  String get transactionNotificationsEnabled;

  /// No description provided for @transactionNotificationsDisabled.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi transaksi dinonaktifkan'**
  String get transactionNotificationsDisabled;

  /// No description provided for @savingsNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi tabungan'**
  String get savingsNotifications;

  /// No description provided for @savingsNotificationsEnabled.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi tabungan diaktifkan'**
  String get savingsNotificationsEnabled;

  /// No description provided for @savingsNotificationsDisabled.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi tabungan dinonaktifkan'**
  String get savingsNotificationsDisabled;

  /// No description provided for @logoutFromAccount.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun'**
  String get logoutFromAccount;

  /// No description provided for @home.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get home;

  /// No description provided for @transactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get transactions;

  /// No description provided for @savings.
  ///
  /// In id, this message translates to:
  /// **'Tabungan'**
  String get savings;

  /// No description provided for @bills.
  ///
  /// In id, this message translates to:
  /// **'Tagihan'**
  String get bills;

  /// No description provided for @scan.
  ///
  /// In id, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @editProfile.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfile;

  /// No description provided for @profilePhoto.
  ///
  /// In id, this message translates to:
  /// **'Foto Profil'**
  String get profilePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ambil dari kamera'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari galeri'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In id, this message translates to:
  /// **'Hapus foto'**
  String get removePhoto;

  /// No description provided for @photoUploadSimulation.
  ///
  /// In id, this message translates to:
  /// **'{label} (simulasi) — fitur unggah foto belum tersedia'**
  String photoUploadSimulation(Object label);

  /// No description provided for @profileUpdated.
  ///
  /// In id, this message translates to:
  /// **'Profil berhasil diperbarui'**
  String get profileUpdated;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ubah foto profil'**
  String get changeProfilePhoto;

  /// No description provided for @username.
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In id, this message translates to:
  /// **'Masukkan username'**
  String get enterUsername;

  /// No description provided for @usernameRequired.
  ///
  /// In id, this message translates to:
  /// **'Username tidak boleh kosong'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In id, this message translates to:
  /// **'Username minimal {minimum} karakter'**
  String usernameMinLength(int minimum);

  /// No description provided for @emailNotEditable.
  ///
  /// In id, this message translates to:
  /// **'Email tidak dapat diubah di halaman ini'**
  String get emailNotEditable;

  /// No description provided for @saveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get saveChanges;

  /// No description provided for @passwordChangedSimulation.
  ///
  /// In id, this message translates to:
  /// **'Password berhasil diubah (simulasi)'**
  String get passwordChangedSimulation;

  /// No description provided for @changePassword.
  ///
  /// In id, this message translates to:
  /// **'Ubah Password'**
  String get changePassword;

  /// No description provided for @passwordGuidance.
  ///
  /// In id, this message translates to:
  /// **'Gunakan minimal 8 karakter dengan kombinasi huruf dan angka.'**
  String get passwordGuidance;

  /// No description provided for @oldPassword.
  ///
  /// In id, this message translates to:
  /// **'Password lama'**
  String get oldPassword;

  /// No description provided for @enterOldPassword.
  ///
  /// In id, this message translates to:
  /// **'Masukkan password lama'**
  String get enterOldPassword;

  /// No description provided for @oldPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Password lama wajib diisi'**
  String get oldPasswordRequired;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In id, this message translates to:
  /// **'Password lama salah'**
  String get oldPasswordIncorrect;

  /// No description provided for @newPassword.
  ///
  /// In id, this message translates to:
  /// **'Password baru'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In id, this message translates to:
  /// **'Masukkan password baru'**
  String get enterNewPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Password baru wajib diisi'**
  String get newPasswordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In id, this message translates to:
  /// **'Password minimal 8 karakter'**
  String get passwordMinLength;

  /// No description provided for @passwordMustContainLettersAndNumbers.
  ///
  /// In id, this message translates to:
  /// **'Password harus mengandung huruf dan angka'**
  String get passwordMustContainLettersAndNumbers;

  /// No description provided for @newPasswordMustDiffer.
  ///
  /// In id, this message translates to:
  /// **'Password baru tidak boleh sama dengan password lama'**
  String get newPasswordMustDiffer;

  /// No description provided for @confirmNewPassword.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password baru'**
  String get confirmNewPassword;

  /// No description provided for @repeatNewPassword.
  ///
  /// In id, this message translates to:
  /// **'Ulangi password baru'**
  String get repeatNewPassword;

  /// No description provided for @passwordConfirmationRequired.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password wajib diisi'**
  String get passwordConfirmationRequired;

  /// No description provided for @passwordConfirmationMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password tidak cocok'**
  String get passwordConfirmationMismatch;

  /// No description provided for @demoPasswordNotice.
  ///
  /// In id, this message translates to:
  /// **'Mode demo: password lama dummy adalah \"{password}\".'**
  String demoPasswordNotice(Object password);

  /// No description provided for @savePassword.
  ///
  /// In id, this message translates to:
  /// **'Simpan password'**
  String get savePassword;

  /// No description provided for @targetSavings.
  ///
  /// In id, this message translates to:
  /// **'Target Tabungan'**
  String get targetSavings;

  /// No description provided for @createSavingsTargetTooltip.
  ///
  /// In id, this message translates to:
  /// **'Buat target tabungan'**
  String get createSavingsTargetTooltip;

  /// No description provided for @activeTargets.
  ///
  /// In id, this message translates to:
  /// **'Target Aktif'**
  String get activeTargets;

  /// No description provided for @startSavingTitle.
  ///
  /// In id, this message translates to:
  /// **'Yuk, Mulai Menabung!'**
  String get startSavingTitle;

  /// No description provided for @savingEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Tentukan target dan sisihkan sedikit demi sedikit — langkah kecil menuju impian besar.'**
  String get savingEmptyMessage;

  /// No description provided for @createFirstSavings.
  ///
  /// In id, this message translates to:
  /// **'Buat Tabungan Pertama'**
  String get createFirstSavings;

  /// No description provided for @totalSavings.
  ///
  /// In id, this message translates to:
  /// **'Total Tabungan'**
  String get totalSavings;

  /// No description provided for @collectedFromTargets.
  ///
  /// In id, this message translates to:
  /// **'Terkumpul dari {count} target'**
  String collectedFromTargets(int count);

  /// No description provided for @targetReached.
  ///
  /// In id, this message translates to:
  /// **'{percent}% tercapai'**
  String targetReached(int percent);

  /// No description provided for @targetDate.
  ///
  /// In id, this message translates to:
  /// **'Target: {date}'**
  String targetDate(Object date);

  /// No description provided for @savedAmountSummary.
  ///
  /// In id, this message translates to:
  /// **'{saved} dari {target}'**
  String savedAmountSummary(Object saved, Object target);

  /// No description provided for @everyDay.
  ///
  /// In id, this message translates to:
  /// **'Setiap hari'**
  String get everyDay;

  /// No description provided for @everyWeek.
  ///
  /// In id, this message translates to:
  /// **'Setiap minggu'**
  String get everyWeek;

  /// No description provided for @everyDays.
  ///
  /// In id, this message translates to:
  /// **'Setiap {days} hari'**
  String everyDays(int days);

  /// No description provided for @savingHabitTitle.
  ///
  /// In id, this message translates to:
  /// **'Mulai kebiasaan menabung'**
  String get savingHabitTitle;

  /// No description provided for @checkInNotDone.
  ///
  /// In id, this message translates to:
  /// **'Check-in belum dilakukan'**
  String get checkInNotDone;

  /// No description provided for @targetPrefix.
  ///
  /// In id, this message translates to:
  /// **'Target: {interval}'**
  String targetPrefix(Object interval);

  /// No description provided for @monthlyActivity.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Bulan Ini'**
  String get monthlyActivity;

  /// No description provided for @noMonthlyCheckIn.
  ///
  /// In id, this message translates to:
  /// **'Belum ada check-in bulan ini'**
  String get noMonthlyCheckIn;

  /// No description provided for @targetCreationIncomplete.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi nama, nominal, dan tanggal target.'**
  String get targetCreationIncomplete;

  /// No description provided for @customIntervalInvalid.
  ///
  /// In id, this message translates to:
  /// **'Interval khusus harus 1 sampai 365 hari.'**
  String get customIntervalInvalid;

  /// No description provided for @createSavingsTarget.
  ///
  /// In id, this message translates to:
  /// **'Buat Target Tabungan'**
  String get createSavingsTarget;

  /// No description provided for @createNewGoal.
  ///
  /// In id, this message translates to:
  /// **'Buat tujuan baru'**
  String get createNewGoal;

  /// No description provided for @setGoalSchedule.
  ///
  /// In id, this message translates to:
  /// **'Tentukan target dan jadwal menabungmu.'**
  String get setGoalSchedule;

  /// No description provided for @targetName.
  ///
  /// In id, this message translates to:
  /// **'Nama Target'**
  String get targetName;

  /// No description provided for @sampleLaptop.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Beli Laptop'**
  String get sampleLaptop;

  /// No description provided for @targetAmount.
  ///
  /// In id, this message translates to:
  /// **'Nominal Target'**
  String get targetAmount;

  /// No description provided for @targetDateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Target'**
  String get targetDateLabel;

  /// No description provided for @chooseTargetDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal target'**
  String get chooseTargetDate;

  /// No description provided for @savingInterval.
  ///
  /// In id, this message translates to:
  /// **'Interval Menabung'**
  String get savingInterval;

  /// No description provided for @chooseSavingFrequency.
  ///
  /// In id, this message translates to:
  /// **'Pilih seberapa sering kamu ingin menabung.'**
  String get chooseSavingFrequency;

  /// No description provided for @oneDay.
  ///
  /// In id, this message translates to:
  /// **'1 Hari'**
  String get oneDay;

  /// No description provided for @oneWeek.
  ///
  /// In id, this message translates to:
  /// **'1 Minggu'**
  String get oneWeek;

  /// No description provided for @custom.
  ///
  /// In id, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @every.
  ///
  /// In id, this message translates to:
  /// **'Setiap'**
  String get every;

  /// No description provided for @days.
  ///
  /// In id, this message translates to:
  /// **'Hari'**
  String get days;

  /// No description provided for @customIntervalHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan jumlah hari, misalnya 14 atau 30.'**
  String get customIntervalHint;

  /// No description provided for @savingSchedule.
  ///
  /// In id, this message translates to:
  /// **'Jadwal menabung: {interval}'**
  String savingSchedule(Object interval);

  /// No description provided for @saveAnytime.
  ///
  /// In id, this message translates to:
  /// **'Kamu tetap bisa menabung kapan saja.'**
  String get saveAnytime;

  /// No description provided for @goalSummary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Target'**
  String get goalSummary;

  /// No description provided for @target.
  ///
  /// In id, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @schedule.
  ///
  /// In id, this message translates to:
  /// **'Jadwal'**
  String get schedule;

  /// No description provided for @saveTargetButton.
  ///
  /// In id, this message translates to:
  /// **'Simpan Target'**
  String get saveTargetButton;

  /// No description provided for @validAmount.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nominal yang valid!'**
  String get validAmount;

  /// No description provided for @insufficientActiveBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo aktif tidak mencukupi untuk menabung {amount}!'**
  String insufficientActiveBalance(Object amount);

  /// No description provided for @depositSuccess.
  ///
  /// In id, this message translates to:
  /// **'🎉 Berhasil menabung {amount}! Saldo tersimpan permanen.'**
  String depositSuccess(Object amount);

  /// No description provided for @insufficientSavingsBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo tabungan tidak mencukupi untuk ditarik!'**
  String get insufficientSavingsBalance;

  /// No description provided for @withdrawSuccess.
  ///
  /// In id, this message translates to:
  /// **'Berhasil mencairkan {amount} ke saldo aktif!'**
  String withdrawSuccess(Object amount);

  /// No description provided for @depositTitle.
  ///
  /// In id, this message translates to:
  /// **'Setor Tabungan'**
  String get depositTitle;

  /// No description provided for @withdrawTitle.
  ///
  /// In id, this message translates to:
  /// **'Tarik Tabungan'**
  String get withdrawTitle;

  /// No description provided for @savingManageDescription.
  ///
  /// In id, this message translates to:
  /// **'Kelola uang tabunganmu secara nyata & persisten'**
  String get savingManageDescription;

  /// No description provided for @depositTab.
  ///
  /// In id, this message translates to:
  /// **'+ Setor (Nabung)'**
  String get depositTab;

  /// No description provided for @withdrawTab.
  ///
  /// In id, this message translates to:
  /// **'- Tarik Tabungan'**
  String get withdrawTab;

  /// No description provided for @activeBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo Aktif'**
  String get activeBalance;

  /// No description provided for @savingsBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo Tabungan'**
  String get savingsBalance;

  /// No description provided for @amountCurrency.
  ///
  /// In id, this message translates to:
  /// **'Nominal (Rp)'**
  String get amountCurrency;

  /// No description provided for @optionalPurpose.
  ///
  /// In id, this message translates to:
  /// **'Tujuan / Catatan (Opsional)'**
  String get optionalPurpose;

  /// No description provided for @depositExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Beli laptop, Dana darurat'**
  String get depositExample;

  /// No description provided for @withdrawExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Keperluan mendesak'**
  String get withdrawExample;

  /// No description provided for @savePermanently.
  ///
  /// In id, this message translates to:
  /// **'Simpan ke Tabungan (Tersimpan Permanen)'**
  String get savePermanently;

  /// No description provided for @withdrawToActive.
  ///
  /// In id, this message translates to:
  /// **'Cairkan ke Saldo Aktif'**
  String get withdrawToActive;

  /// No description provided for @billCalendarTitle.
  ///
  /// In id, this message translates to:
  /// **'Kalender Tagihan'**
  String get billCalendarTitle;

  /// No description provided for @addBillTooltip.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tagihan'**
  String get addBillTooltip;

  /// No description provided for @upcomingBills.
  ///
  /// In id, this message translates to:
  /// **'Tagihan Mendatang'**
  String get upcomingBills;

  /// No description provided for @seeAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get seeAll;

  /// No description provided for @completedBillsFootnote.
  ///
  /// In id, this message translates to:
  /// **'Tagihan yang ditandai selesai akan\ndihapus dari daftar.'**
  String get completedBillsFootnote;

  /// No description provided for @noBillsForDate.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada tagihan pada {date}'**
  String noBillsForDate(Object date);

  /// No description provided for @noUpcomingBills.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tagihan mendatang'**
  String get noUpcomingBills;

  /// No description provided for @filteredBillsHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk tanggal yang sama atau tombol di bawah untuk melihat semua tagihan.'**
  String get filteredBillsHint;

  /// No description provided for @addBillHint.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan tagihan baru melalui tombol + di kanan atas.'**
  String get addBillHint;

  /// No description provided for @previousMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan sebelumnya'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan berikutnya'**
  String get nextMonth;

  /// No description provided for @overdue.
  ///
  /// In id, this message translates to:
  /// **'TERLAMBAT'**
  String get overdue;

  /// No description provided for @pending.
  ///
  /// In id, this message translates to:
  /// **'MENUNGGU'**
  String get pending;

  /// No description provided for @dueDatePrefix.
  ///
  /// In id, this message translates to:
  /// **'Jatuh tempo {date}'**
  String dueDatePrefix(Object date);

  /// No description provided for @payNow.
  ///
  /// In id, this message translates to:
  /// **'Bayar sekarang'**
  String get payNow;

  /// No description provided for @markBillDoneTitle.
  ///
  /// In id, this message translates to:
  /// **'Tandai Selesai?'**
  String get markBillDoneTitle;

  /// No description provided for @markBillDoneConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Tandai tagihan \"{billName}\" (Rp {amount}) sebagai selesai? Tagihan akan dihapus dari daftar dan pengingat dibatalkan.'**
  String markBillDoneConfirmation(Object billName, Object amount);

  /// No description provided for @markDone.
  ///
  /// In id, this message translates to:
  /// **'Tandai Selesai'**
  String get markDone;

  /// No description provided for @overdueDays.
  ///
  /// In id, this message translates to:
  /// **'Terlambat {days} hari'**
  String overdueDays(int days);

  /// No description provided for @today.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In id, this message translates to:
  /// **'Besok'**
  String get tomorrow;

  /// No description provided for @daysRemaining.
  ///
  /// In id, this message translates to:
  /// **'{days} hari lagi'**
  String daysRemaining(int days);

  /// No description provided for @addBillTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tagihan'**
  String get addBillTitle;

  /// No description provided for @billAmount.
  ///
  /// In id, this message translates to:
  /// **'Nominal Tagihan'**
  String get billAmount;

  /// No description provided for @billName.
  ///
  /// In id, this message translates to:
  /// **'Nama Tagihan'**
  String get billName;

  /// No description provided for @billNameExample.
  ///
  /// In id, this message translates to:
  /// **'Mis. Internet rumah, Listrik, Streaming'**
  String get billNameExample;

  /// No description provided for @billDueDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Jatuh Tempo'**
  String get billDueDate;

  /// No description provided for @chooseDueDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal jatuh tempo'**
  String get chooseDueDate;

  /// No description provided for @billReminderInfo.
  ///
  /// In id, this message translates to:
  /// **'Pengingat otomatis 7 hari & 1 hari sebelum jatuh tempo.'**
  String get billReminderInfo;

  /// No description provided for @checkInputAndSave.
  ///
  /// In id, this message translates to:
  /// **'Periksa Input & Simpan'**
  String get checkInputAndSave;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @billNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama tagihan wajib diisi'**
  String get billNameRequired;

  /// No description provided for @billAmountMustBePositive.
  ///
  /// In id, this message translates to:
  /// **'Nominal harus lebih dari Rp 0'**
  String get billAmountMustBePositive;

  /// No description provided for @billDateRequired.
  ///
  /// In id, this message translates to:
  /// **'Tanggal jatuh tempo wajib dipilih'**
  String get billDateRequired;

  /// No description provided for @billReminderChannel.
  ///
  /// In id, this message translates to:
  /// **'Pengingat Tagihan'**
  String get billReminderChannel;

  /// No description provided for @billReminderChannelDescription.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi pengingat tagihan H-7 dan H-1 sebelum jatuh tempo'**
  String get billReminderChannelDescription;

  /// No description provided for @billReminderTitle.
  ///
  /// In id, this message translates to:
  /// **'Tagihan {billName} segera jatuh tempo'**
  String billReminderTitle(Object billName);

  /// No description provided for @billReminderBody.
  ///
  /// In id, this message translates to:
  /// **'Rp {amount} jatuh tempo {date} ({remaining})'**
  String billReminderBody(Object amount, Object date, Object remaining);

  /// No description provided for @homeInternetBill.
  ///
  /// In id, this message translates to:
  /// **'Internet rumah'**
  String get homeInternetBill;

  /// No description provided for @electricityBill.
  ///
  /// In id, this message translates to:
  /// **'Listrik'**
  String get electricityBill;

  /// No description provided for @streamingBill.
  ///
  /// In id, this message translates to:
  /// **'Streaming'**
  String get streamingBill;

  /// No description provided for @addTransaction.
  ///
  /// In id, this message translates to:
  /// **'Tambah Transaksi'**
  String get addTransaction;

  /// No description provided for @daily.
  ///
  /// In id, this message translates to:
  /// **'Harian'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In id, this message translates to:
  /// **'Mingguan'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In id, this message translates to:
  /// **'Bulanan'**
  String get monthly;

  /// No description provided for @searchTransactions.
  ///
  /// In id, this message translates to:
  /// **'Cari transaksi...'**
  String get searchTransactions;

  /// No description provided for @yesterday.
  ///
  /// In id, this message translates to:
  /// **'Kemarin'**
  String get yesterday;

  /// No description provided for @allCategories.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get allCategories;

  /// No description provided for @foodAndDrinks.
  ///
  /// In id, this message translates to:
  /// **'Makanan & Minuman'**
  String get foodAndDrinks;

  /// No description provided for @food.
  ///
  /// In id, this message translates to:
  /// **'Makanan'**
  String get food;

  /// No description provided for @shopping.
  ///
  /// In id, this message translates to:
  /// **'Belanja'**
  String get shopping;

  /// No description provided for @transportation.
  ///
  /// In id, this message translates to:
  /// **'Transportasi'**
  String get transportation;

  /// No description provided for @transport.
  ///
  /// In id, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @transfer.
  ///
  /// In id, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @income.
  ///
  /// In id, this message translates to:
  /// **'Pemasukan'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran'**
  String get expense;

  /// No description provided for @other.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get other;

  /// No description provided for @transactionFormIncomplete.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi kategori dan nominal terlebih dahulu.'**
  String get transactionFormIncomplete;

  /// No description provided for @transactionCategory.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get transactionCategory;

  /// No description provided for @amount.
  ///
  /// In id, this message translates to:
  /// **'Nominal'**
  String get amount;

  /// No description provided for @transactionDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal transaksi'**
  String get transactionDate;

  /// No description provided for @optionalNote.
  ///
  /// In id, this message translates to:
  /// **'Catatan (opsional)'**
  String get optionalNote;

  /// No description provided for @transactionEditableNote.
  ///
  /// In id, this message translates to:
  /// **'Data dapat diedit kembali di riwayat transaksi.'**
  String get transactionEditableNote;

  /// No description provided for @selectCategory.
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori'**
  String get selectCategory;

  /// No description provided for @transactionNoteExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: uang makan siang'**
  String get transactionNoteExample;

  /// No description provided for @saveTransaction.
  ///
  /// In id, this message translates to:
  /// **'Simpan Transaksi'**
  String get saveTransaction;

  /// No description provided for @chooseCategory.
  ///
  /// In id, this message translates to:
  /// **'Pilih Kategori'**
  String get chooseCategory;

  /// No description provided for @date.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get date;

  /// No description provided for @type.
  ///
  /// In id, this message translates to:
  /// **'Tipe'**
  String get type;

  /// No description provided for @noTransactions.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada transaksi'**
  String get noTransactions;

  /// No description provided for @noTransactionsInPeriod.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi pada periode ini.'**
  String get noTransactionsInPeriod;

  /// No description provided for @continueButton.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get continueButton;

  /// No description provided for @notifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notifications;

  /// No description provided for @greeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}'**
  String greeting(Object name);

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Yuk, kelola keuanganmu dengan bijak.'**
  String get homeGreetingSubtitle;

  /// No description provided for @manualEntry.
  ///
  /// In id, this message translates to:
  /// **'Catat Manual'**
  String get manualEntry;

  /// No description provided for @payBill.
  ///
  /// In id, this message translates to:
  /// **'Bayar Tagihan'**
  String get payBill;

  /// No description provided for @recentTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Terbaru'**
  String get recentTransactions;

  /// No description provided for @balanceCalculation.
  ///
  /// In id, this message translates to:
  /// **'Pemasukan − pengeluaran − setoran tabungan'**
  String get balanceCalculation;

  /// No description provided for @monthlyAiEvaluation.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Keuangan Bulan Ini'**
  String get monthlyAiEvaluation;

  /// No description provided for @foodSpendingIncrease.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran makan naik {percent}% dari bulan lalu.'**
  String foodSpendingIncrease(int percent);

  /// No description provided for @aiSummaryHint.
  ///
  /// In id, this message translates to:
  /// **'Lihat ringkasan dan saran AI'**
  String get aiSummaryHint;

  /// No description provided for @lastSevenDays.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan 7 Hari Terakhir'**
  String get lastSevenDays;

  /// No description provided for @detail.
  ///
  /// In id, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @chartIncome.
  ///
  /// In id, this message translates to:
  /// **'{day}: Masuk Rp {amount}'**
  String chartIncome(Object day, Object amount);

  /// No description provided for @chartExpense.
  ///
  /// In id, this message translates to:
  /// **'Keluar Rp {amount}'**
  String chartExpense(Object amount);

  /// No description provided for @todayAt.
  ///
  /// In id, this message translates to:
  /// **'Hari ini · {time}'**
  String todayAt(Object time);

  /// No description provided for @aiAnalysisTitle.
  ///
  /// In id, this message translates to:
  /// **'Analisis AI Go Finance'**
  String get aiAnalysisTitle;

  /// No description provided for @aiBasedOnMonth.
  ///
  /// In id, this message translates to:
  /// **'Berdasarkan pengeluaran bulan ini'**
  String get aiBasedOnMonth;

  /// No description provided for @smartRecommendation.
  ///
  /// In id, this message translates to:
  /// **'💡 Rekomendasi Pintar'**
  String get smartRecommendation;

  /// No description provided for @aiRecommendationBody.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran makanan & minuman kamu mencapai {percent}% dari total pengeluaran bulan ini. Coba batasi pesanan pesan-antar maksimal {times} kali seminggu untuk menghemat sekitar Rp {amount}.'**
  String aiRecommendationBody(int percent, int times, Object amount);

  /// No description provided for @viewTransactionDetails.
  ///
  /// In id, this message translates to:
  /// **'Lihat Rincian Transaksi'**
  String get viewTransactionDetails;

  /// No description provided for @billNotificationTitle.
  ///
  /// In id, this message translates to:
  /// **'Tagihan Internet Jatuh Tempo'**
  String get billNotificationTitle;

  /// No description provided for @billNotificationDetails.
  ///
  /// In id, this message translates to:
  /// **'Jatuh tempo pada {date} sebesar Rp {amount}'**
  String billNotificationDetails(Object date, Object amount);

  /// No description provided for @hoursAgo.
  ///
  /// In id, this message translates to:
  /// **'{hours} jam lalu'**
  String hoursAgo(int hours);

  /// No description provided for @salaryNotificationTitle.
  ///
  /// In id, this message translates to:
  /// **'Gaji Masuk!'**
  String get salaryNotificationTitle;

  /// No description provided for @salaryNotificationDetails.
  ///
  /// In id, this message translates to:
  /// **'Pemasukan Rp {amount} berhasil dicatat.'**
  String salaryNotificationDetails(Object amount);

  /// No description provided for @splashTagline.
  ///
  /// In id, this message translates to:
  /// **'Kelola hari ini, untuk masa depan.'**
  String get splashTagline;

  /// No description provided for @onboardingHeadline.
  ///
  /// In id, this message translates to:
  /// **'Tumbuh lebih\ncerdas, Menjadi\nlebih kaya'**
  String get onboardingHeadline;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Perjalanan kamu mengelola keuangan\nlebih baik dimulai dari sini!'**
  String get onboardingSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang\nkembali!'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk untuk melanjutkan perjalanan\nkamu bersama Go Finance!'**
  String get loginSubtitle;

  /// No description provided for @welcomeNew.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang!'**
  String get welcomeNew;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar untuk memulai perjalanan\nkamu bersama Go Finance!'**
  String get registerSubtitle;

  /// No description provided for @emailFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Email:'**
  String get emailFieldLabel;

  /// No description provided for @passwordFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Password:'**
  String get passwordFieldLabel;

  /// No description provided for @emailHint.
  ///
  /// In id, this message translates to:
  /// **'nama@email.com'**
  String get emailHint;

  /// No description provided for @rememberMe.
  ///
  /// In id, this message translates to:
  /// **'Ingat saya'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In id, this message translates to:
  /// **'Lupa password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get login;

  /// No description provided for @register.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get register;

  /// No description provided for @existingAccountPrompt.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? '**
  String get existingAccountPrompt;

  /// No description provided for @noAccountPrompt.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? '**
  String get noAccountPrompt;

  /// No description provided for @passwordRecoveryMessage.
  ///
  /// In id, this message translates to:
  /// **'Tautan pemulihan password akan dikirim ke email Anda.'**
  String get passwordRecoveryMessage;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Email dan password harus diisi!'**
  String get emailPasswordRequired;

  /// No description provided for @loginSuccess.
  ///
  /// In id, this message translates to:
  /// **'Masuk berhasil! Selamat datang di Go Finance.'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In id, this message translates to:
  /// **'Akun berhasil dibuat! Silakan masuk.'**
  String get registerSuccess;

  /// No description provided for @checkGithubUpdates.
  ///
  /// In id, this message translates to:
  /// **'Periksa Pembaruan GitHub'**
  String get checkGithubUpdates;

  /// No description provided for @checkingGithubUpdates.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa pembaruan di GitHub...'**
  String get checkingGithubUpdates;

  /// No description provided for @checkingGithubUpdatesBanner.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa pembaruan dari GitHub...'**
  String get checkingGithubUpdatesBanner;

  /// No description provided for @updateAvailable.
  ///
  /// In id, this message translates to:
  /// **'Pembaruan Tersedia'**
  String get updateAvailable;

  /// No description provided for @newUpdateAvailable.
  ///
  /// In id, this message translates to:
  /// **'Pembaruan Baru Tersedia!'**
  String get newUpdateAvailable;

  /// No description provided for @updateTag.
  ///
  /// In id, this message translates to:
  /// **'PEMBARUAN'**
  String get updateTag;

  /// No description provided for @updateAction.
  ///
  /// In id, this message translates to:
  /// **'Perbarui'**
  String get updateAction;

  /// No description provided for @justNow.
  ///
  /// In id, this message translates to:
  /// **'Baru saja'**
  String get justNow;

  /// No description provided for @latestCommitFallback.
  ///
  /// In id, this message translates to:
  /// **'Pembaruan terbaru'**
  String get latestCommitFallback;

  /// No description provided for @updateCommitByAuthor.
  ///
  /// In id, this message translates to:
  /// **'{message} ({author})'**
  String updateCommitByAuthor(Object message, Object author);

  /// No description provided for @newLabel.
  ///
  /// In id, this message translates to:
  /// **'BARU'**
  String get newLabel;

  /// No description provided for @latestGithubVersion.
  ///
  /// In id, this message translates to:
  /// **'Versi terbaru dari GitHub repo'**
  String get latestGithubVersion;

  /// No description provided for @changeMessage.
  ///
  /// In id, this message translates to:
  /// **'Pesan Perubahan:'**
  String get changeMessage;

  /// No description provided for @developer.
  ///
  /// In id, this message translates to:
  /// **'Pengembang'**
  String get developer;

  /// No description provided for @githubTeam.
  ///
  /// In id, this message translates to:
  /// **'Tim GitHub'**
  String get githubTeam;

  /// No description provided for @commit.
  ///
  /// In id, this message translates to:
  /// **'Commit'**
  String get commit;

  /// No description provided for @time.
  ///
  /// In id, this message translates to:
  /// **'Waktu'**
  String get time;

  /// No description provided for @installerInstructions.
  ///
  /// In id, this message translates to:
  /// **'Setelah selesai, jendela instalasi APK akan otomatis muncul di layar.'**
  String get installerInstructions;

  /// No description provided for @apkSizeInfo.
  ///
  /// In id, this message translates to:
  /// **'Ukuran APK: ~9.4 MB (Update langsung tanpa browser)'**
  String get apkSizeInfo;

  /// No description provided for @downloadingProgress.
  ///
  /// In id, this message translates to:
  /// **'Sedang Mengunduh ({percent}%)...'**
  String downloadingProgress(int percent);

  /// No description provided for @directApkUpdate.
  ///
  /// In id, this message translates to:
  /// **'Update Langsung di APK (~9.4 MB)'**
  String get directApkUpdate;

  /// No description provided for @browserDownload.
  ///
  /// In id, this message translates to:
  /// **'Lewat Browser'**
  String get browserDownload;

  /// No description provided for @laterLogin.
  ///
  /// In id, this message translates to:
  /// **'Nanti Saja (Masuk)'**
  String get laterLogin;

  /// No description provided for @updateFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuka installer otomatis. Kamu bisa mengunduh lewat browser.'**
  String get updateFailed;

  /// No description provided for @downloadPreparing.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan unduhan...'**
  String get downloadPreparing;

  /// No description provided for @downloadConnecting.
  ///
  /// In id, this message translates to:
  /// **'Menghubungkan ke server GitHub...'**
  String get downloadConnecting;

  /// No description provided for @downloadFailedStatus.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengunduh: status {status}'**
  String downloadFailedStatus(Object status);

  /// No description provided for @downloadProgress.
  ///
  /// In id, this message translates to:
  /// **'Mengunduh APK: {received} MB / {total} MB ({percent}%)'**
  String downloadProgress(Object received, Object total, int percent);

  /// No description provided for @openingInstaller.
  ///
  /// In id, this message translates to:
  /// **'Membuka pemasang paket Android...'**
  String get openingInstaller;

  /// No description provided for @receiptAnalysisTitle.
  ///
  /// In id, this message translates to:
  /// **'AI Analisis Struk'**
  String get receiptAnalysisTitle;

  /// No description provided for @uploadReceiptFile.
  ///
  /// In id, this message translates to:
  /// **'Unggah file struk'**
  String get uploadReceiptFile;

  /// No description provided for @receiptUploadInstructions.
  ///
  /// In id, this message translates to:
  /// **'Pilih foto atau PDF bukti transaksi kamu.'**
  String get receiptUploadInstructions;

  /// No description provided for @filePickerUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Pemilih file akan tersedia setelah integrasi.'**
  String get filePickerUnavailable;

  /// No description provided for @selectedFile.
  ///
  /// In id, this message translates to:
  /// **'File dipilih'**
  String get selectedFile;

  /// No description provided for @noFileSelected.
  ///
  /// In id, this message translates to:
  /// **'Belum ada file dipilih'**
  String get noFileSelected;

  /// No description provided for @startAiAnalysis.
  ///
  /// In id, this message translates to:
  /// **'Mulai Analisis AI'**
  String get startAiAnalysis;

  /// No description provided for @fileProcessingNotice.
  ///
  /// In id, this message translates to:
  /// **'File akan diproses setelah kamu menekan tombol.'**
  String get fileProcessingNotice;

  /// No description provided for @upload.
  ///
  /// In id, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @review.
  ///
  /// In id, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @tapToUploadReceipt.
  ///
  /// In id, this message translates to:
  /// **'Ketuk untuk Unggah File Struk'**
  String get tapToUploadReceipt;

  /// No description provided for @supportedReceiptFormats.
  ///
  /// In id, this message translates to:
  /// **'Mendukung format JPG, PNG, PDF'**
  String get supportedReceiptFormats;

  /// No description provided for @maxFileSize.
  ///
  /// In id, this message translates to:
  /// **'Ukuran maksimal 10 MB'**
  String get maxFileSize;

  /// No description provided for @removeFile.
  ///
  /// In id, this message translates to:
  /// **'Hapus file'**
  String get removeFile;

  /// No description provided for @receiptPhotoTipTitle.
  ///
  /// In id, this message translates to:
  /// **'Pastikan struk terlihat jelas'**
  String get receiptPhotoTipTitle;

  /// No description provided for @receiptPhotoTipBody.
  ///
  /// In id, this message translates to:
  /// **'dan semua informasi terbaca agar hasil analisis AI lebih akurat.'**
  String get receiptPhotoTipBody;

  /// No description provided for @receiptFileSize.
  ///
  /// In id, this message translates to:
  /// **'JPG · {size} MB'**
  String receiptFileSize(Object size);

  /// No description provided for @analysisComplete.
  ///
  /// In id, this message translates to:
  /// **'Analisis selesai'**
  String get analysisComplete;

  /// No description provided for @processingReceipt.
  ///
  /// In id, this message translates to:
  /// **'Memproses struk'**
  String get processingReceipt;

  /// No description provided for @analysisSimulationComplete.
  ///
  /// In id, this message translates to:
  /// **'Simulasi selesai. Hasil OCR belum tersedia.'**
  String get analysisSimulationComplete;

  /// No description provided for @transactionExtractionSimulation.
  ///
  /// In id, this message translates to:
  /// **'Simulasi ekstraksi data transaksi...'**
  String get transactionExtractionSimulation;

  /// No description provided for @uploadingPhoto.
  ///
  /// In id, this message translates to:
  /// **'Mengunggah foto'**
  String get uploadingPhoto;

  /// No description provided for @readingMerchantDate.
  ///
  /// In id, this message translates to:
  /// **'Membaca merchant dan tanggal'**
  String get readingMerchantDate;

  /// No description provided for @calculatingItems.
  ///
  /// In id, this message translates to:
  /// **'Menghitung total dan item'**
  String get calculatingItems;

  /// No description provided for @backToUpload.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke halaman upload'**
  String get backToUpload;

  /// No description provided for @doNotCloseApp.
  ///
  /// In id, this message translates to:
  /// **'Jangan tutup aplikasi dulu'**
  String get doNotCloseApp;

  /// No description provided for @checkAiResults.
  ///
  /// In id, this message translates to:
  /// **'Periksa Hasil AI'**
  String get checkAiResults;

  /// No description provided for @extractionSuccessful.
  ///
  /// In id, this message translates to:
  /// **'Ekstraksi berhasil'**
  String get extractionSuccessful;

  /// No description provided for @checkBeforeSave.
  ///
  /// In id, this message translates to:
  /// **'Periksa kembali data sebelum disimpan.'**
  String get checkBeforeSave;

  /// No description provided for @ocrNotIntegrated.
  ///
  /// In id, this message translates to:
  /// **'Data contoh; OCR/AI belum terhubung.'**
  String get ocrNotIntegrated;

  /// No description provided for @transactionDraft.
  ///
  /// In id, this message translates to:
  /// **'Draft transaksi'**
  String get transactionDraft;

  /// No description provided for @editAiResults.
  ///
  /// In id, this message translates to:
  /// **'Hasil AI bisa kamu edit jika ada yang kurang tepat.'**
  String get editAiResults;

  /// No description provided for @merchantName.
  ///
  /// In id, this message translates to:
  /// **'Nama Merchant'**
  String get merchantName;

  /// No description provided for @totalAmount.
  ///
  /// In id, this message translates to:
  /// **'Nominal Total'**
  String get totalAmount;

  /// No description provided for @transactionDateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Transaksi'**
  String get transactionDateLabel;

  /// No description provided for @tapPencilToEdit.
  ///
  /// In id, this message translates to:
  /// **'Ketuk ikon pensil untuk mengubah data.'**
  String get tapPencilToEdit;

  /// No description provided for @receiptSource.
  ///
  /// In id, this message translates to:
  /// **'Sumber: {fileName}'**
  String receiptSource(Object fileName);

  /// No description provided for @confirmAndSave.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi & Simpan'**
  String get confirmAndSave;

  /// No description provided for @editFieldTooltip.
  ///
  /// In id, this message translates to:
  /// **'Ubah {label}'**
  String editFieldTooltip(Object label);

  /// No description provided for @receiptTransactionSaved.
  ///
  /// In id, this message translates to:
  /// **'Transaksi {merchant} berhasil disimpan.'**
  String receiptTransactionSaved(Object merchant);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
