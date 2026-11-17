import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/theme/app_colors.dart';
import 'package:go_finance/core/theme/app_spacing.dart';
import 'package:go_finance/core/providers/theme_provider.dart';
import 'package:go_finance/core/widgets/rounded_square_icon.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';
import 'package:go_finance/screens/edit_profile_screen.dart';
import 'package:go_finance/screens/security_screen.dart';
import 'package:go_finance/screens/login_screen.dart';

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
  bool _notifTransaksi = true;
  bool _notifTabungan = true;

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  String _textSizeLabel(AppLocalizations l10n, TextSizeOption size) {
    switch (size) {
      case TextSizeOption.small:
        return l10n.smallTextSize;
      case TextSizeOption.medium:
        return l10n.mediumTextSize;
      case TextSizeOption.large:
        return l10n.largeTextSize;
    }
  }

  String _languageLabel(AppLocalizations l10n, LanguageOption language) {
    switch (language) {
      case LanguageOption.system:
        return l10n.languageSystem;
      case LanguageOption.indonesian:
        return l10n.languageIndonesian;
      case LanguageOption.english:
        return l10n.languageEnglish;
    }
  }

  String get _initial =>
      _username.isNotEmpty ? _username[0].toUpperCase() : '?';

  // ── Callback dari EditProfileScreen ──
  void _onProfileUpdated(String newUsername) {
    setState(() {
      _username = newUsername;
    });
  }

  // ── Zona Waktu ──
  void _showTimezonePicker() {
    final l10n = AppLocalizations.of(context)!;
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
      backgroundColor: context.colors.surface,
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
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.timezonePickerTitle,
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: context.colors.deepGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...timezones.map((tz) => ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        tz,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: _timezone == tz
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: context.colors.deepGreen,
                        ),
                      ),
                      trailing: _timezone == tz
                          ? Icon(Icons.check_circle,
                              color: context.colors.primaryText, size: 22)
                          : null,
                      onTap: () {
                        setState(() => _timezone = tz);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.timezoneChanged(tz)),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
    const themes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    final themeProvider = context.read<ThemeProvider>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
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
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.themePickerTitle,
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: context.colors.deepGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...themes.map((mode) => ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        _themeLabel(l10n, mode),
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: themeProvider.themeMode == mode
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: context.colors.deepGreen,
                        ),
                      ),
                      trailing: themeProvider.themeMode == mode
                          ? Icon(Icons.check_circle,
                              color: context.colors.primaryText, size: 22)
                          : null,
                      onTap: () async {
                        final saved = await themeProvider.setThemeMode(mode);
                        if (!ctx.mounted) return;
                        Navigator.pop(ctx);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(saved
                                ? l10n.themeChanged(_themeLabel(l10n, mode))
                                : l10n.themeSaveFailed),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
    final themeProvider = context.read<ThemeProvider>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
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
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.textSizePickerTitle,
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: context.colors.deepGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...TextSizeOption.values.map((size) => ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        _textSizeLabel(l10n, size),
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: themeProvider.textSize == size
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: context.colors.deepGreen,
                        ),
                      ),
                      trailing: themeProvider.textSize == size
                          ? Icon(Icons.check_circle,
                              color: context.colors.primaryText, size: 22)
                          : null,
                      onTap: () async {
                        final saved = await themeProvider.setTextSize(size);
                        if (!ctx.mounted) return;
                        Navigator.pop(ctx);
                        if (!saved && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.textSizeSaveFailed),
                            ),
                          );
                        }
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
    final themeProvider = context.read<ThemeProvider>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
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
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.languagePickerTitle,
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: context.colors.deepGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...LanguageOption.values.map((language) => ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        _languageLabel(l10n, language),
                        style: GoogleFonts.instrumentSans(
                          fontSize: 15,
                          fontWeight: themeProvider.language == language
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: context.colors.deepGreen,
                        ),
                      ),
                      trailing: themeProvider.language == language
                          ? Icon(Icons.check_circle,
                              color: context.colors.primaryText, size: 22)
                          : null,
                      onTap: () async {
                        final saved = await themeProvider.setLanguage(language);
                        if (!ctx.mounted) return;
                        Navigator.pop(ctx);
                        if (!saved && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.languageSaveFailed)),
                          );
                        }
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.emailDetailsTitle,
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.w700,
            color: context.colors.deepGreen,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.registeredEmail,
              style: GoogleFonts.instrumentSans(
                fontSize: 13,
                color: context.colors.mutedText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _email,
              style: GoogleFonts.instrumentSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.verificationStatus,
              style: GoogleFonts.instrumentSans(
                fontSize: 13,
                color: context.colors.mutedText,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.check_circle,
                    color: context.colors.primaryText, size: 18),
                const SizedBox(width: 6),
                Text(
                  l10n.verified,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.colors.primaryText,
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
              l10n.close,
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w600,
                color: context.colors.deepGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logout confirmation ──
  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.logoutTitle,
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.w700,
            color: context.colors.deepGreen,
          ),
        ),
        content: Text(
          l10n.logoutConfirmation,
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: context.colors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w600,
                color: context.colors.mutedText,
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
              l10n.logoutAction,
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w700,
                color: context.colors.negative,
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
      backgroundColor: context.colors.canvas,
      appBar: AppBar(
        backgroundColor: context.colors.canvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          color: context.colors.primaryText,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.profileSettingsTitle,
          style: GoogleFonts.instrumentSans(
            color: context.colors.deepGreen,
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
            _sectionHeader(AppLocalizations.of(context)!.accountSection),
            const SizedBox(height: 8),
            _buildCard(
              children: [
                CustomSettingsTile(
                  iconPath: 'assets/icons/email.png',
                  label: AppLocalizations.of(context)!.email,
                  showChevron: true,
                  onTap: _showEmailDialog,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/timezone_globe.png',
                  label: AppLocalizations.of(context)!.timezone,
                  showChevron: true,
                  trailingText: _timezone,
                  onTap: _showTimezonePicker,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/security.png',
                  label: AppLocalizations.of(context)!.security,
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
            _sectionHeader(AppLocalizations.of(context)!.preferencesSection),
            const SizedBox(height: 8),
            _buildCard(
              children: [
                CustomSettingsTile(
                  iconPath: 'assets/icons/light.png',
                  label: AppLocalizations.of(context)!.theme,
                  trailingText: _themeLabel(
                    AppLocalizations.of(context)!,
                    context.watch<ThemeProvider>().themeMode,
                  ),
                  onTap: _showThemePicker,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/font_size.png',
                  label: AppLocalizations.of(context)!.textSize,
                  trailingText: _textSizeLabel(
                    AppLocalizations.of(context)!,
                    context.watch<ThemeProvider>().textSize,
                  ),
                  onTap: _showTextSizePicker,
                ),
                const _TileDivider(),
                CustomSettingsTile(
                  iconPath: 'assets/icons/language.png',
                  label: AppLocalizations.of(context)!.language,
                  trailingText: _languageLabel(
                    AppLocalizations.of(context)!,
                    context.watch<ThemeProvider>().language,
                  ),
                  showChevron: true,
                  onTap: _showLanguagePicker,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Notifikasi ──
            _sectionHeader(AppLocalizations.of(context)!.notificationsSection),
            const SizedBox(height: 8),
            _buildCard(
              children: [
                _NotifSwitchTile(
                  iconPath: 'assets/icons/notification.png',
                  label: AppLocalizations.of(context)!.transactionNotifications,
                  value: _notifTransaksi,
                  onChanged: (val) {
                    setState(() => _notifTransaksi = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? AppLocalizations.of(context)!
                                  .transactionNotificationsEnabled
                              : AppLocalizations.of(context)!
                                  .transactionNotificationsDisabled,
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const _TileDivider(),
                _NotifSwitchTile(
                  iconPath: 'assets/icons/notification.png',
                  label: AppLocalizations.of(context)!.savingsNotifications,
                  value: _notifTabungan,
                  onChanged: (val) {
                    setState(() => _notifTabungan = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? AppLocalizations.of(context)!
                                  .savingsNotificationsEnabled
                              : AppLocalizations.of(context)!
                                  .savingsNotificationsDisabled,
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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
                  foregroundColor: context.colors.negative,
                  side: BorderSide(color: context.colors.negative),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: context.colors.canvas,
                ),
                onPressed: _showLogoutDialog,
                child: Text(
                  AppLocalizations.of(context)!.logoutFromAccount,
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
      color: context.colors.surface,
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
                backgroundColor: context.colors.softSurface,
                child: Text(
                  _initial,
                  style: GoogleFonts.instrumentSans(
                    color: context.colors.deepGreen,
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
                        color: context.colors.deepGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _email,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 13,
                        color: context.colors.mutedText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right,
                color: context.colors.mutedText,
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
        color: context.colors.deepGreen,
      ),
    );
  }

  // ── Card wrapper ──────────────────────────
  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
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
            // Ikon PNG di dalam container rounded square yang seragam
            RoundedSquareIcon(
              backgroundColor: context.colors.softSurface,
              size: 40,
              borderRadius: AppSpacing.radiusSm,
              child: SettingsIcon(iconPath),
            ),
            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  color: context.colors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Trailing text (opsional)
            if (trailingText != null)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    trailingText!,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 13,
                      color: context.colors.mutedText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            // Chevron (opsional)
            if (showChevron)
              Icon(
                Icons.chevron_right,
                color: context.colors.mutedText,
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
          RoundedSquareIcon(
            backgroundColor: context.colors.softSurface,
            size: 40,
            borderRadius: AppSpacing.radiusSm,
            child: SettingsIcon(iconPath),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: FittedBox(
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: context.colors.primaryText,
                activeTrackColor: context.colors.softSurface,
                inactiveThumbColor: context.colors.mutedText,
                inactiveTrackColor: context.colors.border,
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
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colors.border,
      indent: 54,
      endIndent: 16,
    );
  }
}
