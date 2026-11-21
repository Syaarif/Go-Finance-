import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_finance/screens/admin/admin_user_list_screen.dart';
import 'package:go_finance/widgets/staggered_fade_slide.dart';

/// 11_Detail_Pengguna — Detail & aksi admin terhadap pengguna
class AdminUserDetailScreen extends StatefulWidget {
  final AdminUser user;

  const AdminUserDetailScreen({super.key, required this.user});

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen>
    with TickerProviderStateMixin {
  late AdminUserStatus _currentStatus;

  late AnimationController _entranceCtrl;
  late Animation<double> _entranceAnim;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.user.status;

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceAnim =
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _showActionSheet(
    String title,
    String message,
    Color color,
    IconData icon,
    AdminUserStatus? newStatus, {
    bool isDelete = false,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      backgroundColor: Colors.white,
      builder: (_) => Padding(
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
                  borderRadius: BorderRadius.circular(3)),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12)),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.instrumentSans(
                  fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                  fontSize: 14, color: const Color(0xFF808080), height: 1.5),
            ),
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
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.instrumentSans(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF555555)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      HapticFeedback.heavyImpact();
                      if (isDelete) {
                        // Pop kembali ke list
                        Navigator.pop(context);
                        return;
                      }
                      if (newStatus != null) {
                        setState(() => _currentStatus = newStatus);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isDelete
                                ? 'Akun dihapus permanen'
                                : 'Status pengguna diperbarui',
                            style: GoogleFonts.instrumentSans(
                                fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: color,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Konfirmasi',
                      style: GoogleFonts.instrumentSans(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F5),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── SliverAppBar dengan hero avatar ──
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: const Color(0xFF257029),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leading: IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Detail Pengguna',
                style: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18),
              ),
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
                      // Dekorasi lingkaran
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ── Avatar (Hero) ──
                            Hero(
                              tag: 'avatar_${user.id}',
                              child: ScaleTransition(
                                scale: _entranceAnim,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFE8F8EE),
                                    border:
                                        Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.2),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.initials,
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF15A147),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Status badge
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              decoration: BoxDecoration(
                                color:
                                    _currentStatus.color.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: _currentStatus.color
                                        .withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                _currentStatus.label,
                                style: GoogleFonts.instrumentSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _currentStatus ==
                                          AdminUserStatus.active
                                      ? const Color(0xFFAAFFBB)
                                      : _currentStatus ==
                                              AdminUserStatus.pending
                                          ? const Color(0xFFFFDD88)
                                          : const Color(0xFFFFAAAA),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Konten ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Nama + email
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 80),
                      child: Column(
                        children: [
                          Text(
                            user.name,
                            style: GoogleFonts.instrumentSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: GoogleFonts.instrumentSans(
                              fontSize: 13,
                              color: const Color(0xFF808080),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Info Card ──
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 160),
                      child: _InfoCard(
                        rows: [
                          ('Tanggal Daftar', user.joinDate),
                          ('No. Telepon', user.phone),
                          ('Kota', user.city),
                          ('Total Transaksi', '${user.totalTx} transaksi'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Mini stat cards ──
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 240),
                      child: Row(
                        children: [
                          Expanded(
                            child: _MiniStatCard(
                              label: 'Pemasukan',
                              value: user.totalIncome,
                              color: const Color(0xFF15A147),
                              bg: const Color(0xFFE8F8EE),
                              icon: Icons.trending_up_rounded,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MiniStatCard(
                              label: 'Pengeluaran',
                              value: user.totalExpense,
                              color: const Color(0xFFE63939),
                              bg: const Color(0xFFFFEBEB),
                              icon: Icons.trending_down_rounded,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MiniStatCard(
                              label: 'Tabungan',
                              value: user.savings,
                              color: const Color(0xFF3A82F7),
                              bg: const Color(0xFFE3EDFF),
                              icon: Icons.savings_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Tombol aksi ──
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 320),
                      child: _buildActionButtons(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Setujui & Tolak (hanya jika pending)
        if (_currentStatus == AdminUserStatus.pending) ...[
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Setujui Akun',
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF15A147),
                  onTap: () => _showActionSheet(
                    'Setujui Akun?',
                    'Pengguna ${widget.user.name} akan diaktifkan\ndan bisa menggunakan Go Finance.',
                    const Color(0xFF15A147),
                    Icons.check_circle_rounded,
                    AdminUserStatus.active,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Tolak',
                  icon: Icons.cancel_rounded,
                  color: const Color(0xFFE63939),
                  outlined: true,
                  onTap: () => _showActionSheet(
                    'Tolak Akun?',
                    'Pengguna tidak akan bisa masuk\nke Go Finance.',
                    const Color(0xFFE63939),
                    Icons.cancel_rounded,
                    AdminUserStatus.inactive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Aktifkan (jika nonaktif)
        if (_currentStatus == AdminUserStatus.inactive) ...[
          _ActionButton(
            label: 'Aktifkan Kembali',
            icon: Icons.person_add_rounded,
            color: const Color(0xFF15A147),
            fullWidth: true,
            onTap: () => _showActionSheet(
              'Aktifkan Akun?',
              'Pengguna akan bisa masuk kembali\nke Go Finance.',
              const Color(0xFF15A147),
              Icons.person_add_rounded,
              AdminUserStatus.active,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Nonaktifkan (jika aktif)
        if (_currentStatus == AdminUserStatus.active) ...[
          _ActionButton(
            label: 'Nonaktifkan Akun',
            icon: Icons.block_rounded,
            color: const Color(0xFF9E9E9E),
            outlined: true,
            fullWidth: true,
            onTap: () => _showActionSheet(
              'Nonaktifkan Akun?',
              'Pengguna tidak akan bisa mengakses\nGo Finance untuk sementara.',
              const Color(0xFF9E9E9E),
              Icons.block_rounded,
              AdminUserStatus.inactive,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Hapus akun (selalu tampil)
        _ActionButton(
          label: 'Hapus Akun Permanen',
          icon: Icons.delete_forever_rounded,
          color: const Color(0xFFE63939),
          outlined: true,
          fullWidth: true,
          onTap: () => _showActionSheet(
            'Hapus Akun?',
            'Tindakan ini tidak dapat dibatalkan.\nSemua data pengguna akan dihapus selamanya.',
            const Color(0xFFE63939),
            Icons.delete_forever_rounded,
            null,
            isDelete: true,
          ),
        ),
      ],
    );
  }
}

// ───────── Info Card ─────────
class _InfoCard extends StatelessWidget {
  final List<(String, String)> rows;

  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 18, color: Color(0xFF15A147)),
                const SizedBox(width: 8),
                Text(
                  'Informasi Akun',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          ...rows.asMap().entries.map((e) {
            final row = e.value;
            return Column(
              children: [
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        row.$1,
                        style: GoogleFonts.instrumentSans(
                            fontSize: 13, color: const Color(0xFF9E9E9E)),
                      ),
                      const Spacer(),
                      Text(
                        row.$2,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ───────── Mini Stat Card ─────────
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;
  final IconData icon;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x07000000), blurRadius: 6, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
                fontSize: 10, color: const Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }
}

// ───────── Action Button ─────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool outlined;
  final bool fullWidth;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: color),
              label: Text(
                label,
                style: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.w600, color: color),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: Colors.white),
              label: Text(
                label,
                style: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                shadowColor: color.withValues(alpha: 0.4),
              ),
            ),
    );
  }
}
