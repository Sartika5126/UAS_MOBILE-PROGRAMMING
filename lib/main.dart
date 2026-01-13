// import 'package:absensi_karyawan/pages/dashboard_page.dart';
import 'package:absensi_karyawan/pages/dashboard_page.dart';
// import 'package:absensi_karyawan/secreens/riwayat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './page/loginPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const storage = FlutterSecureStorage();

  Future<String?> _checkLogin() async {
    return await storage.read(key: 'token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Absensi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: _checkLogin(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const DashboardPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}