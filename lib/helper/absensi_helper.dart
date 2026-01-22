import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AbsensiHelper {
  static const String baseUrl =
      "https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa";

  static final storage = FlutterSecureStorage();

  static Future<bool> absenMasuk({
    required File fotoSelfie,
    required File fotoAktivitas,
    required String status,
    required String keterangan,
  }) async {
    final token = await storage.read(key: 'token');

    var reaksi = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/Absenmasuk"),
    );

    reaksi.headers['Authorization'] = 'Bearer $token';

    // FILE
    reaksi.files.add(
      await http.MultipartFile.fromPath(
        'FotoSelfie',
        fotoSelfie.path,
      ),
    );

    reaksi.files.add(
      await http.MultipartFile.fromPath(
        'FotoAktivitas',
        fotoAktivitas.path,
      ),
    );

    // FIELD
    reaksi.fields['Status'] = status;
    reaksi.fields['Keterangan'] = keterangan;

    final response = await reaksi.send();
    return response.statusCode == 200;
  }

  static Future<bool> absenKeluar({
    required File fotoSelfie,
    required File fotoAktivitas,
    required String status,
    required String keterangan,
  }) async {
    final token = await storage.read(key: 'token');

    var reaksi = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/Absenkeluar"),
    );

    reaksi.headers['Authorization'] = 'Bearer $token';

    reaksi.files.add(
      await http.MultipartFile.fromPath(
        'FotoSelfie',
        fotoSelfie.path,
      ),
    );

    reaksi.files.add(
      await http.MultipartFile.fromPath(
        'FotoAktivitas',
        fotoAktivitas.path,
      ),
    );

    reaksi.fields['Status'] = status;
    reaksi.fields['Keterangan'] = keterangan;

    final response = await reaksi.send();
    return response.statusCode == 200;
  }

  static Future<bool> hapus(int id) async {
    final token = await storage.read(key: 'token');

    final response = await http.delete(
      Uri.parse("$baseUrl/delete/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}
