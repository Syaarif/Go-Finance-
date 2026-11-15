// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get smallTextSize => 'Kecil';

  @override
  String get mediumTextSize => 'Sedang';

  @override
  String get largeTextSize => 'Besar';

  @override
  String get languageSystem => 'Ikut sistem';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Mengikuti Sistem';

  @override
  String get timezonePickerTitle => 'Pilih Zona Waktu';

  @override
  String timezoneChanged(Object timezone) {
    return 'Zona waktu diubah ke $timezone';
  }

  @override
  String get themePickerTitle => 'Pilih Tema';

  @override
  String themeChanged(Object theme) {
    return 'Tema diubah ke $theme';
  }

  @override
  String get themeSaveFailed => 'Tema gagal disimpan. Coba lagi.';

  @override
  String get textSizePickerTitle => 'Pilih Ukuran Teks';

  @override
  String get textSizeSaveFailed => 'Ukuran teks gagal disimpan. Coba lagi.';

  @override
  String get languagePickerTitle => 'Pilih Bahasa';

  @override
  String get languageSaveFailed => 'Bahasa gagal disimpan. Coba lagi.';

  @override
  String get emailDetailsTitle => 'Detail Email';

  @override
  String get registeredEmail => 'Email terdaftar:';

  @override
  String get verificationStatus => 'Status verifikasi:';

  @override
  String get verified => 'Terverifikasi';

  @override
  String get close => 'Tutup';

  @override
  String get back => 'Kembali';

  @override
  String get logoutTitle => 'Keluar Akun';

  @override
  String get logoutConfirmation =>
      'Apakah Anda yakin ingin keluar dari aplikasi Go Finance?';

  @override
  String get cancel => 'Batal';

  @override
  String get logoutAction => 'Ya, Keluar';

  @override
  String get profileSettingsTitle => 'Profil & Pengaturan';

  @override
  String get accountSection => 'Akun';

  @override
  String get email => 'Email';

  @override
  String get timezone => 'Zona waktu';

  @override
  String get security => 'Keamanan';

  @override
  String get preferencesSection => 'Preferensi';

  @override
  String get theme => 'Tema';

  @override
  String get textSize => 'Ukuran teks';

  @override
  String get language => 'Bahasa';

  @override
  String get notificationsSection => 'Notifikasi';

  @override
  String get transactionNotifications => 'Notifikasi transaksi';

  @override
  String get transactionNotificationsEnabled =>
      'Notifikasi transaksi diaktifkan';

  @override
  String get transactionNotificationsDisabled =>
      'Notifikasi transaksi dinonaktifkan';

  @override
  String get savingsNotifications => 'Notifikasi tabungan';

  @override
  String get savingsNotificationsEnabled => 'Notifikasi tabungan diaktifkan';

  @override
  String get savingsNotificationsDisabled =>
      'Notifikasi tabungan dinonaktifkan';

  @override
  String get logoutFromAccount => 'Keluar dari akun';

  @override
  String get home => 'Beranda';

  @override
  String get transactions => 'Transaksi';

  @override
  String get savings => 'Tabungan';

  @override
  String get bills => 'Tagihan';

  @override
  String get scan => 'Scan';

  @override
  String get editProfile => 'Edit Profil';

  @override
  String get profilePhoto => 'Foto Profil';

  @override
  String get takePhoto => 'Ambil dari kamera';

  @override
  String get chooseFromGallery => 'Pilih dari galeri';

  @override
  String get removePhoto => 'Hapus foto';

  @override
  String photoUploadSimulation(Object label) {
    return '$label (simulasi) — fitur unggah foto belum tersedia';
  }

  @override
  String get profileUpdated => 'Profil berhasil diperbarui';

  @override
  String get changeProfilePhoto => 'Ubah foto profil';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Masukkan username';

  @override
  String get usernameRequired => 'Username tidak boleh kosong';

  @override
  String usernameMinLength(int minimum) {
    return 'Username minimal $minimum karakter';
  }

  @override
  String get emailNotEditable => 'Email tidak dapat diubah di halaman ini';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get passwordChangedSimulation => 'Password berhasil diubah (simulasi)';

  @override
  String get changePassword => 'Ubah Password';

  @override
  String get passwordGuidance =>
      'Gunakan minimal 8 karakter dengan kombinasi huruf dan angka.';

  @override
  String get oldPassword => 'Password lama';

  @override
  String get enterOldPassword => 'Masukkan password lama';

  @override
  String get oldPasswordRequired => 'Password lama wajib diisi';

  @override
  String get oldPasswordIncorrect => 'Password lama salah';

  @override
  String get newPassword => 'Password baru';

  @override
  String get enterNewPassword => 'Masukkan password baru';

  @override
  String get newPasswordRequired => 'Password baru wajib diisi';

  @override
  String get passwordMinLength => 'Password minimal 8 karakter';

  @override
  String get passwordMustContainLettersAndNumbers =>
      'Password harus mengandung huruf dan angka';

  @override
  String get newPasswordMustDiffer =>
      'Password baru tidak boleh sama dengan password lama';

  @override
  String get confirmNewPassword => 'Konfirmasi password baru';

  @override
  String get repeatNewPassword => 'Ulangi password baru';

  @override
  String get passwordConfirmationRequired => 'Konfirmasi password wajib diisi';

  @override
  String get passwordConfirmationMismatch => 'Konfirmasi password tidak cocok';

  @override
  String demoPasswordNotice(Object password) {
    return 'Mode demo: password lama dummy adalah \"$password\".';
  }

  @override
  String get savePassword => 'Simpan password';

  @override
  String get targetSavings => 'Target Tabungan';

  @override
  String get createSavingsTargetTooltip => 'Buat target tabungan';

  @override
  String get activeTargets => 'Target Aktif';

  @override
  String get startSavingTitle => 'Yuk, Mulai Menabung!';

  @override
  String get savingEmptyMessage =>
      'Tentukan target dan sisihkan sedikit demi sedikit — langkah kecil menuju impian besar.';

  @override
  String get createFirstSavings => 'Buat Tabungan Pertama';

  @override
  String get totalSavings => 'Total Tabungan';

  @override
  String collectedFromTargets(int count) {
    return 'Terkumpul dari $count target';
  }

  @override
  String targetReached(int percent) {
    return '$percent% tercapai';
  }

  @override
  String targetDate(Object date) {
    return 'Target: $date';
  }

  @override
  String savedAmountSummary(Object saved, Object target) {
    return '$saved dari $target';
  }

  @override
  String get everyDay => 'Setiap hari';

  @override
  String get everyWeek => 'Setiap minggu';

  @override
  String everyDays(int days) {
    return 'Setiap $days hari';
  }

  @override
  String get savingHabitTitle => 'Mulai kebiasaan menabung';

  @override
  String get checkInNotDone => 'Check-in belum dilakukan';

  @override
  String targetPrefix(Object interval) {
    return 'Target: $interval';
  }

  @override
  String get monthlyActivity => 'Aktivitas Bulan Ini';

  @override
  String get noMonthlyCheckIn => 'Belum ada check-in bulan ini';

  @override
  String get targetCreationIncomplete =>
      'Lengkapi nama, nominal, dan tanggal target.';

  @override
  String get customIntervalInvalid =>
      'Interval khusus harus 1 sampai 365 hari.';

  @override
  String get createSavingsTarget => 'Buat Target Tabungan';

  @override
  String get createNewGoal => 'Buat tujuan baru';

  @override
  String get setGoalSchedule => 'Tentukan target dan jadwal menabungmu.';

  @override
  String get targetName => 'Nama Target';

  @override
  String get sampleLaptop => 'Contoh: Beli Laptop';

  @override
  String get targetAmount => 'Nominal Target';

  @override
  String get targetDateLabel => 'Tanggal Target';

  @override
  String get chooseTargetDate => 'Pilih tanggal target';

  @override
  String get savingInterval => 'Interval Menabung';

  @override
  String get chooseSavingFrequency =>
      'Pilih seberapa sering kamu ingin menabung.';

  @override
  String get oneDay => '1 Hari';

  @override
  String get oneWeek => '1 Minggu';

  @override
  String get custom => 'Custom';

  @override
  String get every => 'Setiap';

  @override
  String get days => 'Hari';

  @override
  String get customIntervalHint => 'Masukkan jumlah hari, misalnya 14 atau 30.';

  @override
  String savingSchedule(Object interval) {
    return 'Jadwal menabung: $interval';
  }

  @override
  String get saveAnytime => 'Kamu tetap bisa menabung kapan saja.';

  @override
  String get goalSummary => 'Ringkasan Target';

  @override
  String get target => 'Target';

  @override
  String get schedule => 'Jadwal';

  @override
  String get saveTargetButton => 'Simpan Target';

  @override
  String get validAmount => 'Masukkan nominal yang valid!';

  @override
  String insufficientActiveBalance(Object amount) {
    return 'Saldo aktif tidak mencukupi untuk menabung $amount!';
  }

  @override
  String depositSuccess(Object amount) {
    return '🎉 Berhasil menabung $amount! Saldo tersimpan permanen.';
  }

  @override
  String get insufficientSavingsBalance =>
      'Saldo tabungan tidak mencukupi untuk ditarik!';

  @override
  String withdrawSuccess(Object amount) {
    return 'Berhasil mencairkan $amount ke saldo aktif!';
  }

  @override
  String get depositTitle => 'Setor Tabungan';

  @override
  String get withdrawTitle => 'Tarik Tabungan';

  @override
  String get savingManageDescription =>
      'Kelola uang tabunganmu secara nyata & persisten';

  @override
  String get depositTab => '+ Setor (Nabung)';

  @override
  String get withdrawTab => '- Tarik Tabungan';

  @override
  String get activeBalance => 'Saldo Aktif';

  @override
  String get savingsBalance => 'Saldo Tabungan';

  @override
  String get amountCurrency => 'Nominal (Rp)';

  @override
  String get optionalPurpose => 'Tujuan / Catatan (Opsional)';

  @override
  String get depositExample => 'Contoh: Beli laptop, Dana darurat';

  @override
  String get withdrawExample => 'Contoh: Keperluan mendesak';

  @override
  String get savePermanently => 'Simpan ke Tabungan (Tersimpan Permanen)';

  @override
  String get withdrawToActive => 'Cairkan ke Saldo Aktif';

  @override
  String get billCalendarTitle => 'Kalender Tagihan';

  @override
  String get addBillTooltip => 'Tambah Tagihan';

  @override
  String get upcomingBills => 'Tagihan Mendatang';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get completedBillsFootnote =>
      'Tagihan yang ditandai selesai akan\ndihapus dari daftar.';

  @override
  String noBillsForDate(Object date) {
    return 'Tidak ada tagihan pada $date';
  }

  @override
  String get noUpcomingBills => 'Belum ada tagihan mendatang';

  @override
  String get filteredBillsHint =>
      'Ketuk tanggal yang sama atau tombol di bawah untuk melihat semua tagihan.';

  @override
  String get addBillHint =>
      'Tambahkan tagihan baru melalui tombol + di kanan atas.';

  @override
  String get previousMonth => 'Bulan sebelumnya';

  @override
  String get nextMonth => 'Bulan berikutnya';

  @override
  String get overdue => 'TERLAMBAT';

  @override
  String get pending => 'MENUNGGU';

  @override
  String dueDatePrefix(Object date) {
    return 'Jatuh tempo $date';
  }

  @override
  String get payNow => 'Bayar sekarang';

  @override
  String get markBillDoneTitle => 'Tandai Selesai?';

  @override
  String markBillDoneConfirmation(Object billName, Object amount) {
    return 'Tandai tagihan \"$billName\" (Rp $amount) sebagai selesai? Tagihan akan dihapus dari daftar dan pengingat dibatalkan.';
  }

  @override
  String get markDone => 'Tandai Selesai';

  @override
  String overdueDays(int days) {
    return 'Terlambat $days hari';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get tomorrow => 'Besok';

  @override
  String daysRemaining(int days) {
    return '$days hari lagi';
  }

  @override
  String get addBillTitle => 'Tambah Tagihan';

  @override
  String get billAmount => 'Nominal Tagihan';

  @override
  String get billName => 'Nama Tagihan';

  @override
  String get billNameExample => 'Mis. Internet rumah, Listrik, Streaming';

  @override
  String get billDueDate => 'Tanggal Jatuh Tempo';

  @override
  String get chooseDueDate => 'Pilih tanggal jatuh tempo';

  @override
  String get billReminderInfo =>
      'Pengingat otomatis 7 hari & 1 hari sebelum jatuh tempo.';

  @override
  String get checkInputAndSave => 'Periksa Input & Simpan';

  @override
  String get save => 'Simpan';

  @override
  String get billNameRequired => 'Nama tagihan wajib diisi';

  @override
  String get billAmountMustBePositive => 'Nominal harus lebih dari Rp 0';

  @override
  String get billDateRequired => 'Tanggal jatuh tempo wajib dipilih';

  @override
  String get billReminderChannel => 'Pengingat Tagihan';

  @override
  String get billReminderChannelDescription =>
      'Notifikasi pengingat tagihan H-7 dan H-1 sebelum jatuh tempo';

  @override
  String billReminderTitle(Object billName) {
    return 'Tagihan $billName segera jatuh tempo';
  }

  @override
  String billReminderBody(Object amount, Object date, Object remaining) {
    return 'Rp $amount jatuh tempo $date ($remaining)';
  }

  @override
  String get homeInternetBill => 'Internet rumah';

  @override
  String get electricityBill => 'Listrik';

  @override
  String get streamingBill => 'Streaming';

  @override
  String get addTransaction => 'Tambah Transaksi';

  @override
  String get daily => 'Harian';

  @override
  String get weekly => 'Mingguan';

  @override
  String get monthly => 'Bulanan';

  @override
  String get searchTransactions => 'Cari transaksi...';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get allCategories => 'Semua';

  @override
  String get foodAndDrinks => 'Makanan & Minuman';

  @override
  String get food => 'Makanan';

  @override
  String get shopping => 'Belanja';

  @override
  String get transportation => 'Transportasi';

  @override
  String get transport => 'Transport';

  @override
  String get transfer => 'Transfer';

  @override
  String get income => 'Pemasukan';

  @override
  String get expense => 'Pengeluaran';

  @override
  String get other => 'Lainnya';

  @override
  String get transactionFormIncomplete =>
      'Lengkapi kategori dan nominal terlebih dahulu.';

  @override
  String get transactionCategory => 'Kategori';

  @override
  String get amount => 'Nominal';

  @override
  String get transactionDate => 'Tanggal transaksi';

  @override
  String get optionalNote => 'Catatan (opsional)';

  @override
  String get transactionEditableNote =>
      'Data dapat diedit kembali di riwayat transaksi.';

  @override
  String get selectCategory => 'Pilih kategori';

  @override
  String get transactionNoteExample => 'Contoh: uang makan siang';

  @override
  String get saveTransaction => 'Simpan Transaksi';

  @override
  String get chooseCategory => 'Pilih Kategori';

  @override
  String get date => 'Tanggal';

  @override
  String get type => 'Tipe';

  @override
  String get noTransactions => 'Tidak ada transaksi';

  @override
  String get noTransactionsInPeriod => 'Belum ada transaksi pada periode ini.';

  @override
  String get continueButton => 'Lanjutkan';

  @override
  String get notifications => 'Notifikasi';

  @override
  String greeting(Object name) {
    return 'Halo, $name';
  }

  @override
  String get homeGreetingSubtitle => 'Yuk, kelola keuanganmu dengan bijak.';

  @override
  String get manualEntry => 'Catat Manual';

  @override
  String get payBill => 'Bayar Tagihan';

  @override
  String get recentTransactions => 'Transaksi Terbaru';

  @override
  String get balanceCalculation => 'Pemasukan − pengeluaran − setoran tabungan';

  @override
  String get monthlyAiEvaluation => 'Evaluasi Keuangan Bulan Ini';

  @override
  String foodSpendingIncrease(int percent) {
    return 'Pengeluaran makan naik $percent% dari bulan lalu.';
  }

  @override
  String get aiSummaryHint => 'Lihat ringkasan dan saran AI';

  @override
  String get lastSevenDays => 'Ringkasan 7 Hari Terakhir';

  @override
  String get detail => 'Detail';

  @override
  String chartIncome(Object day, Object amount) {
    return '$day: Masuk Rp $amount';
  }

  @override
  String chartExpense(Object amount) {
    return 'Keluar Rp $amount';
  }

  @override
  String todayAt(Object time) {
    return 'Hari ini · $time';
  }

  @override
  String get aiAnalysisTitle => 'Analisis AI Go Finance';

  @override
  String get aiBasedOnMonth => 'Berdasarkan pengeluaran bulan ini';

  @override
  String get smartRecommendation => '💡 Rekomendasi Pintar';

  @override
  String aiRecommendationBody(int percent, int times, Object amount) {
    return 'Pengeluaran makanan & minuman kamu mencapai $percent% dari total pengeluaran bulan ini. Coba batasi pesanan pesan-antar maksimal $times kali seminggu untuk menghemat sekitar Rp $amount.';
  }

  @override
  String get viewTransactionDetails => 'Lihat Rincian Transaksi';

  @override
  String get billNotificationTitle => 'Tagihan Internet Jatuh Tempo';

  @override
  String billNotificationDetails(Object date, Object amount) {
    return 'Jatuh tempo pada $date sebesar Rp $amount';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours jam lalu';
  }

  @override
  String get salaryNotificationTitle => 'Gaji Masuk!';

  @override
  String salaryNotificationDetails(Object amount) {
    return 'Pemasukan Rp $amount berhasil dicatat.';
  }

  @override
  String get splashTagline => 'Kelola hari ini, untuk masa depan.';

  @override
  String get onboardingHeadline => 'Tumbuh lebih\ncerdas, Menjadi\nlebih kaya';

  @override
  String get onboardingSubtitle =>
      'Perjalanan kamu mengelola keuangan\nlebih baik dimulai dari sini!';

  @override
  String get welcomeBack => 'Selamat datang\nkembali!';

  @override
  String get loginSubtitle =>
      'Masuk untuk melanjutkan perjalanan\nkamu bersama Go Finance!';

  @override
  String get welcomeNew => 'Selamat datang!';

  @override
  String get registerSubtitle =>
      'Daftar untuk memulai perjalanan\nkamu bersama Go Finance!';

  @override
  String get emailFieldLabel => 'Email:';

  @override
  String get passwordFieldLabel => 'Password:';

  @override
  String get emailHint => 'nama@email.com';

  @override
  String get rememberMe => 'Ingat saya';

  @override
  String get forgotPassword => 'Lupa password?';

  @override
  String get login => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get existingAccountPrompt => 'Sudah punya akun? ';

  @override
  String get noAccountPrompt => 'Belum punya akun? ';

  @override
  String get passwordRecoveryMessage =>
      'Tautan pemulihan password akan dikirim ke email Anda.';

  @override
  String get emailPasswordRequired => 'Email dan password harus diisi!';

  @override
  String get loginSuccess => 'Masuk berhasil! Selamat datang di Go Finance.';

  @override
  String get registerSuccess => 'Akun berhasil dibuat! Silakan masuk.';

  @override
  String get checkGithubUpdates => 'Periksa Pembaruan GitHub';

  @override
  String get checkingGithubUpdates => 'Memeriksa pembaruan di GitHub...';

  @override
  String get checkingGithubUpdatesBanner =>
      'Memeriksa pembaruan dari GitHub...';

  @override
  String get updateAvailable => 'Pembaruan Tersedia';

  @override
  String get newUpdateAvailable => 'Pembaruan Baru Tersedia!';

  @override
  String get updateTag => 'PEMBARUAN';

  @override
  String get updateAction => 'Perbarui';

  @override
  String get justNow => 'Baru saja';

  @override
  String get latestCommitFallback => 'Pembaruan terbaru';

  @override
  String updateCommitByAuthor(Object message, Object author) {
    return '$message ($author)';
  }

  @override
  String get newLabel => 'BARU';

  @override
  String get latestGithubVersion => 'Versi terbaru dari GitHub repo';

  @override
  String get changeMessage => 'Pesan Perubahan:';

  @override
  String get developer => 'Pengembang';

  @override
  String get githubTeam => 'Tim GitHub';

  @override
  String get commit => 'Commit';

  @override
  String get time => 'Waktu';

  @override
  String get installerInstructions =>
      'Setelah selesai, jendela instalasi APK akan otomatis muncul di layar.';

  @override
  String get apkSizeInfo =>
      'Ukuran APK: ~9.4 MB (Update langsung tanpa browser)';

  @override
  String downloadingProgress(int percent) {
    return 'Sedang Mengunduh ($percent%)...';
  }

  @override
  String get directApkUpdate => 'Update Langsung di APK (~9.4 MB)';

  @override
  String get browserDownload => 'Lewat Browser';

  @override
  String get laterLogin => 'Nanti Saja (Masuk)';

  @override
  String get updateFailed =>
      'Gagal membuka installer otomatis. Kamu bisa mengunduh lewat browser.';

  @override
  String get downloadPreparing => 'Menyiapkan unduhan...';

  @override
  String get downloadConnecting => 'Menghubungkan ke server GitHub...';

  @override
  String downloadFailedStatus(Object status) {
    return 'Gagal mengunduh: status $status';
  }

  @override
  String downloadProgress(Object received, Object total, int percent) {
    return 'Mengunduh APK: $received MB / $total MB ($percent%)';
  }

  @override
  String get openingInstaller => 'Membuka pemasang paket Android...';

  @override
  String get receiptAnalysisTitle => 'AI Analisis Struk';

  @override
  String get uploadReceiptFile => 'Unggah file struk';

  @override
  String get receiptUploadInstructions =>
      'Pilih foto atau PDF bukti transaksi kamu.';

  @override
  String get filePickerUnavailable =>
      'Pemilih file akan tersedia setelah integrasi.';

  @override
  String get selectedFile => 'File dipilih';

  @override
  String get noFileSelected => 'Belum ada file dipilih';

  @override
  String get startAiAnalysis => 'Mulai Analisis AI';

  @override
  String get fileProcessingNotice =>
      'File akan diproses setelah kamu menekan tombol.';

  @override
  String get upload => 'Upload';

  @override
  String get review => 'Review';

  @override
  String get tapToUploadReceipt => 'Ketuk untuk Unggah File Struk';

  @override
  String get supportedReceiptFormats => 'Mendukung format JPG, PNG, PDF';

  @override
  String get maxFileSize => 'Ukuran maksimal 10 MB';

  @override
  String get removeFile => 'Hapus file';

  @override
  String get receiptPhotoTipTitle => 'Pastikan struk terlihat jelas';

  @override
  String get receiptPhotoTipBody =>
      'dan semua informasi terbaca agar hasil analisis AI lebih akurat.';

  @override
  String receiptFileSize(Object size) {
    return 'JPG · $size MB';
  }

  @override
  String get analysisComplete => 'Analisis selesai';

  @override
  String get processingReceipt => 'Memproses struk';

  @override
  String get analysisSimulationComplete =>
      'Simulasi selesai. Hasil OCR belum tersedia.';

  @override
  String get transactionExtractionSimulation =>
      'Simulasi ekstraksi data transaksi...';

  @override
  String get uploadingPhoto => 'Mengunggah foto';

  @override
  String get readingMerchantDate => 'Membaca merchant dan tanggal';

  @override
  String get calculatingItems => 'Menghitung total dan item';

  @override
  String get backToUpload => 'Kembali ke halaman upload';

  @override
  String get doNotCloseApp => 'Jangan tutup aplikasi dulu';

  @override
  String get checkAiResults => 'Periksa Hasil AI';

  @override
  String get extractionSuccessful => 'Ekstraksi berhasil';

  @override
  String get checkBeforeSave => 'Periksa kembali data sebelum disimpan.';

  @override
  String get ocrNotIntegrated => 'Data contoh; OCR/AI belum terhubung.';

  @override
  String get transactionDraft => 'Draft transaksi';

  @override
  String get editAiResults =>
      'Hasil AI bisa kamu edit jika ada yang kurang tepat.';

  @override
  String get merchantName => 'Nama Merchant';

  @override
  String get totalAmount => 'Nominal Total';

  @override
  String get transactionDateLabel => 'Tanggal Transaksi';

  @override
  String get tapPencilToEdit => 'Ketuk ikon pensil untuk mengubah data.';

  @override
  String receiptSource(Object fileName) {
    return 'Sumber: $fileName';
  }

  @override
  String get confirmAndSave => 'Konfirmasi & Simpan';

  @override
  String editFieldTooltip(Object label) {
    return 'Ubah $label';
  }

  @override
  String receiptTransactionSaved(Object merchant) {
    return 'Transaksi $merchant berhasil disimpan.';
  }
}
