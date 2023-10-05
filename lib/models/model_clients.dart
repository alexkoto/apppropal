// To parse this JSON data, do
//
//     final modelClients = modelClientsFromJson(jsonString);

import 'dart:convert';

List<ModelClients> modelClientsFromJson(String str) => List<ModelClients>.from(
    json.decode(str).map((x) => ModelClients.fromJson(x)));

String modelClientsToJson(List<ModelClients> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelClients {
  final String idclient;
  final String nama;
  final String alamat;
  final String pic;
  final String email;
  final String telp;

  ModelClients({
    required this.idclient,
    required this.nama,
    required this.alamat,
    required this.pic,
    required this.email,
    required this.telp,
  });

  factory ModelClients.fromJson(Map<String, dynamic> json) => ModelClients(
        idclient: json["idclient"],
        nama: json["nama"],
        alamat: json["alamat"],
        pic: json["pic"],
        email: json["email"],
        telp: json["telp"],
      );

  Map<String, dynamic> toJson() => {
        "idclient": idclient,
        "nama": nama,
        "alamat": alamat,
        "pic": pic,
        "email": email,
        "telp": telp,
      };
}
