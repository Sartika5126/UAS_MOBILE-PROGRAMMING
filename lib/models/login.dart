import 'user.dart';// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Login {
  final String token;
  final UserAbsen user;

Login({required this.token, required this.user});
factory Login.fromJson(Map<String, dynamic> json){
  return Login(
    token: json['token'],
    user: UserAbsen.fromJson(json['user']),
  );
}
}


