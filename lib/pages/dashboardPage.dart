// pages/dashboard_page.dart
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
  final String token; // "Admin" atau "User"

  const DashboardPage({super.key, required this.role, required this.token});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final storage = FlutterSecureStorage();
  String? token;
  DashboardModel? user;
  String jamSekarang = "";
  Timer? timer;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    ambilUser();
    loadToken();
    updateJam();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateJam());
  }

  void updateJam() {
    setState(() {
      jamSekarang = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }
Future<void> loadToken()async{
  final t = await storage.read(key:'token');
  setState((){
    token = t;
  });
}
  Future<void> ambilUser() async {
  try {
    final data = await DashboardHelper.fetchMe(token!);
    if (data != null) {
      setState(() {
        user = data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  } catch (e) {
    setState(() {
      loading = false;
    });
    // optional: print(e); buat debugging
  }
}


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, ${user?.username}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Selamat datang, absen dulu kuy"),
            const SizedBox(height: 20),

            Center(
              child: Text(
                jamSekarang,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FormAbsensiPage(isMasuk: true),
                  ),
                );
              },
              child: const Text("Absen Masuk"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FormAbsensiPage(isMasuk: false),
                  ),
                );
              },
              child: const Text("Absen Keluar"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => widget.role == "Admin"
                        ? RiwayatAdminPage(token: token!)
                        : RiwayatUserPage(token: token!),
                  ),
                );
              },
              child: const Text("Riwayat"),
            ),
          ],
        ),
      ),
    );
  }
}
