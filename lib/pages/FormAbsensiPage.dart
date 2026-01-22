import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../helper/absensi_helper.dart';

class FormAbsensiPage extends StatefulWidget {
  final bool isMasuk; // true = masuk, false = keluar

  const FormAbsensiPage({super.key, required this.isMasuk});

  @override
  State<FormAbsensiPage> createState() => _FormAbsensiPageState();
}

class _FormAbsensiPageState extends State<FormAbsensiPage> {
  File? fotoSelfie;
  File? fotoAktivitas;

  final TextEditingController keteranganController = TextEditingController();

  String jamSekarang = "";
  Timer? timer;
  bool loading = false;

  String statusHariIni = "loading";

  String? selectedStatus;
  List<String> statusList = [];

  @override
  void initState() {
    super.initState();
    _updateJam();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateJam());
    cekStatusHariIni();
    ambilStatus();
  }

  void _updateJam() {
    setState(() {
      jamSekarang = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    keteranganController.dispose();
    super.dispose();
  }

  Future<void> ambilFoto(bool selfie) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (file == null) return;

    setState(() {
      if (selfie) {
        fotoSelfie = File(file.path);
      } else {
        fotoAktivitas = File(file.path);
      }
    });
  }

  Future<void> ambilStatus() async {
    final token = await AbsensiHelper.storage.read(key: 'token');
    final response = await http.get(
      Uri.parse("${AbsensiHelper.baseUrl}/status-list"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        statusList = data.map((e) => e.toString()).toList();
      });
    }
  }

  Future<void> cekStatusHariIni() async {
    final token = await AbsensiHelper.storage.read(key: 'token');
    final response = await http.get(
      Uri.parse("${AbsensiHelper.baseUrl}/statusHariIni"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        statusHariIni = data['status'];
      });
    } else {
      statusHariIni = "belumAbsen";
    }
  }

  Future<void> submit() async {
    if (fotoSelfie == null || fotoAktivitas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto selfie & aktivitas wajib")),
      );
      return;
    }

    if (selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Status wajib dipilih")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      bool success;

      if (widget.isMasuk) {
        success = await AbsensiHelper.absenMasuk(
          fotoSelfie: fotoSelfie!,
          fotoAktivitas: fotoAktivitas!,
          status: selectedStatus!,
          keterangan: keteranganController.text,
        );
      } else {
        success = await AbsensiHelper.absenKeluar(
          fotoSelfie: fotoSelfie!,
          fotoAktivitas: fotoAktivitas!,
          status: selectedStatus!,
          keterangan: keteranganController.text,
        );
      }

      if (success) {
        await cekStatusHariIni();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isMasuk
                    ? "Absen masuk berhasil"
                    : "Absen keluar berhasil",
              ),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception("Gagal absen");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool tombolDisable = loading ||
        (widget.isMasuk && statusHariIni == "Hadir") ||
        (!widget.isMasuk && statusHariIni == "SudahKeluar");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMasuk ? "Absen Masuk" : "Absen Keluar"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                jamSekarang,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text("Status"),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statusList.map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Text("Keterangan"),
            const SizedBox(height: 8),
            TextField(
              controller: keteranganController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh: izin sakit, urusan keluarga",
              ),
            ),
            const SizedBox(height: 20),

            Text("Foto Selfie"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => ambilFoto(true),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: fotoSelfie == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : Image.file(fotoSelfie!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),

            Text("Foto Aktivitas"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => ambilFoto(false),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: fotoAktivitas == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : Image.file(fotoAktivitas!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: tombolDisable ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.isMasuk ? "ABSEN MASUK" : "ABSEN KELUAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
