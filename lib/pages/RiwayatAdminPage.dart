import 'package:flutter/material.dart';
import '../helper/riwayat_admin_helper.dart';
import '../models/riwayat_admin_model.dart';

class RiwayatAdminPage extends StatelessWidget {
  final String token;
  final api = DashboardHelper();

  RiwayatAdminPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absensi Hari Ini')),
      body: FutureBuilder<List<RiwayatAdminModel>>(
        future: api.riwayatAdminHariIni(token),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data!.map((e) {
              return ListTile(
                title: Text(e.username ?? '-'),
                trailing: Text(e.status),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
