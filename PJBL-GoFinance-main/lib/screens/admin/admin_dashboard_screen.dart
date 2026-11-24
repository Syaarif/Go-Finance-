import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
import 'package:go_finance/core/services/aws_auth_service.dart';
import 'package:go_finance/screens/login_screen.dart';
import 'package:go_finance/screens/admin/admin_user_list_screen.dart';
import 'package:go_finance/screens/admin/admin_approval_screen.dart';
import 'package:go_finance/screens/admin/admin_notification_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

/// 01_Admin_Dashboard — Layar utama admin terhubung ke AWS RDS
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  int _currentTab = 0;

  final ScrollController _dashboardScrollCtrl = ScrollController();
  bool _isHeaderCollapsed = false;

  late AnimationController _counterCtrl;
  late Animation<double> _counterAnim;

  late AnimationController _tabAnimCtrl;
  late Animation<double> _tabAnim;

  bool _isLoadingStats = true;
  int _totalUsers = 0;
  int _pendingUsers = 0;
  int _activeUsers = 0;
  int _inactiveUsers = 0;
  List<_ActivityItem> _activities = [];

  @override
  void initState() {
    super.initState();
    _dashboardScrollCtrl.addListener(_onDashboardScroll);
    _counterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _counterAnim =
        CurvedAnimation(parent: _counterCtrl, curve: Curves.easeOut);

    _tabAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _tabAnim =
        CurvedAnimation(parent: _tabAnimCtrl, curve: Curves.easeOut);
    _tabAnimCtrl.value = 1.0;

    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoadingStats = true);
    try {
      final rawUsers = await AwsApiService.instance.getAdminUsers();
      final users = rawUsers
          .map((e) => Map<String, dynamic>.from(e as Map))
          .where((u) => (u['role'] ?? 'user').toString().toLowerCase() != 'admin')
          .toList();

      int pending = 0;
      int approved = 0;
      int inactive = 0;

      for (final u in users) {
        final st = (u['status'] ?? 'pending').toString().toLowerCase();
        if (st == 'pending') {
          pending++;
        } else if (st == 'approved' || st == 'active') {
          approved++;
        } else {
          inactive++;
        }
      }

      final recent = users.take(5).map((u) {
        final name = (u['full_name'] ?? u['name'] ?? u['email'] ?? 'Pengguna')
            .toString();
        final st = (u['status'] ?? 'pending').toString().toLowerCase();
        final createdAt = (u['created_at'] ?? '').toString();

        _ActivityType type = _ActivityType.pending;
        String action = 'Menunggu persetujuan admin';
        if (st == 'approved' || st == 'active') {
          type = _ActivityType.active;
          action = 'Akun aktif / disetujui';
        } else if (st == 'suspended' || st == 'rejected') {
          type = _ActivityType.inactive;
          action = 'Akun dinonaktifkan';
        }

        return _ActivityItem(
          initials: _getInitials(name),
          name: name,
          action: action,
          time: createdAt.isNotEmpty ? createdAt.split('T').first : 'Baru',
          type: type,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _totalUsers = users.length;
        _pendingUsers = pending;
        _activeUsers = approved;
        _inactiveUsers = inactive;
        _activities = recent;
        _isLoadingStats = false;
      });
      _counterCtrl.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingStats = false);
      _counterCtrl.forward(from: 0);
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _onDashboardScroll() {
    final collapsed = _dashboardScrollCtrl.hasClients &&
        _dashboardScrollCtrl.offset > 100;
    if (collapsed != _isHeaderCollapsed) {
      setState(() => _isHeaderCollapsed = collapsed);
    }
  }

  @override
  void dispose() {
    _dashboardScrollCtrl.removeListener(_onDashboardScroll);
    _dashboardScrollCtrl.dispose();
    _counterCtrl.dispose();
    _tabAnimCtrl.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_currentTab == index) return;
    HapticFeedback.selectionClick();
    if (index == 0) {
      _loadDashboardData();
    }
    _tabAnimCtrl.reverse().then((_) {
      if (!mounted) return;
      setState(() => _currentTab = index);
      _tabAnimCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F5),
        body: FadeTransition(
          opacity: _tabAnim,
          child: IndexedStack(
            index: _currentTab,
            children: [
              _buildDashboard(),
              const AdminUserListScreen(isEmbedded: true),
              const AdminApprovalScreen(isEmbedded: true),
              const AdminNotificationScreen(isEmbedded: true),
              _buildSettings(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      color: const Color(0xFF15A147),
      onRefresh: _loadDashboardData,
      child: CustomScrollView(
        controller: _dashboardScrollCtrl,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
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
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selamat datang,',
                                        style: GoogleFonts.instrumentSans(
                                          fontSize: 12,
                                          color: Colors.white
                                              .withValues(alpha: 0.75),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            'Admin Super',
                                            style: GoogleFonts.instrumentSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            '👋',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _loadDashboardData,
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.15),
                                    ),
                                    child: const Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _switchTab(3),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                        ),
                                        child: const Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      if (_pendingUsers > 0)
                                        Positioned(
                                          top: 6,
                                          right: 6,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFFF4444),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Pengguna Terdaftar',
                                          style: GoogleFonts.instrumentSans(
                                            fontSize: 12,
                                            color: Colors.white
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        AnimatedBuilder(
                                          animation: _counterAnim,
                                          builder: (_, __) => Text(
                                            _formatNumber((_totalUsers *
                                                    _counterAnim.value)
                                                .round()),
                                            style: GoogleFonts.instrumentSans(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Database AWS RDS',
                                          style: GoogleFonts.instrumentSans(
                                            fontSize: 11,
                                            color: Colors.white
                                                .withValues(alpha: 0.65),
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
                                      'LIVE',
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
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHeaderCollapsed ? 1.0 : 0.0,
              child: Text(
                'Admin Dashboard',
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            backgroundColor: const Color(0xFF257029),
          ),

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
                            onTap: () => _switchTab(2),
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
                            onTap: () => _switchTab(1),
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
                            onTap: () => _switchTab(1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 340),
                          child: _StatCard(
                            label: 'Total Akun',
                            value: _totalUsers,
                            counterAnim: _counterAnim,
                            icon: Icons.people_alt_rounded,
                            iconBg: const Color(0xFFE3EDFF),
                            iconColor: const Color(0xFF3A82F7),
                            valueColor: const Color(0xFF3A82F7),
                            onTap: () => _switchTab(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  StaggeredFadeSlide(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'Aksi Cepat',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  StaggeredFadeSlide(
                    delay: const Duration(milliseconds: 460),
                    child: Row(
                      children: [
                        _QuickAction(
                          label: 'Pengguna',
                          icon: Icons.people_rounded,
                          color: const Color(0xFF15A147),
                          onTap: () => _switchTab(1),
                        ),
                        const SizedBox(width: 10),
                        _QuickAction(
                          label: 'Approval',
                          icon: Icons.check_circle_rounded,
                          color: const Color(0xFFFF9119),
                          onTap: () => _switchTab(2),
                        ),
                        const SizedBox(width: 10),
                        _QuickAction(
                          label: 'Notifikasi',
                          icon: Icons.notifications_rounded,
                          color: const Color(0xFF3A82F7),
                          onTap: () => _switchTab(3),
                        ),
                        const SizedBox(width: 10),
                        _QuickAction(
                          label: 'Pengaturan',
                          icon: Icons.settings_rounded,
                          color: const Color(0xFF9E9E9E),
                          onTap: () => _switchTab(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pengguna Terbaru',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _switchTab(1),
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

          if (_isLoadingStats)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF15A147)),
                ),
              ),
            )
          else if (_activities.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      'Belum ada pengguna terdaftar di database.',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 13,
                        color: const Color(0xFF808080),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final act = _activities[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: StaggeredFadeSlide(
                      delay: Duration(milliseconds: 500 + i * 80),
                      child: _ActivityCard(item: act),
                    ),
                  );
                },
                childCount: _activities.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF257029),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(
            'Profil & Pengaturan',
            style: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
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
            ),
          ),
          expandedHeight: 0,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 12,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF15A147), Color(0xFF257029)],
                          ),
                          border: Border.all(
                              color: const Color(0xFFE8F8EE), width: 4),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF15A147).withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.admin_panel_settings_rounded,
                              size: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Admin Go Finance',
                        style: GoogleFonts.instrumentSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 4),
                      Text(AwsConfig.primaryAdminEmail,
                          style: GoogleFonts.instrumentSans(
                              fontSize: 13,
                              color: const Color(0xFF808080))),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8EE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded,
                                size: 14, color: Color(0xFF15A147)),
                            const SizedBox(width: 6),
                            Text(
                              'Administrator',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF15A147),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionLabel(label: 'Akun'),
                const SizedBox(height: 10),
                ...[
                  (
                    'Edit Profil',
                    Icons.edit_rounded,
                    const Color(0xFF15A147),
                    const Color(0xFFE8F8EE)
                  ),
                  (
                    'Keamanan & Password',
                    Icons.lock_outline_rounded,
                    const Color(0xFF3A82F7),
                    const Color(0xFFE3EDFF)
                  ),
                  (
                    'Notifikasi',
                    Icons.notifications_outlined,
                    const Color(0xFFFF9119),
                    const Color(0xFFFFF3E0)
                  ),
                ].map(
                  (e) => _SettingTile(
                    label: e.$1,
                    icon: e.$2,
                    iconColor: e.$3,
                    iconBg: e.$4,
                  ),
                ),
                const SizedBox(height: 16),
                const _SectionLabel(label: 'Administrasi'),
                const SizedBox(height: 10),
                ...[
                  (
                    'Log Aktivitas',
                    Icons.history_rounded,
                    const Color(0xFF9E9E9E),
                    const Color(0xFFF0F0F0)
                  ),
                  (
                    'Kelola Admin',
                    Icons.manage_accounts_rounded,
                    const Color(0xFF9E9E9E),
                    const Color(0xFFF0F0F0)
                  ),
                  (
                    'Bantuan & Dukungan',
                    Icons.help_outline_rounded,
                    const Color(0xFF9E9E9E),
                    const Color(0xFFF0F0F0)
                  ),
                ].map(
                  (e) => _SettingTile(
                    label: e.$1,
                    icon: e.$2,
                    iconColor: e.$3,
                    iconBg: e.$4,
                  ),
                ),
                const SizedBox(height: 16),
                _SettingTile(
                  label: 'Keluar dari Admin',
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFE63939),
                  iconBg: const Color(0xFFFFEBEB),
                  isDestructive: true,
                  onTap: () => _confirmLogout(context),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      backgroundColor: Colors.white,
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFEBEB),
              ),
              child: const Icon(Icons.logout_rounded,
                  size: 36, color: Color(0xFFE63939)),
            ),
            const SizedBox(height: 16),
            Text(
              'Keluar dari Admin?',
              style: GoogleFonts.instrumentSans(
                  fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Sesi admin akan berakhir dan kamu\nharus login kembali.',
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                  fontSize: 14, color: const Color(0xFF808080)),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(sheetCtx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: Text('Batal',
                        style: GoogleFonts.instrumentSans(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF555555))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(sheetCtx);
                      await AwsAuthService.instance.signOut();
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (r) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE63939),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
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
      (Icons.check_circle_rounded, Icons.check_circle_outline_rounded,
          'Approval'),
      (Icons.notifications_rounded, Icons.notifications_outlined, 'Notifikasi'),
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
                  onTap: () => _switchTab(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE8F8EE)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            selected ? items[i].$1 : items[i].$2,
                            key: ValueKey(selected),
                            color: selected
                                ? const Color(0xFF15A147)
                                : const Color(0xFF9E9E9E),
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$3,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 9,
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

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.instrumentSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF555555),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.instrumentSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF9E9E9E),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Animation<double> counterAnim;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.counterAnim,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 36,
              height: 36,
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
      ),
    );
  }
}

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
          Container(
            width: 40,
            height: 40,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 8,
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

class _SettingTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          label,
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDestructive
                ? const Color(0xFFE63939)
                : const Color(0xFF1A1A1A),
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