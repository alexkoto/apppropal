// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final modelAktifasis = modelAktifasisFromJson(jsonString);

import 'dart:convert';

List<ModelAktifasis> modelAktifasisFromJson(String str) =>
    List<ModelAktifasis>.from(
        json.decode(str).map((x) => ModelAktifasis.fromJson(x)));

String modelAktifasisToJson(List<ModelAktifasis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAktifasis {
  final String idaktifasi;
  final String aktifasi;

  ModelAktifasis({
    required this.idaktifasi,
    required this.aktifasi,
  });

  factory ModelAktifasis.fromJson(Map<String, dynamic> json) => ModelAktifasis(
        idaktifasi: json["idaktifasi"] ?? "",
        aktifasi: json["aktifasi"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "idaktifasi": idaktifasi,
        "aktifasi": aktifasi,
      };
}
