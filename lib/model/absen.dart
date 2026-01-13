// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Absensi {
  final int id;
  final DateTime tanggal;
  final DateTime? jamMasuk;
  final DateTime? jamKeluar;
  final String riwayatAbsensi;
  final String status;

  const Absensi({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.riwayatAbsensi,
    required this.status,
  });
      factory Absensi.fromJson(Map<String, dynamic> json){
        return Absensi(id: json['id'],
        tanggal: DateTime.parse(json['tanggal']),
        jamMasuk: json['jamMasuk']!= null ? DateTime.parse(json['jamMasuk']):null,
        jamKeluar: json['jamKeluar'] != null ? DateTime.parse(json['jamKeluar']): null,
        riwayatAbsensi: json['riwayatAbsensi'],
        status: json['status'],
        );
      }
}