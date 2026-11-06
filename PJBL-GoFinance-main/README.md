# 💰 Go Finance

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

**Go Finance** adalah aplikasi mobile manajemen keuangan pribadi berbasis Flutter yang dikembangkan khusus untuk platform **Android**. Aplikasi ini dibuat sebagai proyek PJBL kelas XI SMK Negeri 8 Semarang.

## 📱 Fitur Utama

- **Splash Screen & Onboarding** — Tampilan pembuka dan pengenalan aplikasi yang interaktif.
- **Login & Registrasi** — Autentikasi akun dengan validasi form, animasi Glow Input, dan Bounce Button.
- **Kalender Tagihan** — Pengelolaan jadwal pembayaran tagihan.
- **Pengingat Lokal** — Notifikasi pengingat jatuh tempo tagihan secara terjadwal (H-7 dan H-1).
- **Profil & Pengaturan Akun** — Pengelolaan profil, keamanan, preferensi, dan notifikasi.
- **Bottom Navigation Bar** — Navigasi utama untuk Beranda, Transaksi, Scan, Tabungan, dan Tagihan.
- **Animasi & UI Modern** — Tampilan interaktif dengan animasi yang halus.

## 🛠️ Teknologi

- **Flutter** — Framework pengembangan aplikasi Android.
- **Dart** — Bahasa pemrograman.
- **Provider** — State management.
- **Flutter Local Notifications** — Pengelolaan notifikasi lokal.

## 🚀 Cara Menjalankan Project

Pastikan Flutter SDK dan Android SDK sudah terpasang.

Masuk ke direktori project Flutter:

```bash
cd PJBL-GoFinance-main
```

Install seluruh dependency:

```bash
flutter pub get
```

Jalankan aplikasi pada Android Emulator atau perangkat Android:

```bash
flutter run
```

## 📦 Build APK Android

Untuk membuat APK release:

```bash
flutter build apk --release
```

File APK akan tersedia di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

**Go Finance — Manage Your Money, Grow Your Future.**