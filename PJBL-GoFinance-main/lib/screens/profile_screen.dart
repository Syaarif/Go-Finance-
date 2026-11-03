import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/edit_profile_screen.dart';
import 'package:go_finance/screens/security_screen.dart';
import 'package:go_finance/screens/login_screen.dart';

// ─────────────────────────────────────────────
// Warna kustom khusus layar profil
// ─────────────────────────────────────────────
class ProfileColors {
  static const Color background = Color(0xFFF4F1EB);
  static const Color darkGreen = Color(0xFF22361B);
  static const Color lightGreenBg = Color(0xFFD6EFC7);
  static const Color cardWhite = Colors.white;
  static const Color textGrey = Color(0xFF888888);
  static const Color chevronGrey = Color(0xFFAAAAAA);
  static const Color redAccent = Color(0xFFCC3333);
  static const Color divider = Color(0xFFEEEEEE);
}

// ═════════════════════════════════════════════
// ProfileScreen
// ═════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Dummy data & state lokal ──
  String _username = 'Wowowi';
  final String _email = 'Wowodanwiwi@email.com';
  String _timezone = 'WIB (UTC+7)';
  String _theme = 'Terang';
  String _textSize = 'Standar';
  String _language = 'Indonesia';
  bool _notifTransaksi = true;
  bool _notifTabungan = true;

  String get _initial => _username.isNotEmpty ? _username[0].toUpperCase() : '?';

  // ── Callback dari EditProfileScreen ──
  void _onProfileUpdated(String newUsername) {
    setState(() {
      _username = newUsername;
    });
  }

  // ── Zona Waktu ──
  void _showTimezonePicker() {
    final timezones = [
      'WIB (UTC+7)',
      'WITA (UTC+8)',
      'WIT (UTC+9)',
      'GMT (UTC+0)',
      'EST (UTC-5)',
      'PST (UTC-8)',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih Zona Waktu',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ProfileColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...timezones.map((tz) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        tz,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: _timezone == tz ? FontWeight.w700 : FontWeight.w400,
                          color: ProfileColors.darkGreen,
                        ),
                      ),
                      trailing: _timezone == tz
                          ? const Icon(Icons.check_circle, color: ProfileColors.darkGreen, size: 22)
                          : null,
                      onTap: () {
                        setState(() => _timezone = tz);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Zona waktu diubah ke $tz'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Tema ──
  void _showThemePicker() {
    final themes = ['Terang', 'Gelap', 'Mengikuti Sistem'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih Tema',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ProfileColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...themes.map((t) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        t,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: _theme == t ? FontWeight.w700 : FontWeight.w400,
                          color: ProfileColors.darkGreen,
                        ),
                      ),
                      trailing: _theme == t
                          ? const Icon(Icons.check_circle, color: ProfileColors.darkGreen, size: 22)
                          : null,
                      onTap: () {
                        setState(() => _theme = t);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tema diubah ke $t'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Ukuran Teks ──
  void _showTextSizePicker() {
    final sizes = ['Kecil', 'Standar', 'Besar'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih Ukuran Teks',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ProfileColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...sizes.map((s) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        s,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: _textSize == s ? FontWeight.w700 : FontWeight.w400,
                          color: ProfileColors.darkGreen,
                        ),
                      ),
                      trailing: _textSize == s
                          ? const Icon(Icons.check_circle, color: ProfileColors.darkGreen, size: 22)
                          : null,
                      onTap: () {
                        setState(() => _textSize = s);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ukuran teks diubah ke $s'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Bahasa ──
  void _showLanguagePicker() {
    final languages = ['Indonesia', 'English'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih Bahasa',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ProfileColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...languages.map((l) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        l,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: _language == l ? FontWeight.w700 : FontWeight.w400,
                          color: ProfileColors.darkGreen,
                        ),
                      ),
                      trailing: _language == l
                          ? const Icon(Icons.check_circle, color: ProfileColors.darkGreen, size: 22)
                          : null,
                      onTap: () {
                        setState(() => _language = l);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bahasa diubah ke $l'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Email detail dialog ──
  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Detail Email',
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.w700,
            color: ProfileColors.darkGreen,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email terdaftar:',
              style: GoogleFonts.instrumentSans(
                fontSize: 13,
                color: ProfileColors.textGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _email,
              style: GoogleFonts.instrumentSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ProfileColors.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Status verifikasi:',
              style: GoogleFonts.instrumentSans(
                fontSize: 13,
                color: ProfileColors.textGrey,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF347928), size: 18),
                const SizedBox(width: 6),
                Text(
                  'Terverifikasi',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF347928),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Tutup',
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w600,
                color: ProfileColors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logout confirmation ──
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar Akun',
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.w700,
            color: ProfileColors.darkGreen,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi Go Finance?',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: ProfileColors.darkGreen,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w600,
                color: ProfileColors.textGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog
              // Navigasi ke LoginScreen, hapus semua route sebelumnya
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Ya, Keluar',
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w700,
                color: ProfileColors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          color: ProfileColors.darkGreen,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Profil & Pengaturan',
          style: GoogleFonts.instrumentSans(
            color: ProfileColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──
            _buildProfileCard(),
            const SizedBox(height: 24),

            // ── Akun ──
            _sectionHeader('Akun'),
            const SizedBox(height: 8),
            _buildCard(
              children: [
                CustomSettingsTile(
                  iconPath: 'assets/icons/email.png',
                  label: 'Email',
                  showChevron: true,
                  onTap: _showEmailDialog,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/timezone_globe.png',
                  label: 'Zona waktu',
                  showChevron: true,
                  trailingText: _timezone,
                  onTap: _showTimezonePicker,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/security.png',
                  label: 'Keamanan',
                  showChevron: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SecurityScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Preferensi ──
            _sectionHeader('Preferensi'),
            const SizedBox(height: 8),
            _buildCard(
              children: [
                CustomSettingsTile(
                  iconPath: 'assets/icons/light.png',
                  label: 'Tema',
                  trailingText: _theme,
                  onTap: _showThemePicker,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/font_size.png',
                  label: 'Ukuran teks',
                  trailingText: _textSize,
                  onTap: _showTextSizePicker,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/language.png',
                  label: 'Bahasa / Language',
                  trailingText: _language,
                  showChevron: true,
                  onTap: _showLanguagePicker,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Notifikasi ──
            _sectionHeader('Notifikasi'),
            const SizedBox(height: 8),
            _buildCard(
              children: [
                _NotifSwitchTile(
                  iconPath: 'assets/icons/notification.png',
                  label: 'Notifikasi transaksi',
                  value: _notifTransaksi,
                  onChanged: (val) {
                    setState(() => _notifTransaksi = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val ? 'Notifikasi transaksi diaktifkan' : 'Notifikasi transaksi dinonaktifkan',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const _TileDivider(),
                _NotifSwitchTile(
                  iconPath: 'assets/icons/notification.png',
                  label: 'Notifikasi tabungan',
                  value: _notifTabungan,
                  onChanged: (val) {
                    setState(() => _notifTabungan = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val ? 'Notifikasi tabungan diaktifkan' : 'Notifikasi tabungan dinonaktifkan',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Tombol Keluar ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: ProfileColors.redAccent,
                  side: const BorderSide(color: ProfileColors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                onPressed: _showLogoutDialog,
                child: Text(
                  'Keluar dari akun',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Profile Card ──────────────────────────
  Widget _buildProfileCard() {
    return Material(
      color: ProfileColors.cardWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfileScreen(
                currentUsername: _username,
                currentEmail: _email,
              ),
            ),
          );
          if (result != null && result.isNotEmpty) {
            _onProfileUpdated(result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Avatar inisial
              CircleAvatar(
                radius: 26,
                backgroundColor: ProfileColors.lightGreenBg,
                child: Text(
                  _initial,
                  style: GoogleFonts.instrumentSans(
                    color: ProfileColors.darkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Nama & email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _username,
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ProfileColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _email,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 13,
                        color: ProfileColors.textGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Chevron
              const Icon(
                Icons.chevron_right,
                color: ProfileColors.chevronGrey,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section header ────────────────────────
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.instrumentSans(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: ProfileColors.darkGreen,
      ),
    );
  }

  // ── Card wrapper ──────────────────────────
  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: ProfileColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

// ═════════════════════════════════════════════
// CustomSettingsTile — widget reusable
// ═════════════════════════════════════════════
class CustomSettingsTile extends StatelessWidget {
  final String iconPath;
  final String label;
  final String? trailingText;
  final bool showChevron;
  final VoidCallback? onTap;

  const CustomSettingsTile({
    super.key,
    required this.iconPath,
    required this.label,
    this.trailingText,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Ikon PNG (diekstrak dari file SVG Figma yang berisi bitmap)
            SettingsIcon(iconPath),
            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: ProfileColors.darkGreen,
                ),
              ),
            ),

            // Trailing text (opsional)
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  trailingText!,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 13,
                    color: ProfileColors.textGrey,
                  ),
                ),
              ),

            // Chevron (opsional)
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                color: ProfileColors.chevronGrey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// SettingsIcon — ikon menu 24x24 dari asset PNG
// ═════════════════════════════════════════════
class SettingsIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const SettingsIcon(this.assetPath, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      // Placeholder berukuran sama agar layout tidak bergeser bila asset gagal dimuat
      errorBuilder: (_, __, ___) => SizedBox(width: size, height: size),
    );
  }
}

// ═════════════════════════════════════════════
// _NotifSwitchTile — tile dengan Switch
// ═════════════════════════════════════════════
class _NotifSwitchTile extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifSwitchTile({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          SettingsIcon(iconPath),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: ProfileColors.darkGreen,
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: FittedBox(
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: ProfileColors.darkGreen,
                activeTrackColor: ProfileColors.lightGreenBg,
                inactiveThumbColor: ProfileColors.textGrey,
                inactiveTrackColor: ProfileColors.divider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Divider tipis di antara tile
// ═════════════════════════════════════════════
class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: ProfileColors.divider,
      indent: 54,
      endIndent: 16,
    );
  }
}
