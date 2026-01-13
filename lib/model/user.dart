// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserAbsen {
  final int id;
  final String username;
  final String? role;

  const UserAbsen({
    required this.id,
    required this.username,
    required this.role,
  });

 factory UserAbsen.fromJson(Map<String, dynamic> json){
  return UserAbsen(
    id: json['id'],
    username: json['username'],
    role: json['role'],
  );
 }
 }