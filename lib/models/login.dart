import 'user.dart';// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Login {
  final String? token;
  final UserDetail? user;

Login({this.token, this.user});
factory Login.fromJson(Map<String, dynamic> json){
  return Login(
    token: json['token'],
    user: json['user'] != null ? UserDetail.fromJson(json['user']):null,
  );
}
}

  class UserDetail{
    final int? id;
    final String? username;

    UserDetail({this.id, this.username});
    factory UserDetail.fromJson(Map<String, dynamic> json){
      return UserDetail(username: json['user'],);
    }
  }

