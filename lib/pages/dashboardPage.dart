import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helper/dashboard_helper.dart';
import '../models/dashboard_model.dart';
import 'FormAbsensiPage.dart';
import 'RiwayatUserPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'RiwayatAdminPage.dart';

class DashboardPage extends StatefulWidget {
  final String role;
  final String token;

  const DashboardPage({super.key, required this.role, required this.token});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardModel? user;
  String jamSekarang = "";
  Timer? timer;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _ambilUser();
    _startClock();
  }

    Future<void> _ambilUser() async {
    try {
      final data = await DashboardHelper.fetchMe(widget.token);

      setState(() {
        user = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }


  void _startClock() {
    _updateJam();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateJam(),
    );
  }

  void _updateJam() {
    setState(() {
      jamSekarang = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
Widget build(BuildContext context) {
  if (loading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  final tanggal = DateFormat(
    'EEEE, d MMM yyyy',
    'id_ID',
  ).format(DateTime.now());

  return Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${user?.username ?? 'User'} 👋🏻',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tanggal,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            _clockCard(),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child:_absenButton(
                  label: 'Masuk',
                  icon: Icons.login,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FormAbsensiPage(isMasuk: true),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: _absenButton(
                      label: 'Keluar',
                      icon: Icons.logout,
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const FormAbsensiPage(isMasuk: false),
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              _riwayatButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _clockCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            jamSekarang,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'WAKTU PRESENSI LOKAL',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _absenButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _riwayatButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => widget.role == 'Admin'
            ? RiwayatAdminPage(token: widget.token)
            : RiwayatUserPage(token: widget.token),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.history, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Lihat Riwayat Lengkap',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}