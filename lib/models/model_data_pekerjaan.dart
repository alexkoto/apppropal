// To parse this JSON data, do
//
//     final modelDataPekerjaan = modelDataPekerjaanFromJson(jsonString);

import 'dart:convert';

List<ModelDataPekerjaan> modelDataPekerjaanFromJson(String str) =>
    List<ModelDataPekerjaan>.from(
        json.decode(str).map((x) => ModelDataPekerjaan.fromJson(x)));

String modelDataPekerjaanToJson(List<ModelDataPekerjaan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDataPekerjaan {
  final String id;
  final String pekerjaan;
  final String satuan;

  ModelDataPekerjaan({
    required this.id,
    required this.pekerjaan,
    required this.satuan,
  });

  factory ModelDataPekerjaan.fromJson(Map<String, dynamic> json) =>
      ModelDataPekerjaan(
        id: json["id"],
        pekerjaan: json["pekerjaan"],
        satuan: json["satuan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pekerjaan": pekerjaan,
        "satuan": satuan,
      };
}
