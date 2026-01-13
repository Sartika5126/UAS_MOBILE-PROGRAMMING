import 'dart:convert';

import 'package:absensi_karyawan/pages/absensi_page.dart';
import 'package:absensi_karyawan/secreens/riwayat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<DashboardModel> statusFuture;

  final String baseUrl = 'https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa';

  @override
  void initState() {
    super.initState();
    statusFuture = fetchStatus();
  }

  Future<DashboardModel> fetchStatus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/status'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DashboardModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil status');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: FutureBuilder<DashboardModel>(
        future: statusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data'));
          }
          
          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, ${data.username}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 8),
                Text('Tanggal: ${data.tanggal}'),
                const SizedBox(height: 16),

                Card(
                  child: ListTile(
                    title: const Text('Absen Masuk'),
                    subtitle: Text(data.jamMasuk ?? 'Belum absen masuk'),
                  ),
                ),

                Card(
                  child: ListTile(
                    title: const Text('Absen Keluar'),
                    subtitle: Text(data.jamKeluar ?? 'Belum absen keluar'),
                  ),
                ),

                const SizedBox(height: 10),
                Text('Status: ${data.status}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const Spacer(),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: data.jamMasuk == null 
                          ? () {
                            Navigator.push(
                              context,
                            MaterialPageRoute(
                              builder: (_) => const AbsensiFormPage(isMasuk: true),
                              ),
                              ).then((_) {
                                setState(() {
                                  statusFuture = fetchStatus();
                                });
                              });
                        }
                        : null,
                        child: const Text('Absen Masuk'),
                        ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (data.jamMasuk != null && data.jamKeluar == null) 
                            ? () {
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (_) => const AbsensiFormPage(isMasuk: false),
                                  ),
                                  ).then((_) {
                                    setState(() {
                                      statusFuture = fetchStatus();
                                    });
                                  });
                            }
                            : null,
                            child: const Text('Absen Keluar'),
                            ),
                          ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => const RiwayatScreen(),
                          ),
                        );
                      },
                    child: const Text('Lihat Riwayat'),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}