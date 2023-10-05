import 'dart:convert';
import 'package:app_manpropal/models/model_clients.dart';
import 'package:app_manpropal/models/model_data_pekerjaan.dart';
import 'package:app_manpropal/models/model_statuspro.dart';
import 'package:app_manpropal/models/model_user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/model_signin.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<ModelSignIn> signIn(String username, String password) async {
    final url = Uri.parse('$baseUrl/login.php');
    final response = await http.post(url, body: {
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return ModelSignIn.fromJson(responseData);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String password, String namalengkap) async {
    final url = Uri.parse(
        '$baseUrl/register.php'); // Sesuaikan dengan nama file PHP Anda
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
        'namalengkap': namalengkap,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> getLevelById(int idlevel) async {
    final url = Uri.parse('$baseUrl/GetIdLevelUser.php?idlevel=$idlevel');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to get level by id');
    }
  }

  Future<List<Map<String, dynamic>>> getPekerjaan(
      String iduser, String idlevel) async {
    try {
      final url = Uri.parse("$baseUrl/getpro.php");
      final response = await http.post(url, body: {
        "iduser": iduser,
        "idlevel": idlevel,
      });

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
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

  Future<void> tambahkanProject({
    required String nmpro,
    required String nopro,
    required String mulai,
    required String selesai,
    required String nilai,
    required String idclient,
    required String idstatus,
    required String iduser,
  }) async {
    final url = Uri.parse("$baseUrl/add_project.php");
    final response = await http.post(url, body: {
      "nmpro": nmpro,
      "nopro": nopro,
      "mulai": mulai,
      "selesai": selesai,
      "nilai": nilai,
      "idclient": idclient,
      "idstatus": idstatus,
      "iduser": iduser,
    });

    if (response.statusCode == 200) {
      // Proyek berhasil ditambahkan, lakukan tindakan yang sesuai (misalnya, kembali ke halaman utama).
    } else {
      // Proyek gagal ditambahkan, tampilkan pesan kesalahan kepada pengguna.
      throw Exception('Gagal menambahkan proyek. Coba lagi.');
    }
  }

  Future<List<ModelUsers>> getUsers() async {
    final url = Uri.parse("$baseUrl/get_users.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelUsers> users = [];

      for (final userData in data) {
        users.add(ModelUsers(
          iduser: userData['iduser'],
          namalengkap: userData['namalengkap'],
          username: userData['username'],
          password: userData['password'],
          idaktifasi: userData['idaktifasi'],
          idlevel: userData['idlevel'],
        ));
      }

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<ModelClients>> getClients() async {
    final url = Uri.parse("$baseUrl/get_clients.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelClients> clients = [];

      for (final clientData in data) {
        clients.add(
          ModelClients(
            idclient: clientData['idclient'],
            nama: clientData['nama'],
            alamat: clientData['alamat'],
            pic: clientData['pic'],
            email: clientData['email'],
            telp: clientData['telp'],
          ),
        );
      }

      return clients;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<ModelStatuspro>> getStatusPro() async {
    final url = Uri.parse('$baseUrl/get_status.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelStatuspro> statusProList = [];

      for (final statusproData in data) {
        statusProList.add(
          ModelStatuspro(
            idkategori: statusproData['idkategori'],
            kategoriStatus: statusproData['kategori_status'],
            keterangan: statusproData['keterangan'],
          ),
        );
      }

      return statusProList;
    } else {
      throw Exception('Failed to load statuspro');
    }
  }

  Future<List<ModelDataPekerjaan>> getDataPekerjaan() async {
    final url = Uri.parse(
        '$baseUrl/get_datapekerjaan.php'); // Ganti dengan URL sebenarnya
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelDataPekerjaan> dataPekerjaan = [];

      for (final pekerjaanData in data) {
        dataPekerjaan.add(
          ModelDataPekerjaan.fromJson(pekerjaanData),
        );
      }

      return dataPekerjaan;
    } else {
      throw Exception('Failed to load pekerjaan');
    }
  }

  Future<List<ModelDataPekerjaan>> searchPekerjaan(String pattern) async {
    final url = Uri.parse('$baseUrl/search_pekerjaan.php?pattern=$pattern');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelDataPekerjaan> pekerjaanList = [];

      for (final pekerjaanData in data) {
        pekerjaanList.add(
          ModelDataPekerjaan(
            id: pekerjaanData['id'],
            pekerjaan: pekerjaanData['pekerjaan'],
            satuan: satuanValues.map[pekerjaanData['satuan']] ?? Satuan.BH,
          ),
        );
      }

      return pekerjaanList;
    } else {
      throw Exception('Failed to search pekerjaan');
    }
  }

  // Tambahkan fungsi API lainnya sesuai kebutuhan
}
