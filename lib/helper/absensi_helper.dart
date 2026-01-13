import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AbsensiHelper {
  static const String baseUrl =
      "https://thioacetic-unreticently-saul.ngrok-free.dev/yunisafa";

  static final storage = FlutterSecureStorage();

  static Future<bool> absenMasuk({
    required File fotoSelfie,
    required File fotoAktivitas,
  }) async {
    final token = await storage.read(key: 'token');

    var reaksi = http.MultipartRequest(
      'Post',Uri.parse("$baseUrl/Absenmasuk"),
    );
      
        reaksi.headers
          ['Authorization']= 'Bearer $token';

          reaksi.files.add(
            await http.MultipartFile.fromPath('fotoSelfie', fotoSelfie.path,),
          ) ;       
        reaksi.files.add(
          await http.MultipartFile.fromPath('fotoAktivitas',fotoAktivitas.path,),
        );

         final response = await reaksi.send();
         return response.statusCode == 200;

      }
  
       


  static Future<bool> absenKeluar({
    required File fotoSelfie,
    required File fotoAktivitas,
  }) async {
    final token = await storage.read(key: 'token');

    var reaksi = http.MultipartRequest(
      'Post',Uri.parse("$baseUrl/Absenkeluar"),
    );
      
        reaksi.headers
          ['Authorization']= 'Bearer $token';

          reaksi.files.add(
            await http.MultipartFile.fromPath('fotoSelfie', fotoSelfie.path,),
          ) ;       
        reaksi.files.add(
          await http.MultipartFile.fromPath('fotoAktivitas',fotoAktivitas.path,),
        );

         final response = await reaksi.send();
         return response.statusCode == 200;

      }
}

