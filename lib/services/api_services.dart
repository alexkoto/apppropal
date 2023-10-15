import 'dart:convert';
import 'package:app_manpropal/models/model_aktifasi.dart';
import 'package:app_manpropal/models/model_clients.dart';
import 'package:app_manpropal/models/model_data_pekerjaan.dart';
import 'package:app_manpropal/models/model_level.dart';
import 'package:app_manpropal/models/model_statuspro.dart';
import 'package:app_manpropal/models/model_user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/model_signin.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

//******Login Register */
  Future<ModelSignIn> signIn(String username, String password) async {
    final url = Uri.parse('$baseUrl/login.php');
    final response = await http.post(url, body: {
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // if (kDebugMode) {
      //   print('responsebody:${response.body}');
      // }
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

  Future<String?> getLevelById(String idLevel) async {
    final url = Uri.parse('$baseUrl/get_level_by_id.php?idlevel=$idLevel');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String? level = data['level'];
      return level;
    } else {
      throw Exception('Failed to load level by ID');
    }
  }

//******getPekerjaan*/
  Future<List<Map<String, dynamic>>> getPekerjaan(
      String iduser, String idlevel) async {
    try {
      final url = Uri.parse("$baseUrl/getpro.php");
      final response = await http.post(url, body: {
        "iduser": iduser,
        "idlevel": idlevel,
      });

      if (response.statusCode == 200) {
        // if (kDebugMode) {
        //   print(response.body);
        // }
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch data.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDetail(String keypro) async {
    try {
      final url = Uri.parse('$baseUrl/get_pekerjaan_by_keypro.php');
      final response = await http.post(url, body: {"keypro": keypro});

      if (response.statusCode == 200) {
        final detaildata = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(detaildata);
      } else {
        throw Exception('Failed to load details');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> inputLhp(Map<String, String> data) async {
    try {
      final url = Uri.parse('$baseUrl/add_prolhp.php');
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

//******getPekerjaanby status*/
  Future<List<Map<String, dynamic>>> getPekerjaanByStatus(
      String iduser, String idlevel, String idstatus) async {
    try {
      final url = Uri.parse("$baseUrl/getprostatus.php");
      final response = await http.post(url, body: {
        "iduser": iduser,
        "idlevel": idlevel,
        "idstatus": idstatus,
      });

      if (response.statusCode == 200) {
        // if (kDebugMode) {
        //   print(response.body);
        // }
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch data.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw Exception('An error occurred: $e');
    }
  }

//******getUsers*/
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

  Future<ModelUsers> getUserById(String iduser) async {
    List<ModelUsers> users = await getUsers(); // Mengambil semua data pengguna

    try {
      ModelUsers user = users.firstWhere((user) => user.iduser == iduser);
      return user;
    } catch (e) {
      throw Exception('User with iduser $iduser not found');
    }
  }

  Future<ModelUsers> addUser(
    String namalengkap,
    String username,
    String password,
    String idaktifasi,
    String idlevel,
  ) async {
    final Uri url = Uri.parse('$baseUrl/add_user.php');
    final response = await http.post(
      url,
      body: {
        'namalengkap': namalengkap,
        'username': username,
        'password': password,
        'idaktifasi': idaktifasi,
        'idlevel': idlevel,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final ModelUsers newUser = ModelUsers.fromJson(responseData);
      return newUser;
    } else {
      throw Exception('Gagal menambahkan klien');
    }
  }

  Future<ModelUsers> updateUser(
      String iduser,
      String namalengkap,
      String username,
      String password,
      String idaktifasi,
      String idlevel) async {
    final url = Uri.parse("$baseUrl/update_user.php");
    final response = await http.post(
      url,
      body: {
        "iduser": iduser,
        "namalengkap": namalengkap,
        "username": username,
        "password": password,
        "idaktifasi": idaktifasi,
        "idlevel": idlevel,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final ModelUsers updatedUser = ModelUsers.fromJson(responseData);
      return updatedUser;
    } else {
      throw Exception('Gagal memperbarui klien');
    }
  }

  Future<void> deleteUser(String idUser) async {
    final Uri url = Uri.parse('$baseUrl/delete_user.php');
    final response = await http.post(
      url,
      body: {
        'iduser': idUser,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus klien');
    }
  }

//******getClients*/
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
      // if (kDebugMode) {
      //   print(clients.toString());
      // }
      return clients;
    } else {
      throw Exception('Gagal mengambil data klien');
    }
  }

  Future<List<ModelClients>> getClients1() async {
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

  Future<ModelClients> addClient(
    String nama,
    String alamat,
    String pic,
    String email,
    String telp,
  ) async {
    final Uri url = Uri.parse('$baseUrl/add_client.php');
    final response = await http.post(
      url,
      body: {
        'nama': nama,
        'alamat': alamat,
        'pic': pic,
        'email': email,
        'telp': telp,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final ModelClients newClient = ModelClients.fromJson(responseData);
      return newClient;
    } else {
      throw Exception('Gagal menambahkan klien');
    }
  }

  Future<ModelClients> updateClient(String idclient, String nama, String alamat,
      String pic, String email, String telp) async {
    final url = Uri.parse("$baseUrl/update_client.php");
    final response = await http.post(
      url,
      body: {
        "idclient": idclient,
        "nama": nama,
        "alamat": alamat,
        "pic": pic,
        "email": email,
        "telp": telp,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final ModelClients updatedClient = ModelClients.fromJson(responseData);
      return updatedClient;
    } else {
      throw Exception('Gagal memperbarui klien');
    }
  }

  Future<void> deleteClient(String idClient) async {
    final Uri url = Uri.parse('$baseUrl/delete_client.php');
    final response = await http.post(
      url,
      body: {
        'idclient': idClient,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus klien');
    }
  }

//******getStatusPro*/
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

  //******getLevels*/
  Future<List<ModelLevels>> getLevels() async {
    final url = Uri.parse('$baseUrl/get_level.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelLevels> levelList = [];

      for (final levelData in data) {
        levelList.add(
          ModelLevels(
            idlevel: levelData['idlevel'],
            level: levelData['level'],
            akses: levelData['akses'],
          ),
        );
      }

      return levelList;
    } else {
      throw Exception('Failed to load statuspro');
    }
  }

  //******getLevels*/
  Future<List<ModelAktifasis>> getAktifasis() async {
    final url = Uri.parse('$baseUrl/get_aktifasi.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ModelAktifasis> aktifasiList = [];

      for (final aktifasiData in data) {
        aktifasiList.add(
          ModelAktifasis(
            idaktifasi: aktifasiData['idaktifasi'],
            aktifasi: aktifasiData['aktifasi'],
          ),
        );
      }

      return aktifasiList;
    } else {
      throw Exception('Failed to load aktifasi');
    }
  }

//******getDataPekerjaan*/
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

  // Future<void> pekerjaanHarian(List<String> data) async {
  //   final url = Uri.parse(
  //       '$baseUrl/pekerjaan-harian'); // Ganti dengan endpoint API yang sesuai.
  //   final headers = <String, String>{
  //     'Content-Type':
  //         'application/json', // Sesuaikan dengan format yang digunakan oleh API Anda.
  //   };

  //   final dataJson = jsonEncode(data);

  //   final response = await http.post(url, headers: headers, body: dataJson);

  //   if (response.statusCode == 200) {
  //     if (kDebugMode) {
  //       print('Data pekerjaan harian berhasil disimpan');
  //     }
  //   } else {
  //     throw Exception(
  //         'Gagal menyimpan data pekerjaan harian: ${response.statusCode}');
  //   }
  // }

  Future<void> pekerjaanHarian(List<String> data) async {
    final Uri url = Uri.parse('$baseUrl/tambahkan_pekerjaanHarian.php');

    final List<Map<String, dynamic>> pekerjaanData = [];

    for (String pekerjaanText in data) {
      List<String> splitData = pekerjaanText.split("; ");
      String keypro = splitData[0];
      String date = splitData[1];
      String detailPekerjaan = splitData[2];
      String detailJumlah = splitData[3];
      String detailSatuan = splitData[4];

      pekerjaanData.add({
        'keypro': keypro,
        'date': date,
        'detail_pekerjaan': detailPekerjaan,
        'detail_jumlah': detailJumlah,
        'detail_satuan': detailSatuan,
      });
    }

    final Map<String, dynamic> requestBody = {
      'pekerjaanList': pekerjaanData,
    };

    final response = await http.post(url, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      // Berhasil mengirim data ke server
      if (kDebugMode) {
        print("Berhasil mengirim pekerjaan Harian");
      }
    } else {
      // Terjadi kesalahan saat mengirim data
      if (kDebugMode) {
        print("Terjadi kesalahan saat mengirim data");
      }
      if (kDebugMode) {
        print("Response dari server: ${response.body}");
      }
    }
  }

//******searchPekerjaan*/
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
            satuan: pekerjaanData['satuan'],
          ),
        );
      }

      return pekerjaanList;
    } else {
      throw Exception('Failed to search pekerjaan');
    }
  }

//******tambahkanProject*/
  Future<void> tambahkanProject({
    required String keypro,
    required String nopro,
    required String nmpro,
    required String mulai,
    required String selesai,
    required String nilai,
    required String idclient,
    required String idstatus,
    required String iduser,
  }) async {
    final Uri url = Uri.parse('$baseUrl/add_project.php');

    final Map<String, dynamic> requestBody = {
      'keypro': keypro,
      'nopro': nopro,
      'nmpro': nmpro,
      'mulai': mulai,
      'selesai': selesai,
      'nilai': nilai,
      'idclient': idclient,
      'idstatus': idstatus,
      'iduser': iduser,
    };

    final response = await http.post(url, body: requestBody);

    if (response.statusCode == 200) {
      // Proses respons sesuai kebutuhan Anda
    } else {
      throw Exception('Gagal menambahkan proyek');
    }
  }

//******kirimDataPekerjaan*/
  Future<void> kirimDataPekerjaan(List<String> data) async {
    final Uri url = Uri.parse('$baseUrl/tambahkan_pekerjaan1.php');

    final List<Map<String, dynamic>> pekerjaanData = [];

    for (String pekerjaanText in data) {
      List<String> splitData = pekerjaanText.split("; ");
      String keypro = splitData[0];
      String nopro = splitData[1];
      String detailPekerjaan = splitData[2];

      pekerjaanData.add({
        'keypro': keypro,
        'nopro': nopro,
        'detail_pekerjaan': detailPekerjaan,
      });
    }

    final Map<String, dynamic> requestBody = {
      'pekerjaanList': pekerjaanData,
    };

    final response = await http.post(url, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      // Berhasil mengirim data ke server
      // if (kDebugMode) {
      //   print("Berhasil mengirim data");
      // }
    } else {
      // Terjadi kesalahan saat mengirim data
      if (kDebugMode) {
        print("Terjadi kesalahan saat mengirim data");
      }
      if (kDebugMode) {
        print("Response dari server: ${response.body}");
      }
    }
  }

  // Tambahkan fungsi API lainnya sesuai kebutuhan
}
