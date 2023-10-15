// To parse this JSON data, do
//
//     final modelDetailPekerjaan = modelDetailPekerjaanFromJson(jsonString);

import 'dart:convert';

List<ModelPekerjaanHarian> modelDetailPekerjaanFromJson(String str) =>
    List<ModelPekerjaanHarian>.from(
        json.decode(str).map((x) => ModelPekerjaanHarian.fromJson(x)));

String modelDetailPekerjaanToJson(List<ModelPekerjaanHarian> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelPekerjaanHarian {
  final String id;
  final String keypro;
  final String tanggal;
  final String detailPekerjaan;
  final String satuan;
  final String jumlah;

  ModelPekerjaanHarian({
    required this.id,
    required this.keypro,
    required this.tanggal,
    required this.detailPekerjaan,
    required this.satuan,
    required this.jumlah,
  });

  factory ModelPekerjaanHarian.fromJson(Map<String, dynamic> json) =>
      ModelPekerjaanHarian(
        id: json["id"],
        keypro: json["keypro"],
        tanggal: json["tanggal"],
        detailPekerjaan: json["detail_pekerjaan"],
        satuan: json["satuan"],
        jumlah: json["jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "keypro": keypro,
        "tanggal": tanggal,
        "detail_pekerjaan": detailPekerjaan,
        "satuan": satuan,
        "jumlah": jumlah,
      };
}
