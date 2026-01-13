import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helper/absensi_helper.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  String jamSekarang = "";
  String message = "";
  bool success = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _updateJam();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateJam();
    });
  }

  void _updateJam() {
    setState(() {
      jamSekarang = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> absenMasuk() async {
    final result = await AbsensiHelper.absenMasuk();

    setState(() {
      success = result['success'] ?? false;
      message = result['message'] ?? "Gagal melakukan absensi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// JAM
            Text(
              "Jam $jamSekarang",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            /// ABSEN MASUK
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  "ABSEN MASUK",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: absenMasuk,
              ),
            ),

            const SizedBox(height: 15),

            /// ABSEN PULANG 
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text(
                  "ABSEN PULANG",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
              ),
            ),

            const SizedBox(height: 25),

            /// NOTIFIKASI
            if (message.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: success
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: success ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      color: success ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        success
                            ? "Berhasil! Anda telah absen masuk."
                            : message,
                        style: TextStyle(
                          color:
                              success ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
