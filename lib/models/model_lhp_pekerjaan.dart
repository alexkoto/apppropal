// To parse this JSON data, do
//
//     final modelLhpPekerjaan = modelLhpPekerjaanFromJson(jsonString);

import 'dart:convert';

List<ModelLhpPekerjaan> modelLhpPekerjaanFromJson(String str) =>
    List<ModelLhpPekerjaan>.from(
        json.decode(str).map((x) => ModelLhpPekerjaan.fromJson(x)));

String modelLhpPekerjaanToJson(List<ModelLhpPekerjaan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelLhpPekerjaan {
  final String id;
  final String idpro;
  final String nolhp;
  final String nolhpp;
  final String detailPekerjaan;
  final String satuan;
  final String jumlah;

  ModelLhpPekerjaan({
    required this.id,
    required this.idpro,
    required this.nolhp,
    required this.nolhpp,
    required this.detailPekerjaan,
    required this.satuan,
    required this.jumlah,
  });

  factory ModelLhpPekerjaan.fromJson(Map<String, dynamic> json) =>
      ModelLhpPekerjaan(
        id: json["id"],
        idpro: json["idpro"],
        nolhp: json["nolhp"],
        nolhpp: json["nolhpp"],
        detailPekerjaan: json["detail_pekerjaan"],
        satuan: json["satuan"],
        jumlah: json["jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idpro": idpro,
        "nolhp": nolhp,
        "nolhpp": nolhpp,
        "detail_pekerjaan": detailPekerjaan,
        "satuan": satuan,
        "jumlah": jumlah,
      };
}
