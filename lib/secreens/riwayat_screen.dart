import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/riwayat_model.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<RiwayatAbsen> riwayat = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getRiwayat();
  }

  /// ======================
  /// SERVICE (GET API)
  /// ======================
  Future<void> getRiwayat() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa/riwayat',
        ),
      );

      if (response.statusCode == 401) {
        final jsonData = json.decode(response.body);
        final List data = jsonData['data'];

        setState(() {
          riwayat = data.map((e) => RiwayatAbsen.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data riwayat');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  /// ======================
  /// UI
  /// ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Absensi"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : riwayat.isEmpty
                  ? const Center(child: Text("Riwayat absensi masih kosong"))
                  : ListView.builder(
                      itemCount: riwayat.length,
                      itemBuilder: (context, index) {
                        final item = riwayat[index];

                        return ListTile(
                          leading: Icon(
                            Icons.access_time,
                            color: item.status == 'Hadir'
                                ? Colors.green
                                : Colors.orange,
                          ),
                          title: Text(item.tanggal),
                          subtitle: Text(
                            "Masuk: ${item.jamMasuk} | Pulang: ${item.jamPulang}",
                          ),
                          trailing: Text(
                            item.status,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
