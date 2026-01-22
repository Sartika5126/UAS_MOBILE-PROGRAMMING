import 'package:absensi_karyawan/pages/RiwayatUserPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');

  runApp(MyApp(token: token ?? "")); 
}

class MyApp extends StatelessWidget {
  final String token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Riwayat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: RiwayatUserPage(token: token),
    );
  }
}