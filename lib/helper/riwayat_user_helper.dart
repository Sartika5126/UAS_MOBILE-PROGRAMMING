import 'dart:convert';
import 'package:absensi_karyawan/models/riwayat_admin_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/riwayat_user_model.dart';


class RiwayatUserHelper {
  static const String baseUrl =
      'https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa';
  static const storage = FlutterSecureStorage();

  Future<List<RiwayatUserModel>> riwayatUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/riwayat'),
      headers: {
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => RiwayatUserModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil riwayat user');
    }
  }
}
