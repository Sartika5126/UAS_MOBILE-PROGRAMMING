// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class UserAbsen {
//   final int id;
//   final String username;

//   const UserAbsen({
//     required this.id,
//     required this.username
//   });

//   UserAbsen copyWith({
//     int? id,
//     String? username,
//   }) {
//     return UserAbsen(
//       id: id ?? this.id,
//       username: username ?? this.username,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'username': username,
//     };
//   }

//   factory UserAbsen.fromMap(Map<String, dynamic> map) {
//     return UserAbsen(
//       id: (map["id"] ?? 0) as int,
//       username: (map["username"] ?? '') as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UserAbsen.fromJson(String source) => UserAbsen.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'UserAbsen(id: $id, username: $username)';

//   @override
//   bool operator ==(covariant UserAbsen other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.id == id &&
//       other.username == username;
//   }

//   @override
//   int get hashCode => id.hashCode ^ username.hashCode;
// }
