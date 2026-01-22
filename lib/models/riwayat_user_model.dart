class RiwayatUserModel {
  final DateTime tanggal;
  final DateTime? jamMasuk;
  final DateTime? jamKeluar;
  final String status;

  RiwayatUserModel({
    required this.tanggal,
    this.jamMasuk,
    this.jamKeluar,
    required this.status,
  });

  factory RiwayatUserModel.fromJson(Map<String, dynamic> json) {
    return RiwayatUserModel(
      tanggal: DateTime.parse(json['tanggal']),
      jamMasuk: json['jamMasuk'] != null ? DateTime.parse(json['jamMasuk']) : null,
      jamKeluar: json['jamKeluar'] != null ? DateTime.parse(json['jamKeluar']) : null,
      status: json['status'],
    );
  }
}
