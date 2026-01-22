import 'package:flutter/material.dart';
import '../helper/riwayat_user_helper.dart';
import '../models/riwayat_user_model.dart';
import 'package:intl/intl.dart';


class RiwayatUserPage extends StatelessWidget {
  final String token;
  final api = RiwayatUserHelper();

  RiwayatUserPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Saya')),
      body: FutureBuilder<List<RiwayatUserModel>>(
        future: api.riwayatUser(token),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data!.map((e) {
              return ListTile(
                title: Text(DateFormat('dd/MM/yyyy').format(e.tanggal)),
                subtitle: Text('Masuk: ${e.jamMasuk ?? "-"} | Keluar: ${e.jamKeluar ?? "-"}'),
                trailing: Text(e.status),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
