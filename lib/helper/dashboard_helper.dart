import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class DashboardHelper {
  static const String baseUrl =
      'https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa';
  static const storage = FlutterSecureStorage();

  static Future<DashboardModel?> fetchMe(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/aku'),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data == null || data['user'] == null) {
      return null;
    }

    return DashboardModel.fromJson(
      data['user'] as Map<String, dynamic>,
    );
  }

  return null;
}
}