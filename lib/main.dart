import 'package:flutter/material.dart';
// PENTING: Sesuaikan path ini dengan letak file login_page.dart kamu
// Kalau file login_page.dart ada di dalam folder ui, pakai: import 'ui/login_page.dart';
// Kalau satu folder dengan main.dart, pakai: import 'login_page.dart';
import './page/loginPage.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan label debug
      title: 'Aplikasi Absensi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // INI BAGIAN UTAMANYA:
      // Kita suruh aplikasi langsung buka LoginPage saat pertama kali jalan
      home: const LoginPage(),
    );
  }
}