class DashboardModel {
  final int userId;
  final String username;
  final String tanggal;
  final String? jamMasuk;
  final String? jamKeluar;
  final String status;

  DashboardModel({
    required this.userId,
    required this.username,
    required this.tanggal,
    this.jamMasuk,
    this.jamKeluar,
    required this.status,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      userId: json['userAbssenId'], 
      username: json['userAbsen'], 
      tanggal: json['riwayatAbsensi'],
      jamMasuk: json['jamMasuk'],
      jamKeluar: json['jamKeluar'],
      status: json['status'],
    );
  }
}