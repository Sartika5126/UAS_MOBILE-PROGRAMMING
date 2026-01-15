import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../helper/absensi_helper.dart';

class FormAbsensiPage extends StatefulWidget {
  final bool isMasuk;
   // true = masuk, false = keluar

  const FormAbsensiPage({super.key, required this.isMasuk});

  @override
  State<FormAbsensiPage> createState() => _FormAbsensiPageState();
}

class _FormAbsensiPageState extends State<FormAbsensiPage> {
  File? fotoSelfie;
  File? fotoAktivitas;

  String jamSekarang = "";
  Timer? timer;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _updateJam();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateJam();
    });
  }

  void _updateJam() {
    setState(() {
      jamSekarang = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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

  Future<void> submit() async {
    if (fotoSelfie == null || fotoAktivitas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto selfie & aktivitas wajib")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      if (widget.isMasuk) {
        await AbsensiHelper.absenMasuk(
          fotoSelfie: fotoSelfie!,
          fotoAktivitas: fotoAktivitas!,
        );
      } else {
        await AbsensiHelper.absenKeluar(
           fotoSelfie: fotoSelfie!,
          fotoAktivitas: fotoAktivitas!,
        );
      }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMasuk ? "Absen Masuk" : "Absen Keluar"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// JAM
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

            /// FOTO SELFIE
            Text("Foto Selfie"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => ambilFoto(true),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: fotoSelfie == null
                    ? const Center(child: Icon(Icons.camera_alt, size: 40))
                    : Image.file(fotoSelfie!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            /// FOTO AKTIVITAS
            Text("Foto Aktivitas Kerja"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => ambilFoto(false),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: fotoAktivitas == null
                    ? const Center(child: Icon(Icons.camera, size: 40))
                    : Image.file(fotoAktivitas!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
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
