import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/admin/admin_user_list_screen.dart';
import 'package:go_finance/screens/admin/admin_user_detail_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

/// 04_Persetujuan_Akun — Halaman antrian approval pengguna baru
class AdminApprovalScreen extends StatefulWidget {
  final bool isEmbedded;

  const AdminApprovalScreen({super.key, this.isEmbedded = false});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  final _pendingUsers = [
    const AdminUser(
      id: '005',
      name: 'Rizky Pratama',
      email: 'rizky.pratama@email.com',
      phone: '+62 877 2233 4455',
      city: 'Yogyakarta',
      status: AdminUserStatus.pending,
      joinDate: '17 Nov 2026, 20:30',
      totalIncome: 'Rp 0',
      totalExpense: 'Rp 0',
      savings: 'Rp 0',
      totalTx: 0,
    ),
    const AdminUser(
      id: '001',
      name: 'Budi Santoso',
      email: 'budi.santoso@email.com',
      phone: '+62 812 3456 7890',
      city: 'Jakarta Selatan',
      status: AdminUserStatus.pending,
      joinDate: '17 Nov 2026, 19:15',
      totalIncome: 'Rp 0',
      totalExpense: 'Rp 0',
      savings: 'Rp 0',
      totalTx: 0,
    ),
    const AdminUser(
      id: '008',
      name: 'Maya Anggraini',
      email: 'maya.a@email.com',
      phone: '+62 812 9988 7766',
      city: 'Palembang',
      status: AdminUserStatus.pending,
      joinDate: '17 Nov 2026, 15:40',
      totalIncome: 'Rp 0',
      totalExpense: 'Rp 0',
      savings: 'Rp 0',
      totalTx: 0,
    ),
  ];

  final Set<String> _approvedIds = {};
  final Set<String> _rejectedIds = {};

  List<AdminUser> get _queue => _pendingUsers
      .where((u) =>
          !_approvedIds.contains(u.id) && !_rejectedIds.contains(u.id))
      .toList();

  void _approve(AdminUser u) {
    HapticFeedback.heavyImpact();
    setState(() => _approvedIds.add(u.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${u.name} disetujui ✓',
          style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF15A147),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _reject(AdminUser u) {
    HapticFeedback.vibrate();
    setState(() => _rejectedIds.add(u.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${u.name} ditolak',
          style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFFE63939),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: !widget.isEmbedded,
            backgroundColor: const Color(0xFF257029),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text(
              'Persetujuan Akun',
              style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18),
            ),
            actions: [
              if (_queue.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9119),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_queue.length}',
                    style: GoogleFonts.instrumentSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
            ],
          ),

          // Summary strip
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF257029),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _SummaryChip(
                    label: 'Menunggu',
                    count: _queue.length,
                    color: const Color(0xFFFF9119),
                  ),
                  const SizedBox(width: 10),
                  _SummaryChip(
                    label: 'Disetujui',
                    count: _approvedIds.length,
                    color: const Color(0xFF4ADE80),
                  ),
                  const SizedBox(width: 10),
                  _SummaryChip(
                    label: 'Ditolak',
                    count: _rejectedIds.length,
                    color: const Color(0xFFFF6B6B),
                  ),
                ],
              ),
            ),
          ),

          // List
          if (_queue.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 72, color: Color(0xFF15A147)),
                    const SizedBox(height: 16),
                    Text(
                      'Semua Sudah Ditinjau! 🎉',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tidak ada akun yang menunggu persetujuan.',
                      style: GoogleFonts.instrumentSans(
                          fontSize: 14, color: const Color(0xFF9E9E9E)),
                    ),
                  ],
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
                      child: _ApprovalCard(
                        user: user,
                        onApprove: () => _approve(user),
                        onReject: () => _reject(user),
                        onDetail: () {
                          Navigator.of(context).push(
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
                        },
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
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip(
      {required this.label, required this.count, required this.color});

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
            width: 8, height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: GoogleFonts.instrumentSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white),
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
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF3E0),
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: GoogleFonts.instrumentSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF9119)),
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
                            fontSize: 12, color: const Color(0xFF9E9E9E)),
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
                          color: const Color(0xFF555555)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info rows
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 14, color: Color(0xFFAAAAAA)),
                const SizedBox(width: 6),
                Text(
                  'Daftar: ${user.joinDate}',
                  style: GoogleFonts.instrumentSans(
                      fontSize: 12, color: const Color(0xFF9E9E9E)),
                ),
                const Spacer(),
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Color(0xFFAAAAAA)),
                const SizedBox(width: 4),
                Text(
                  user.city,
                  style: GoogleFonts.instrumentSans(
                      fontSize: 12, color: const Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),

          // Tombol
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
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15A147),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                          color: const Color(0xFFE63939)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFFE63939), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
