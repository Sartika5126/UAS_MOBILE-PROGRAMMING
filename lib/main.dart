import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'pages/dashboard_page.dart';
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/loginPage.dart';
import 'pages/dashboardPage.dart';
import 'pages/FormAbsensiPage.dart';
import 'pages/RiwayatAdminPage.dart';
import 'pages/RiwayatUserPage.dart';
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
<<<<<<< Updated upstream
      home: const DashboardPage(),
=======
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),

        '/dashboard': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;

        if (args == null) {
          return const LoginPage();
        }

        final data = args as Map<String, dynamic>;
        final String role = data['role'];
        final String token = data['token'];

        return DashboardPage(role: role, token: token);
      },

        '/formAbsensi': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final bool isMasuk = args['isMasuk'];
          return FormAbsensiPage(isMasuk: isMasuk);
        },

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
>>>>>>> Stashed changes
    );
  }
}