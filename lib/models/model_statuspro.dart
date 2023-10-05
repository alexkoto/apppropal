// To parse this JSON data, do
//
//     final modelStatuspro = modelStatusproFromJson(jsonString);

import 'dart:convert';

List<ModelStatuspro> modelStatusproFromJson(String str) =>
    List<ModelStatuspro>.from(
        json.decode(str).map((x) => ModelStatuspro.fromJson(x)));

String modelStatusproToJson(List<ModelStatuspro> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelStatuspro {
  final String idkategori;
  final String kategoriStatus;
  final String keterangan;

  ModelStatuspro({
    required this.idkategori,
    required this.kategoriStatus,
    required this.keterangan,
  });

  factory ModelStatuspro.fromJson(Map<String, dynamic> json) => ModelStatuspro(
        idkategori: json["idkategori"],
        kategoriStatus: json["kategori_status"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "idkategori": idkategori,
        "kategori_status": kategoriStatus,
        "keterangan": keterangan,
      };
}
