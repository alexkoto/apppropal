// To parse this JSON data, do
//
//     final modelProject = modelProjectFromJson(jsonString);

import 'dart:convert';

List<ModelProject> modelProjectFromJson(String str) => List<ModelProject>.from(
    json.decode(str).map((x) => ModelProject.fromJson(x)));

String modelProjectToJson(List<ModelProject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelProject {
  final String idpro;
  final String noPro;
  final String nmPro;
  final String mulai;
  final String selesai;
  final String nilai;
  final String idclient;
  final String idstatus;
  final String iduser;

  ModelProject({
    required this.idpro,
    required this.noPro,
    required this.nmPro,
    required this.mulai,
    required this.selesai,
    required this.nilai,
    required this.idclient,
    required this.idstatus,
    required this.iduser,
  });

  factory ModelProject.fromJson(Map<String, dynamic> json) => ModelProject(
        idpro: json["idpro"],
        noPro: json["no_pro"],
        nmPro: json["nm_pro"],
        mulai: json["mulai"],
        selesai: json["selesai"],
        nilai: json["nilai"],
        idclient: json["idclient"],
        idstatus: json["idstatus"],
        iduser: json["iduser"],
      );

  Map<String, dynamic> toJson() => {
        "idpro": idpro,
        "no_pro": noPro,
        "nm_pro": nmPro,
        "mulai": mulai,
        "selesai": selesai,
        "nilai": nilai,
        "idclient": idclient,
        "idstatus": idstatus,
        "iduser": iduser,
      };
}
