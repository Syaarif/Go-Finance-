import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
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

  factory AdminUser.fromApi(Map<String, dynamic> map) {
    final rawStatus = (map['status'] ?? 'pending').toString().toLowerCase();
    final parsedStatus = rawStatus == 'active'
        ? AdminUserStatus.active
        : (rawStatus == 'suspended' || rawStatus == 'inactive')
            ? AdminUserStatus.inactive
            : AdminUserStatus.pending;

    final email = (map['email'] ?? '').toString();
    final rawName = (map['full_name'] ?? '').toString().trim();
    final displayName =
        rawName.isNotEmpty ? rawName : (email.contains('@') ? email.split('@').first : 'User');

    return AdminUser(
      id: (map['id'] ?? '').toString(),
      name: displayName,
      email: email,
      phone: (map['phone'] ?? '-').toString(),
      city: (map['city'] ?? 'Indonesia').toString(),
      status: parsedStatus,
      joinDate: (map['created_at'] ?? '-').toString().split('T').first,
      totalIncome: 'Rp 0',
      totalExpense: 'Rp 0',
      savings: 'Rp 0',
      totalTx: (map['total_tx'] as num?)?.toInt() ?? 0,
    );
  }

  String get initials {
    final clean = name.trim();
    if (clean.isEmpty) return 'US';
    final parts = clean.split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return clean.length >= 2
        ? clean.substring(0, 2).toUpperCase()
        : clean.toUpperCase();
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

/// 07_Daftar_Pengguna — Layar manajemen pengguna (terhubung ke AWS RDS)
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

  List<AdminUser> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        setState(() {});
      }
    });
    _searchCtrl.addListener(
        () => setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase()));
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final rawList = await AwsApiService.instance.getAdminUsers();
      if (!mounted) return;
      setState(() {
        _users = rawList
            .map((e) => AdminUser.fromApi(Map<String, dynamic>.from(e)))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat daftar pengguna: $e'),
          backgroundColor: const Color(0xFFE63939),
        ),
      );
    }
  }

  Future<void> _quickStatusAction(AdminUser user, String action) async {
    try {
      await AwsApiService.instance.adminUserAction(
        targetUserId: user.id,
        targetEmail: user.email,
        action: action,
      );
      await _fetchUsers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status ${user.name} berhasil diperbarui ($action).'),
          backgroundColor: const Color(0xFF15A147),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aksi gagal: $e'),
          backgroundColor: const Color(0xFFE63939),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AdminUser> _getFiltered(int tabIndex) {
    var list = _users.where((u) {
      if (_searchQuery.isNotEmpty) {
        return u.name.toLowerCase().contains(_searchQuery) ||
            u.email.toLowerCase().contains(_searchQuery) ||
            u.city.toLowerCase().contains(_searchQuery);
      }
      return true;
    }).toList();

    if (tabIndex == 1) {
      list = list.where((u) => u.status == AdminUserStatus.active).toList();
    } else if (tabIndex == 2) {
      list = list.where((u) => u.status == AdminUserStatus.pending).toList();
    } else if (tabIndex == 3) {
      list = list.where((u) => u.status == AdminUserStatus.inactive).toList();
    }
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: _fetchUsers,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(104),
              child: Column(
                children: [
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
                          hintText: 'Cari nama, email, kota...',
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
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabCtrl,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        Colors.white.withValues(alpha: 0.55),
                    labelStyle: GoogleFonts.instrumentSans(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        GoogleFonts.instrumentSans(fontSize: 13),
                    tabs: [
                      Tab(text: 'Semua (${_getFiltered(0).length})'),
                      Tab(text: 'Aktif (${_getFiltered(1).length})'),
                      Tab(text: 'Review (${_getFiltered(2).length})'),
                      Tab(text: 'Nonaktif (${_getFiltered(3).length})'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF15A147)),
              )
            : TabBarView(
                controller: _tabCtrl,
                children: List.generate(
                  4,
                  (tabIndex) => RefreshIndicator(
                    onRefresh: _fetchUsers,
                    color: const Color(0xFF15A147),
                    child: _UserListView(
                      users: _getFiltered(tabIndex),
                      onQuickAction: _quickStatusAction,
                      onTap: (user) async {
                        HapticFeedback.selectionClick();
                        await Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, anim, __) =>
                                AdminUserDetailScreen(user: user),
                            transitionsBuilder: (_, anim, __, child) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                  parent: anim, curve: Curves.easeOutCubic)),
                              child: child,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 380),
                          ),
                        );
                        _fetchUsers();
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _UserListView extends StatelessWidget {
  final List<AdminUser> users;
  final void Function(AdminUser) onTap;
  final Future<void> Function(AdminUser, String) onQuickAction;

  const _UserListView({
    required this.users,
    required this.onTap,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.search_off_rounded,
              size: 64, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Tidak ada pengguna ditemukan',
              style: GoogleFonts.instrumentSans(
                  fontSize: 15, color: const Color(0xFF9E9E9E)),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
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
              onTap: () => onTap(user),
              onQuickAction: (act) => onQuickAction(user, act),
            ),
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final AdminUser user;
  final VoidCallback onTap;
  final void Function(String) onQuickAction;

  const _UserCard({
    required this.user,
    required this.onTap,
    required this.onQuickAction,
  });

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
            Hero(
              tag: 'avatar_${user.id}',
              child: Container(
                width: 46,
                height: 46,
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
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 11, color: Color(0xFFBBBBBB)),
                      const SizedBox(width: 4),
                      Text(
                        user.joinDate,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 11,
                          color: const Color(0xFFBBBBBB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                const SizedBox(height: 4),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_horiz_rounded,
                      color: Color(0xFF9E9E9E), size: 20),
                  onSelected: onQuickAction,
                  itemBuilder: (_) => [
                    if (user.status != AdminUserStatus.active)
                      const PopupMenuItem(
                        value: 'accept',
                        child: Text('Aktifkan Akun'),
                      ),
                    if (user.status == AdminUserStatus.active)
                      const PopupMenuItem(
                        value: 'suspend',
                        child: Text('Nonaktifkan (Spam)'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Hapus Permanen',
                        style: TextStyle(color: Color(0xFFE63939)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}