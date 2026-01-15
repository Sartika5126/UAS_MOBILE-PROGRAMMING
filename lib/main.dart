import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'pages/loginPage.dart';
import 'pages/dashboardPage.dart';
import 'pages/FormAbsensiPage.dart';
import 'pages/RiwayatAdminPage.dart';
import 'pages/RiwayatUserPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Absensi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),

        // Dashboard butuh role dan token, jadi kita handle via arguments
        '/dashboard': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final String role = args['role'];
          final String token = args['token'];
          return DashboardPage(role: role, token: token);
        },

        // Form Absensi juga butuh token
        '/formAbsensi': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final bool isMasuk = args['isMasuk'];
          return FormAbsensiPage(isMasuk: isMasuk);
        },

        // Riwayat User/Admin
        '/riwayat': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final String role = args['role'];
          final String token = args['token'];
          return role == 'Admin'
              ? RiwayatAdminPage(token: token)
              : RiwayatUserPage(token: token);
        },
      },
    );
  }
}
