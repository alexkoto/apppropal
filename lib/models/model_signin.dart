// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final modelSignIn = modelSignInFromJson(jsonString);

import 'dart:convert';

ModelSignIn modelSignInFromJson(String str) =>
    ModelSignIn.fromJson(json.decode(str));

String modelSignInToJson(ModelSignIn data) => json.encode(data.toJson());

class ModelSignIn {
  final String msg;
  final String iduser;
  final String username;
  final String password;
  final String namalengkap;
  final String idaktifasi;
  final String idlevel;

  ModelSignIn({
    required this.msg,
    required this.iduser,
    required this.username,
    required this.password,
    required this.namalengkap,
    required this.idaktifasi,
    required this.idlevel,
  });

  factory ModelSignIn.fromJson(Map<String, dynamic> json) => ModelSignIn(
        msg: json["msg"],
        iduser: json["iduser"],
        username: json["username"],
        namalengkap: json["namalengkap"],
        idaktifasi: json["idaktifasi"],
        idlevel: json["idlevel"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "iduser": iduser,
        "username": username,
        "password": password,
        "namalengkap": namalengkap,
        "idaktifasi": idaktifasi,
        "idlevel": idlevel,
      };
}
