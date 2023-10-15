// To parse this JSON data, do
//
//     final modelUsers = modelUsersFromJson(jsonString);

import 'dart:convert';

List<ModelUsers> modelUsersFromJson(String str) =>
    List<ModelUsers>.from(json.decode(str).map((x) => ModelUsers.fromJson(x)));

String modelUsersToJson(List<ModelUsers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelUsers {
  final String iduser;
  final String username;
  final String namalengkap;
  final String password;
  final String idaktifasi;
  final String idlevel;

  ModelUsers({
    required this.iduser,
    required this.username,
    required this.namalengkap,
    required this.password,
    required this.idaktifasi,
    required this.idlevel,
  });

  factory ModelUsers.fromJson(Map<String, dynamic> json) => ModelUsers(
        iduser: json["iduser"] ?? "",
        username: json["username"] ?? "",
        namalengkap: json["namalengkap"] ?? "",
        password: json["password"] ?? "",
        idaktifasi: json["idaktifasi"] ?? "",
        idlevel: json["idlevel"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "iduser": iduser,
        "username": username,
        "namalengkap": namalengkap,
        "password": password,
        "idaktifasi": idaktifasi,
        "idlevel": idlevel,
      };
}
