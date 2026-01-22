import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helper/riwayat_user_helper.dart';
import '../models/riwayat_user_model.dart';

class RiwayatUserPage extends StatefulWidget {
  final String token;

  RiwayatUserPage({super.key, required this.token});

  @override
  State<RiwayatUserPage> createState() => _RiwayatUserPageState();
}

class _RiwayatUserPageState extends State<RiwayatUserPage> {
  final api = RiwayatUserHelper();

  Future<List<RiwayatUserModel>> fetchRiwayat() async {
    return await api.riwayatUser(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Saya')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder<List<RiwayatUserModel>>(
          future: fetchRiwayat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Belum ada riwayat absen'));
            }

            final data = snapshot.data!;
            return ListView(
              children: data.map((e) {
                return ListTile(
                  title: Text(DateFormat('dd/MM/yyyy').format(e.tanggal)),
                  subtitle: Text(
                    'Masuk: ${e.jamMasuk != null ? DateFormat('HH:mm').format(e.jamMasuk!) : "-"} | Keluar: ${e.jamKeluar != null ? DateFormat('HH:mm').format(e.jamKeluar!) : "-"}',
                  ),
                  trailing: Text(e.status),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
