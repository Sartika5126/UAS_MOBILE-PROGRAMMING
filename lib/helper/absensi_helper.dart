import 'dart:convert';
import 'package:http/http.dart' as http;

class AbsensiHelper {
  static const String baseUrl =
      "https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa";

  static Future<Map<String, dynamic>> absenMasuk() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/Absenmasuk"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          "success": false,
          "message": "Server error"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Gagal koneksi API"
      };
    }
  }
}
