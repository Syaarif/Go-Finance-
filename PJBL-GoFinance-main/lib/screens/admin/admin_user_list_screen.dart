import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/admin/admin_user_detail_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

// ─── Model ───
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final AdminUserStatus status;
  final String joinDate;
  final String totalIncome;
  final String totalExpense;
  final String savings;
  final int totalTx;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.status,
    required this.joinDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.savings,
    required this.totalTx,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}

enum AdminUserStatus { active, pending, inactive }

extension AdminUserStatusExt on AdminUserStatus {
  String get label {
    switch (this) {
      case AdminUserStatus.active:
        return 'Aktif';
      case AdminUserStatus.pending:
        return 'Review';
      case AdminUserStatus.inactive:
        return 'Nonaktif';
    }
  }

  Color get color {
    switch (this) {
      case AdminUserStatus.active:
        return const Color(0xFF15A147);
      case AdminUserStatus.pending:
        return const Color(0xFFFF9119);
      case AdminUserStatus.inactive:
        return const Color(0xFFE63939);
    }
  }

  Color get bg {
    switch (this) {
      case AdminUserStatus.active:
        return const Color(0xFFE8F8EE);
      case AdminUserStatus.pending:
        return const Color(0xFFFFF3E0);
      case AdminUserStatus.inactive:
        return const Color(0xFFFFEBEB);
    }
  }
}

/// 07_Daftar_Pengguna — Layar manajemen pengguna
class AdminUserListScreen extends StatefulWidget {
  final bool isEmbedded;

  const AdminUserListScreen({super.key, this.isEmbedded = false});

  @override
  State<AdminUserListScreen> createState() => _AdminUserListScreenState();
}

class _AdminUserListScreenState extends State<AdminUserListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  static const _dummyUsers = [
    AdminUser(
      id: '001',
      name: 'Budi Santoso',
      email: 'budi.santoso@email.com',
      phone: '+62 812 3456 7890',
      city: 'Jakarta Selatan',
      status: AdminUserStatus.pending,
      joinDate: '14 Nov 2026',
      totalIncome: 'Rp 12.5 jt',
      totalExpense: 'Rp 8.2 jt',
      savings: 'Rp 4.3 jt',
      totalTx: 47,
    ),
    AdminUser(
      id: '002',
      name: 'Siti Rahma',
      email: 'siti.rahma@email.com',
      phone: '+62 821 9876 5432',
      city: 'Bandung',
      status: AdminUserStatus.active,
      joinDate: '10 Okt 2026',
      totalIncome: 'Rp 8.0 jt',
      totalExpense: 'Rp 5.5 jt',
      savings: 'Rp 2.5 jt',
      totalTx: 33,
    ),
    AdminUser(
      id: '003',
      name: 'Ahmad Fauzi',
      email: 'a.fauzi@email.com',
      phone: '+62 831 1122 3344',
      city: 'Surabaya',
      status: AdminUserStatus.active,
      joinDate: '05 Sep 2026',
      totalIncome: 'Rp 15.0 jt',
      totalExpense: 'Rp 10.0 jt',
      savings: 'Rp 5.0 jt',
      totalTx: 89,
    ),
    AdminUser(
      id: '004',
      name: 'Dewi Purnama',
      email: 'dewi.purnama@email.com',
      phone: '+62 858 5566 7788',
      city: 'Medan',
      status: AdminUserStatus.inactive,
      joinDate: '20 Agu 2026',
      totalIncome: 'Rp 4.0 jt',
      totalExpense: 'Rp 3.5 jt',
      savings: 'Rp 0.5 jt',
      totalTx: 12,
    ),
    AdminUser(
      id: '005',
      name: 'Rizky Pratama',
      email: 'rizky.pratama@email.com',
      phone: '+62 877 2233 4455',
      city: 'Yogyakarta',
      status: AdminUserStatus.pending,
      joinDate: '17 Nov 2026',
      totalIncome: 'Rp 0',
      totalExpense: 'Rp 0',
      savings: 'Rp 0',
      totalTx: 0,
    ),
    AdminUser(
      id: '006',
      name: 'Linda Sari',
      email: 'linda.sari@email.com',
      phone: '+62 896 6677 8899',
      city: 'Makassar',
      status: AdminUserStatus.active,
      joinDate: '01 Nov 2026',
      totalIncome: 'Rp 7.5 jt',
      totalExpense: 'Rp 4.0 jt',
      savings: 'Rp 3.5 jt',
      totalTx: 28,
    ),
    AdminUser(
      id: '007',
      name: 'Eko Wahyudi',
      email: 'eko.wahyudi@email.com',
      phone: '+62 812 0011 2233',
      city: 'Semarang',
      status: AdminUserStatus.inactive,
      joinDate: '15 Jul 2026',
      totalIncome: 'Rp 6.0 jt',
      totalExpense: 'Rp 7.0 jt',
      savings: '-Rp 1.0 jt',
      totalTx: 55,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _searchCtrl.addListener(
        () => setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AdminUser> get _filtered {
    final tab = _tabCtrl.index;
    var list = _dummyUsers.where((u) {
      if (_searchQuery.isNotEmpty) {
        return u.name.toLowerCase().contains(_searchQuery) ||
            u.email.toLowerCase().contains(_searchQuery);
      }
      return true;
    }).toList();

    if (tab == 1) list = list.where((u) => u.status == AdminUserStatus.active).toList();
    if (tab == 2) list = list.where((u) => u.status == AdminUserStatus.pending).toList();
    if (tab == 3) list = list.where((u) => u.status == AdminUserStatus.inactive).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F5),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: !widget.isEmbedded,
            backgroundColor: const Color(0xFF257029),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text(
              'Daftar Pengguna',
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(104),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x18000000),
                              blurRadius: 8,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        style: GoogleFonts.instrumentSans(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Cari pengguna...',
                          hintStyle: GoogleFonts.instrumentSans(
                            color: const Color(0xFFAAAAAA), fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: Color(0xFF9E9E9E), size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 18, color: Color(0xFF9E9E9E)),
                                  onPressed: () => _searchCtrl.clear(),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  // Tab filter
                  TabBar(
                    controller: _tabCtrl,
                    onTap: (_) => setState(() {}),
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.55),
                    labelStyle: GoogleFonts.instrumentSans(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        GoogleFonts.instrumentSans(fontSize: 13),
                    tabs: const [
                      Tab(text: 'Semua'),
                      Tab(text: 'Aktif'),
                      Tab(text: 'Review'),
                      Tab(text: 'Nonaktif'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: List.generate(4, (_) => _buildUserList()),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    final users = _filtered;
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 64, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 12),
            Text('Tidak ada pengguna ditemukan',
                style: GoogleFonts.instrumentSans(
                    fontSize: 15, color: const Color(0xFF9E9E9E))),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: users.length,
      itemBuilder: (ctx, i) {
        final user = users[i];
        return StaggeredFadeSlide(
          delay: Duration(milliseconds: 60 * i),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _UserCard(
              user: user,
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, anim, __) =>
                        AdminUserDetailScreen(user: user),
                    transitionsBuilder: (_, anim, __, child) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOutCubic)),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 380),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ───────── User Card ─────────
class _UserCard extends StatelessWidget {
  final AdminUser user;
  final VoidCallback onTap;

  const _UserCard({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: user.status.bg,
              ),
              child: Center(
                child: Text(
                  user.initials,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: user.status.color,
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
                    user.name,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 11,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            // Badge + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: user.status.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user.status.label,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: user.status.color,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFCCCCCC), size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
