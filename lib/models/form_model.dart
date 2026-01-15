class FormAbsen {
  final DateTime tanggal;
  final DateTime? jamMasuk;
  final DateTime? jamKeluar;
  final String status;

  FormAbsen({
    required this.tanggal,
    this.jamMasuk,
    this.jamKeluar,
    required this.status,
  });

  factory FormAbsen.fromJson(Map<String, dynamic> json) {
    return FormAbsen(
      tanggal: DateTime.parse(json['tanggal']),
      jamMasuk: json['jamMasuk'] != null
          ? DateTime.parse(json['jamMasuk'])
          : null,
      jamKeluar: json['jamKeluar'] != null
          ? DateTime.parse(json['jamKeluar'])
          : null,
      status: json['status'],
    );
  }
}
