import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<void> inputLhp({
    required String idpro,
    required String tanggal,
    required String latitude,
    required String longitude,
    required String lokasi,
    required String personil,
    required String cuaca,
    required String catatan,
  }) async {
    String nolhp = '$idpro$tanggal';
    try {
      final url = Uri.parse("https://prisan.co.id/app_propal/add_prolhp.php");
      final response = await http.post(url, body: {
        'idpro': idpro,
        'nolhp': nolhp,
        'tanggal': tanggal,
        'lan': latitude,
        'lon': longitude,
        'lokasi': lokasi,
        'personil': personil,
        'cuaca': cuaca,
        'catatan_spv': catatan,
      });

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to save data.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDetail(String idpro) async {
    try {
      final url =
          Uri.parse("https://prisan.co.id/app_propal/detail_project.php");
      final response = await http.post(url, body: {"idpro": idpro});

      if (response.statusCode == 200) {
        final detaildata = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(detaildata);
      } else {
        throw Exception('Failed to fetch data.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('An error occurred: $e');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      if (kDebugMode) {
        print("service disable");
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinate({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      String currentAddress =
          "${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";

      return currentAddress;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> saveDataToServer(
    BuildContext context,
    String idpro,
    String terpasang,
    String tanggal,
    String detailPekerjaan,
    String satuan,
  ) async {
    try {
      final url =
          Uri.parse("https://prisan.co.id/app_propal/add_prolhp_pek.php");
      final response = await http.post(url, body: {
        "idpro": idpro,
        "nolhp": '$idpro$tanggal',
        "nolhpp": '$idpro$tanggal',
        "detail_pekerjaan": detailPekerjaan,
        "satuan": satuan,
        "jumlah": terpasang,
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil disimpan.'),
          ),
        );
        // _terpasangController.text = '';
        ApiService().getDetail(idpro);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan data.'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }
}
