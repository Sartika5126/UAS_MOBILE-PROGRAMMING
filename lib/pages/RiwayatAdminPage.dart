import 'package:flutter/material.dart';
import '../helper/riwayat_admin_helper.dart';
import '../models/riwayat_admin_model.dart';

class RiwayatAdminPage extends StatefulWidget {
  final String token;

  const RiwayatAdminPage({super.key, required this.token});

  @override
  State<RiwayatAdminPage> createState() => _RiwayatAdminPageState();
}

class _RiwayatAdminPageState extends State<RiwayatAdminPage> {
  final api = RiwayatAdminHelper();

  Future<List<RiwayatAdminModel>> fetchRiwayat() async {
    return await api.riwayatAdminHariIni(widget.token);
  }

  Future<void> hapusSemua() async {
    try {
      await api.hapusRiwayatHariIni(widget.token);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Riwayat hari ini berhasil dihapus")),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal hapus: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi Hari Ini'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Hapus semua?"),
                  content: const Text(
                      "Semua riwayat absensi hari ini akan dihapus. Ga bisa balik."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        hapusSemua();
                      },
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder<List<RiwayatAdminModel>>(
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
                  title: Text(e.username ?? "-"),
                  subtitle: Text(
                    'Masuk: ${e.jamMasuk != null ? "${e.jamMasuk!.hour}:${e.jamMasuk!.minute}" : "-"} | '
                    'Keluar: ${e.jamKeluar != null ? "${e.jamKeluar!.hour}:${e.jamKeluar!.minute}" : "-"}',
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
