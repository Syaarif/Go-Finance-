import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
import 'package:go_finance/screens/admin/admin_user_list_screen.dart';
import 'package:go_finance/screens/admin/admin_user_detail_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

class AdminNotificationScreen extends StatefulWidget {
  final bool isEmbedded;
  const AdminNotificationScreen({super.key, this.isEmbedded = false});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _emptyCtrl;
  late Animation<double> _emptyAnim;

  List<_Notif> _notifs = [];
  bool _isLoading = true;
  final Set<String> _readIds = {};
  final Set<String> _dismissedIds = {};

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _emptyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _emptyAnim =
        CurvedAnimation(parent: _emptyCtrl, curve: Curves.elasticOut);
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    try {
      final rawList = await AwsApiService.instance.getAdminUsers();
      if (!mounted) return;

      final users = rawList
          .map((e) => AdminUser.fromApi(Map<String, dynamic>.from(e)))
          .where((u) => u.email.toLowerCase() != 'admin@gofinance.id')
          .toList();

      final generated = <_Notif>[];
      for (final u in users) {
        final notifId = 'user_${u.id}_${u.status.name}';
        if (_dismissedIds.contains(notifId)) continue;

        if (u.status == AdminUserStatus.pending) {
          generated.add(
            _Notif(
              id: notifId,
              title: 'Akun Baru Menunggu',
              body: '${u.name} (${u.email}) mendaftar dan menunggu persetujuan.',
              time: u.joinDate,
              type: _NType.approval,
              isRead: _readIds.contains(notifId),
              user: u,
            ),
          );
        } else if (u.status == AdminUserStatus.inactive) {
          generated.add(
            _Notif(
              id: notifId,
              title: 'Akun Dinonaktifkan',
              body: '${u.name} berstatus nonaktif / ditolak.',
              time: u.joinDate,
              type: _NType.warning,
              isRead: _readIds.contains(notifId),
              user: u,
            ),
          );
        }
      }

      setState(() {
        _notifs = generated;
        _isLoading = false;
      });

      if (_notifs.isEmpty) {
        _emptyCtrl.forward(from: 0);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat notifikasi: $e'),
          backgroundColor: const Color(0xFFE63939),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emptyCtrl.dispose();
    super.dispose();
  }

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      for (final n in _notifs) {
        n.isRead = true;
        _readIds.add(n.id);
      }
    });
  }

  void _dismiss(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _dismissedIds.add(id);
      _notifs.removeWhere((n) => n.id == id);
    });
    if (_notifs.isEmpty) _emptyCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F5),
      body: RefreshIndicator(
        color: const Color(0xFF15A147),
        onRefresh: _fetchNotifications,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: !widget.isEmbedded,
              backgroundColor: const Color(0xFF257029),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leading: widget.isEmbedded
                  ? null
                  : IconButton(
                      icon: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
              title: Row(
                children: [
                  Text(
                    'Notifikasi',
                    style: GoogleFonts.instrumentSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  if (_unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9119),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '$_unreadCount',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (_unreadCount > 0)
                  TextButton(
                    onPressed: _markAllRead,
                    child: Text(
                      'Tandai Semua Dibaca',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: _fetchNotifications,
                ),
              ],
            ),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF15A147)),
                ),
              )
            else if (_notifs.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ScaleTransition(
                  scale: _emptyAnim,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8F8EE),
                          ),
                          child: const Icon(
                            Icons.notifications_off_outlined,
                            size: 44,
                            color: Color(0xFF15A147),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Tidak Ada Notifikasi',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Semua notifikasi sudah bersih.',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final notif = _notifs[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: StaggeredFadeSlide(
                        delay: Duration(milliseconds: 60 * i),
                        child: Dismissible(
                          key: Key(notif.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _dismiss(notif.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE63939),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          child: _NotifCard(
                            notif: notif,
                            onTap: () async {
                              setState(() {
                                notif.isRead = true;
                                _readIds.add(notif.id);
                              });
                              if (notif.user != null) {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AdminUserDetailScreen(
                                      user: notif.user!,
                                    ),
                                  ),
                                );
                                _fetchNotifications();
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _notifs.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

enum _NType { approval, warning }

class _Notif {
  final String id;
  final String title;
  final String body;
  final String time;
  final _NType type;
  final AdminUser? user;
  bool isRead;

  _Notif({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    required this.isRead,
    this.user,
  });
}

class _NotifCard extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onTap;

  const _NotifCard({required this.notif, required this.onTap});

  IconData get _icon {
    switch (notif.type) {
      case _NType.approval:
        return Icons.person_add_rounded;
      case _NType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  Color get _color {
    switch (notif.type) {
      case _NType.approval:
        return const Color(0xFFFF9119);
      case _NType.warning:
        return const Color(0xFFE63939);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : const Color(0xFFF0FAF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.isRead
                ? Colors.transparent
                : const Color(0xFF15A147).withValues(alpha: 0.2),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _color.withValues(alpha: 0.12),
              ),
              child: Icon(_icon, size: 22, color: _color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            fontWeight: notif.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF15A147),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12,
                      color: const Color(0xFF808080),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.time,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 11,
                      color: const Color(0xFFAAAAAA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}