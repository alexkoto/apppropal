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
  final Satuan? satuan;

  ModelDataPekerjaan({
    required this.id,
    required this.pekerjaan,
    this.satuan,
  });

  factory ModelDataPekerjaan.fromJson(Map<String, dynamic> json) =>
      ModelDataPekerjaan(
        id: json["id"],
        pekerjaan: json["pekerjaan"],
        satuan: satuanValues.map[json["satuan"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pekerjaan": pekerjaan,
        "satuan": satuanValues.reverse[satuan],
      };
}

enum Satuan {
  BH,
  BTG,
  BUAH,
  CELL,
  CM,
  GWG,
  KG,
  KMS,
  M,
  M2,
  M3,
  MTR,
  PLG,
  SATUAN_KMS,
  SATUAN_UNIT,
  SET,
  UNIT
}

final satuanValues = EnumValues({
  "Bh": Satuan.BH,
  "Btg": Satuan.BTG,
  "Buah": Satuan.BUAH,
  "Cell": Satuan.CELL,
  "Cm": Satuan.CM,
  "Gwg": Satuan.GWG,
  "Kg": Satuan.KG,
  "KMS": Satuan.KMS,
  "M": Satuan.M,
  "M2": Satuan.M2,
  "M3": Satuan.M3,
  "Mtr": Satuan.MTR,
  "Plg": Satuan.PLG,
  "Kms": Satuan.SATUAN_KMS,
  "unit": Satuan.SATUAN_UNIT,
  "Set": Satuan.SET,
  "Unit": Satuan.UNIT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
