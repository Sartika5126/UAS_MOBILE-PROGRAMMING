import 'user.dart';// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Login {
  final String token;
  final UserAbsen user;

  const Login({
    required this.token,
    required this.user
  });

  Login copyWith({
    String? token,
    UserAbsen? user,
  }) {
    return Login(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'user': user.toMap(),
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      token: (map["token"] ?? '') as String,
      user: UserAbsen.fromMap((map["user"]?? Map<String,dynamic>.from({})) as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Login.fromJson(String source) => Login.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Login(token: $token, user: $user)';

  @override
  bool operator ==(covariant Login other) {
    if (identical(this, other)) return true;
  
    return 
      other.token == token &&
      other.user == user;
  }

  @override
  int get hashCode => token.hashCode ^ user.hashCode;
}
