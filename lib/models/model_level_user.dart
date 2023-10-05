// To parse this JSON data, do
//
//     final modelLevelUser = modelLevelUserFromJson(jsonString);

import 'dart:convert';

List<ModelLevelUser> modelLevelUserFromJson(String str) =>
    List<ModelLevelUser>.from(
        json.decode(str).map((x) => ModelLevelUser.fromJson(x)));

String modelLevelUserToJson(List<ModelLevelUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelLevelUser {
  final String idlevel;
  final String level;
  final String akses;

  ModelLevelUser({
    required this.idlevel,
    required this.level,
    required this.akses,
  });

  factory ModelLevelUser.fromJson(Map<String, dynamic> json) => ModelLevelUser(
        idlevel: json["idlevel"],
        level: json["level"],
        akses: json["akses"],
      );

  Map<String, dynamic> toJson() => {
        "idlevel": idlevel,
        "level": level,
        "akses": akses,
      };
}
