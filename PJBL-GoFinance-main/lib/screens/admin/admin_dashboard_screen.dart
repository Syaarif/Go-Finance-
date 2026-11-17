import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/admin/admin_user_list_screen.dart';
import 'package:go_finance/screens/admin/admin_approval_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

/// 01_Admin_Dashboard — Layar utama admin
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  int _currentTab = 0;

  // Animasi counter angka
  late AnimationController _counterCtrl;
  late Animation<double> _counterAnim;

  // Data dummy
  static const _totalUsers = 5241;
  static const _pendingUsers = 42;
  static const _activeUsers = 4857;
  static const _inactiveUsers = 382;
  static const _todayTx = 1293;

  final _activities = const [
    _ActivityItem(
      initials: 'BS',
      name: 'Budi Santoso',
      action: 'Mendaftar akun baru',
      time: '2 mnt lalu',
      type: _ActivityType.pending,
    ),
    _ActivityItem(
      initials: 'SR',
      name: 'Siti Rahma',
      action: 'Verifikasi berhasil',
      time: '15 mnt lalu',
      type: _ActivityType.active,
    ),
    _ActivityItem(
      initials: 'AF',
      name: 'Ahmad Fauzi',
      action: 'Reset password',
      time: '1 jam lalu',
      type: _ActivityType.info,
    ),
    _ActivityItem(
      initials: 'DP',
      name: 'Dewi Purnama',
      action: 'Akun dinonaktifkan',
      time: '3 jam lalu',
      type: _ActivityType.inactive,
    ),
    _ActivityItem(
      initials: 'RP',
      name: 'Rizky Pratama',
      action: 'Mendaftar akun baru',
      time: '5 jam lalu',
      type: _ActivityType.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _counterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _counterAnim = CurvedAnimation(parent: _counterCtrl, curve: Curves.easeOut);
    _counterCtrl.forward();
  }

  @override
  void dispose() {
    _counterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F5),
        body: IndexedStack(
          index: _currentTab,
          children: [
            _buildDashboard(),
            const AdminUserListScreen(isEmbedded: true),
            const AdminApprovalScreen(isEmbedded: true),
            _buildSettings(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        // ── SliverAppBar gradient ──
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF15A147),
                    Color(0xFF257029),
                    Color(0xFF123D18),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Dekoratif circle
                  Positioned(
                    top: -30, right: -30,
                    child: Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20, left: -20,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selamat datang,',
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.75),
                                      ),
                                    ),
                                    Text(
                                      'Admin Super 👋',
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Notifikasi bell
                              Stack(
                                children: [
                                  Container(
                                    width: 42, height: 42,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6, right: 6,
                                    child: Container(
                                      width: 10, height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFF4444),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Card total users ──
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Pengguna Terdaftar',
                                        style: GoogleFonts.instrumentSans(
                                          fontSize: 12,
                                          color: Colors.white.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      AnimatedBuilder(
                                        animation: _counterAnim,
                                        builder: (_, __) => Text(
                                          _formatNumber(
                                              (_totalUsers * _counterAnim.value)
                                                  .round()),
                                          style: GoogleFonts.instrumentSans(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'bulan ini',
                                        style: GoogleFonts.instrumentSans(
                                          fontSize: 11,
                                          color: Colors.white.withValues(alpha: 0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '↑ 12.4%',
                                    style: GoogleFonts.instrumentSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFAAFFBB),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: Text(
            'Admin Dashboard',
            style: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          backgroundColor: const Color(0xFF257029),
        ),

        // ── Stat Cards ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StaggeredFadeSlide(
                        delay: const Duration(milliseconds: 100),
                        child: _StatCard(
                          label: 'Menunggu Review',
                          value: _pendingUsers,
                          counterAnim: _counterAnim,
                          icon: Icons.access_time_rounded,
                          iconBg: const Color(0xFFFFF3E0),
                          iconColor: const Color(0xFFFF9119),
                          valueColor: const Color(0xFFFF9119),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StaggeredFadeSlide(
                        delay: const Duration(milliseconds: 180),
                        child: _StatCard(
                          label: 'Pengguna Aktif',
                          value: _activeUsers,
                          counterAnim: _counterAnim,
                          icon: Icons.person_rounded,
                          iconBg: const Color(0xFFE8F8EE),
                          iconColor: const Color(0xFF15A147),
                          valueColor: const Color(0xFF15A147),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StaggeredFadeSlide(
                        delay: const Duration(milliseconds: 260),
                        child: _StatCard(
                          label: 'Nonaktif',
                          value: _inactiveUsers,
                          counterAnim: _counterAnim,
                          icon: Icons.person_off_rounded,
                          iconBg: const Color(0xFFFFEBEB),
                          iconColor: const Color(0xFFE63939),
                          valueColor: const Color(0xFFE63939),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StaggeredFadeSlide(
                        delay: const Duration(milliseconds: 340),
                        child: _StatCard(
                          label: 'Transaksi Hari Ini',
                          value: _todayTx,
                          counterAnim: _counterAnim,
                          icon: Icons.credit_card_rounded,
                          iconBg: const Color(0xFFE3EDFF),
                          iconColor: const Color(0xFF3A82F7),
                          valueColor: const Color(0xFF3A82F7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Aktivitas Terbaru ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Aktivitas Terbaru',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _currentTab = 1),
                      child: Text(
                        'Lihat Semua →',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF15A147),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // ── Daftar aktivitas ──
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final act = _activities[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: StaggeredFadeSlide(
                  delay: Duration(milliseconds: 400 + i * 80),
                  child: _ActivityCard(item: act),
                ),
              );
            },
            childCount: _activities.length,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildSettings() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF257029),
            title: Text(
              'Pengaturan Admin',
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Avatar admin
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8F8EE),
                      border: Border.all(
                          color: const Color(0xFF15A147), width: 2.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.admin_panel_settings_rounded,
                          size: 40, color: Color(0xFF15A147)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Admin Super',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A))),
                  Text('admin@gofinance.id',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 13, color: const Color(0xFF808080))),
                  const SizedBox(height: 28),

                  // Menu pengaturan
                  ...[
                    ('Notifikasi', Icons.notifications_outlined),
                    ('Keamanan & Password', Icons.lock_outline_rounded),
                    ('Log Aktivitas', Icons.history_rounded),
                    ('Kelola Admin', Icons.manage_accounts_rounded),
                    ('Bantuan', Icons.help_outline_rounded),
                  ].map((e) => _SettingTile(label: e.$1, icon: e.$2)),

                  const SizedBox(height: 12),
                  _SettingTile(
                    label: 'Keluar',
                    icon: Icons.logout_rounded,
                    isDestructive: true,
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44, height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const Icon(Icons.logout_rounded,
                size: 48, color: Color(0xFFE63939)),
            const SizedBox(height: 16),
            Text('Keluar dari Admin?',
                style: GoogleFonts.instrumentSans(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Kamu akan keluar dari sesi admin ini.',
                textAlign: TextAlign.center,
                style: GoogleFonts.instrumentSans(
                    fontSize: 14, color: const Color(0xFF808080))),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Batal',
                        style: GoogleFonts.instrumentSans(
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE63939),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Keluar',
                        style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      (Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard'),
      (Icons.people_rounded, Icons.people_outline_rounded, 'Pengguna'),
      (Icons.check_circle_rounded, Icons.check_circle_outline_rounded, 'Approval'),
      (Icons.settings_rounded, Icons.settings_outlined, 'Pengaturan'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = _currentTab == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _currentTab = i);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFE8F8EE)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            selected ? items[i].$1 : items[i].$2,
                            color: selected
                                ? const Color(0xFF15A147)
                                : const Color(0xFF9E9E9E),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].$3,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? const Color(0xFF15A147)
                                : const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final str = n.toString();
      return '${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}';
    }
    return n.toString();
  }
}

// ───────── Stat Card ─────────
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Animation<double> counterAnim;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.counterAnim,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.instrumentSans(
              fontSize: 11,
              color: const Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedBuilder(
            animation: counterAnim,
            builder: (_, __) {
              final displayed = (value * counterAnim.value).round();
              return Text(
                displayed >= 1000
                    ? '${displayed ~/ 1000},${(displayed % 1000).toString().padLeft(3, '0')}'
                    : displayed.toString(),
                style: GoogleFonts.instrumentSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ───────── Activity Types ─────────
enum _ActivityType { pending, active, inactive, info }

class _ActivityItem {
  final String initials;
  final String name;
  final String action;
  final String time;
  final _ActivityType type;

  const _ActivityItem({
    required this.initials,
    required this.name,
    required this.action,
    required this.time,
    required this.type,
  });
}

// ───────── Activity Card ─────────
class _ActivityCard extends StatelessWidget {
  final _ActivityItem item;

  const _ActivityCard({required this.item});

  Color get _dotColor {
    switch (item.type) {
      case _ActivityType.pending:
        return const Color(0xFFFF9119);
      case _ActivityType.active:
        return const Color(0xFF15A147);
      case _ActivityType.inactive:
        return const Color(0xFFE63939);
      case _ActivityType.info:
        return const Color(0xFF3A82F7);
    }
  }

  Color get _avatarBg => _dotColor.withValues(alpha: 0.12);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _avatarBg,
            ),
            child: Center(
              child: Text(
                item.initials,
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _dotColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  item.action,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 11,
                    color: const Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
          // Waktu + dot
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _dotColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.time,
                style: GoogleFonts.instrumentSans(
                  fontSize: 10,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ───────── Setting Tile ─────────
class _SettingTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.label,
    required this.icon,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFE63939)
        : const Color(0xFF1A1A1A);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x07000000), blurRadius: 6, offset: Offset(0, 1))
        ],
      ),
      child: ListTile(
        onTap: onTap ?? () {},
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: isDestructive
                ? const Color(0xFFFFEBEB)
                : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          label,
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDestructive
              ? const Color(0xFFE63939)
              : const Color(0xFFCCCCCC),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
