class RiwayatAbsen {
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;
  final String status;

  RiwayatAbsen({
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
    required this.status,
  });

  /// ======================
  /// DARI JSON API
  /// ======================
  factory RiwayatAbsen.fromJson(Map<String, dynamic> json) {
    return RiwayatAbsen(
      tanggal: json['tanggal'] ?? '-',
      jamMasuk: json['jam_masuk'] ?? '-',
      jamPulang: json['jam_pulang'] ?? '-',
      status: json['status'] ?? '-',
    );
  }
}
