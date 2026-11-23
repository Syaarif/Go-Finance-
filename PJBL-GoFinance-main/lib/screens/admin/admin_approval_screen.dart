import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/core/services/aws_api_service.dart';
import 'package:go_finance/screens/admin/admin_user_list_screen.dart';
import 'package:go_finance/screens/admin/admin_user_detail_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

class AdminApprovalScreen extends StatefulWidget {
  final bool isEmbedded;

  const AdminApprovalScreen({super.key, this.isEmbedded = false});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _emptyCtrl;
  late Animation<double> _emptyAnim;

  List<AdminUser> _queue = [];
  bool _isLoading = true;
  int _approvedCount = 0;
  int _rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _emptyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _emptyAnim = CurvedAnimation(parent: _emptyCtrl, curve: Curves.elasticOut);
    _fetchPendingUsers();
  }

  Future<void> _fetchPendingUsers() async {
    setState(() => _isLoading = true);
    try {
      final rawList = await AwsApiService.instance.getAdminUsers();
      if (!mounted) return;
      final pending = rawList
          .map((e) => AdminUser.fromApi(Map<String, dynamic>.from(e)))
          .where((u) =>
              u.status == AdminUserStatus.pending &&
              u.email.toLowerCase() != 'admin@gofinance.id')
          .toList();

      setState(() {
        _queue = pending;
        _isLoading = false;
      });

      if (_queue.isEmpty) {
        _emptyCtrl.forward(from: 0);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat antrian approval: $e'),
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

  Future<void> _approve(AdminUser u) async {
    HapticFeedback.heavyImpact();
    try {
      await AwsApiService.instance.adminUserAction(
        targetUserId: u.id,
        targetEmail: u.email,
        action: 'accept',
      );
      if (!mounted) return;
      setState(() {
        _queue.removeWhere((item) => item.id == u.id);
        _approvedCount++;
      });
      _checkEmpty();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                '${u.name} disetujui',
                style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF15A147),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyetujui ${u.name}: $e'),
          backgroundColor: const Color(0xFFE63939),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _reject(AdminUser u) async {
    HapticFeedback.vibrate();
    try {
      await AwsApiService.instance.adminUserAction(
        targetUserId: u.id,
        targetEmail: u.email,
        action: 'reject',
      );
      if (!mounted) return;
      setState(() {
        _queue.removeWhere((item) => item.id == u.id);
        _rejectedCount++;
      });
      _checkEmpty();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                '${u.name} ditolak',
                style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFE63939),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menolak ${u.name}: $e'),
          backgroundColor: const Color(0xFFE63939),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _checkEmpty() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted && _queue.isEmpty) {
        _emptyCtrl.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F5),
      body: RefreshIndicator(
        color: const Color(0xFF15A147),
        onRefresh: _fetchPendingUsers,
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: _fetchPendingUsers,
                ),
              ],
              title: Row(
                children: [
                  Text(
                    'Persetujuan Akun',
                    style: GoogleFonts.instrumentSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  if (_queue.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9119),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '${_queue.length}',
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
            ),
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xFF257029),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    _SummaryChip(
                      label: 'Menunggu',
                      count: _queue.length,
                      color: const Color(0xFFFFDD88),
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Disetujui',
                      count: _approvedCount,
                      color: const Color(0xFF4ADE80),
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      label: 'Ditolak',
                      count: _rejectedCount,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF15A147)),
                ),
              )
            else if (_queue.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: ScaleTransition(
                    scale: _emptyAnim,
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
                          child: const Icon(Icons.check_circle_rounded,
                              size: 50, color: Color(0xFF15A147)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Semua Sudah Ditinjau!',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada akun yang menunggu persetujuan.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 14,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_approvedCount > 0 || _rejectedCount > 0)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ResultStat(
                                  count: _approvedCount,
                                  label: 'Disetujui',
                                  color: const Color(0xFF15A147),
                                ),
                                Container(
                                  width: 1,
                                  height: 36,
                                  color: const Color(0xFFF0F0F0),
                                ),
                                _ResultStat(
                                  count: _rejectedCount,
                                  label: 'Ditolak',
                                  color: const Color(0xFFE63939),
                                ),
                              ],
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
                    final user = _queue[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: StaggeredFadeSlide(
                        delay: Duration(milliseconds: 60 * i),
                        child: Dismissible(
                          key: Key('approval_${user.id}_${user.email}'),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF15A147),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.white, size: 28),
                                const SizedBox(height: 4),
                                Text(
                                  'Setujui',
                                  style: GoogleFonts.instrumentSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE63939),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cancel_rounded,
                                    color: Colors.white, size: 28),
                                const SizedBox(height: 4),
                                Text(
                                  'Tolak',
                                  style: GoogleFonts.instrumentSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await _approve(user);
                            } else {
                              await _reject(user);
                            }
                            return false;
                          },
                          child: _ApprovalCard(
                            user: user,
                            onApprove: () => _approve(user),
                            onReject: () => _reject(user),
                            onDetail: () async {
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
                                        parent: anim,
                                        curve: Curves.easeOutCubic)),
                                    child: child,
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 380),
                                ),
                              );
                              _fetchPendingUsers();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _queue.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _ResultStat({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.instrumentSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.instrumentSans(
            fontSize: 12,
            color: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: GoogleFonts.instrumentSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final AdminUser user;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onDetail;

  const _ApprovalCard({
    required this.user,
    required this.onApprove,
    required this.onReject,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar_approval_${user.id}',
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFF3E0),
                    ),
                    child: Center(
                      child: Text(
                        user.initials,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF9119),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        user.email,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 12,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDetail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Detail',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 14, color: Color(0xFFAAAAAA)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Daftar: ${user.joinDate}',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Color(0xFFAAAAAA)),
                const SizedBox(width: 4),
                Text(
                  user.city,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              '← Swipe untuk Tolak / Setujui Swipe →',
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                fontSize: 11,
                color: const Color(0xFFCCCCCC),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_circle_rounded,
                        size: 16, color: Colors.white),
                    label: Text(
                      'Setujui',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15A147),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.cancel_rounded,
                        size: 16, color: Color(0xFFE63939)),
                    label: Text(
                      'Tolak',
                      style: GoogleFonts.instrumentSans(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE63939),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFFE63939), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}