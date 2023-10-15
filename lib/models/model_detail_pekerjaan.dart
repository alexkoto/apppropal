// To parse this JSON data, do
//
//     final modelDetailPekerjaan = modelDetailPekerjaanFromJson(jsonString);

import 'dart:convert';

List<ModelDetailPekerjaan> modelDetailPekerjaanFromJson(String str) =>
    List<ModelDetailPekerjaan>.from(
        json.decode(str).map((x) => ModelDetailPekerjaan.fromJson(x)));

String modelDetailPekerjaanToJson(List<ModelDetailPekerjaan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDetailPekerjaan {
  final String id;
  final String idpro;
  final String detailPekerjaan;
  final String satuan;
  final String jumlah;
  final String realisasi;
  final String selisih;

  ModelDetailPekerjaan({
    required this.id,
    required this.idpro,
    required this.detailPekerjaan,
    required this.satuan,
    required this.jumlah,
    required this.realisasi,
    required this.selisih,
  });

  factory ModelDetailPekerjaan.fromJson(Map<String, dynamic> json) =>
      ModelDetailPekerjaan(
        id: json["id"],
        idpro: json["idpro"],
        detailPekerjaan: json["detail_pekerjaan"],
        satuan: json["satuan"],
        jumlah: json["jumlah"],
        realisasi: json["realisasi"],
        selisih: json["selisih"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idpro": idpro,
        "detail_pekerjaan": detailPekerjaan,
        "satuan": satuan,
        "jumlah": jumlah,
        "realisasi": realisasi,
        "selisih": selisih,
      };
}
