// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final modelLevels = modelLevelsFromJson(jsonString);

import 'dart:convert';

List<ModelLevels> modelLevelsFromJson(String str) => List<ModelLevels>.from(
    json.decode(str).map((x) => ModelLevels.fromJson(x)));

String modelLevelsToJson(List<ModelLevels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelLevels {
  final String idlevel;
  final String level;
  final String akses;

  ModelLevels({
    required this.idlevel,
    required this.level,
    required this.akses,
  });

  factory ModelLevels.fromJson(Map<String, dynamic> json) => ModelLevels(
        idlevel: json["idlevel"] ?? "",
        level: json["level"] ?? "",
        akses: json["akses"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "idlevel": idlevel,
        "level": level,
        "akses": akses,
      };
}
