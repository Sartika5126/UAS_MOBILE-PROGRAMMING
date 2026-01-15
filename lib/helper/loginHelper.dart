import 'dart:convert';
import 'package:http/http.dart' as xubin;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/models/login.dart';

class LoginHelper{
  static const String myuri= 'https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa';
  static final storage = FlutterSecureStorage();
  final Map<String, String> _header = {
    "Content-Type": "application/json",
    "ngrok-skip-browser-warning":"true",
  };

  Future<Login?> login(String username, String passwordHash) async{
    final uri = Uri.parse('$myuri/login');
    try{
      final bales = await xubin.post(
        uri,
        headers: _header,
        body: jsonEncode({'Username':username, 'PasswordHash': passwordHash,})

      );

     

      if(bales.statusCode == 200){
        print("cek hasil api: ${bales.body}");
        final data = jsonDecode(bales.body);

        await storage.write(key: 'token', value: data['token'].toString(),);
        return Login.fromJson(data);
      }else{
        print ("Hahaha gagal: ${bales.body}");
        return null;
      }
    }catch (e){
      print ('Error saat anda login please jangan maksa: $e');
      return null;
    }
  }

  Future<String?> getToken()async{
    return await storage.read(key: 'token');
  }
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}