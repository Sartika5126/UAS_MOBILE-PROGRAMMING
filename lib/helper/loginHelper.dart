import 'dart:convert';
import 'package:http/http.dart' as xubin;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:absensi_karyawan/model/login.dart';

class LoginHelper {
  static const String myuri =
      'https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa';

  static const storage = FlutterSecureStorage();

  final Map<String, String> _header = {
    "Content-Type": "application/json",
    "ngrok-skip-browser-warning": "true",
  };

  Future<Login?> login(String username, String passwordHash) async {
    final uri = Uri.parse('$myuri/login');

    try {
      final bales = await xubin.post(
        uri,
        headers: _header,
        body: jsonEncode({
          'username': username,
          'password': passwordHash,
        }),
      );

      if (bales.statusCode == 200) {
        final data = jsonDecode(bales.body);
        await storage.write(key: 'token', value: data['token']);
        return Login.fromJson(data);
      } else {
        print("Login gagal: ${bales.body}");
        return null;
      }
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}
