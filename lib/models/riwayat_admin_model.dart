// models/dashboard_model.dart
class RiwayatAdminModel {
  final DateTime tanggal;
  final DateTime? jamMasuk;
  final DateTime? jamKeluar;
  final String status;
  final String? username;

  RiwayatAdminModel({
    required this.tanggal,
    this.jamMasuk,
    this.jamKeluar,
    required this.status,
    this.username,
  });

  factory RiwayatAdminModel.fromJson(Map<String, dynamic> json) {
    return RiwayatAdminModel(
      tanggal: DateTime.parse(json['tanggal']),
      jamMasuk: json['jamMasuk'] != null ? DateTime.parse(json['jamMasuk']) : null,
      jamKeluar: json['jamKeluar'] != null ? DateTime.parse(json['jamKeluar']) : null,
      status: json['status'],
      username: json['username'],
    );
  }
}
