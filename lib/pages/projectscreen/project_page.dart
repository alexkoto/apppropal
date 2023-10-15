import 'package:app_manpropal/models/model_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_manpropal/pages/projectscreen/laporan_harian_page.dart';
import 'package:app_manpropal/pages/projectscreen/tambah_project.dart';
import 'package:app_manpropal/services/api_services.dart';

import '../../constants.dart';

class ProjectPage extends StatefulWidget {
  final ApiService apiService;
  final String iduser;
  final String idlevel;

  const ProjectPage({
    Key? key,
    required this.apiService,
    required this.iduser,
    required this.idlevel,
  }) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late String iduserToFind; // Ganti dengan ID user yang ingin Anda cari
  late Future<ModelUsers?> userFuture;

//list data
  List _listdata = [];

  bool isRefreshing = false;
  Map<String, dynamic> levelData = {};

  Future<void> _getPekerjaan() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final data =
          await widget.apiService.getPekerjaan(widget.iduser, widget.idlevel);
      setState(() {
        _listdata = data;
        isRefreshing = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> _getLevelById(String idlevel) async {
    try {
      final String? level =
          await widget.apiService.getLevelById(widget.idlevel);
      if (level != null) {
        setState(() {
          levelData = {'level': level};
        });
      } else {
        debugPrint('Level is null');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<ModelUsers?> _getUserById(String iduser) async {
    try {
      final user = await widget.apiService.getUserById(iduser);
      return user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  int hitungJumlahHari(String selesaiDateString) {
    DateTime selesaiDate = DateTime.parse(selesaiDateString);
    Duration difference = selesaiDate.difference(DateTime.now());
    return difference.inDays;
  }

  @override
  void initState() {
    iduserToFind = ''; // Inisialisasi iduserToFind di sini
    _getPekerjaan();
    _getLevelById(widget.idlevel);
    userFuture = _getUserById(iduserToFind);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: flexSchemeLight.background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 3 * defaultVer,
        automaticallyImplyLeading: false,
        backgroundColor: flexSchemeLight.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Project',
                style: TextStyle(
                    color: flexSchemeLight.onBackground,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            Divider(
              color: flexSchemeLight.onSurface,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          strokeWidth: CircularProgressIndicator.strokeAlignCenter,
          onRefresh: () {
            setState(() {
              isRefreshing = true;
            });
            return _getPekerjaan();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: _listdata.length,
                itemBuilder: ((context, index) {
                  iduserToFind = _listdata[index]['iduser'].toString();
                  userFuture = _getUserById(iduserToFind);
                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Navigasi ke halaman detail
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LaporanHarianPage(
                              itemData: _listdata[index],
                              apiService: widget.apiService,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: flexSchemeLight.outlineVariant,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: flexSchemeLight.outline,
                            style: BorderStyle.solid,
                            strokeAlign: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _listdata[index]['nmpro'],
                              style: TextStyle(
                                color: flexSchemeLight.onBackground,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Divider(
                              color: flexSchemeLight.outline,
                              thickness: 1,
                            ),
                            Text(
                              'Nomor : ${_listdata[index]['nopro']}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Serah Terima : ${_listdata[index]['selesai']}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Batas Waktu Penyelesaian : ${hitungJumlahHari(_listdata[index]['selesai'])} hari',
                              style: TextStyle(
                                  color: hitungJumlahHari(
                                              _listdata[index]['selesai']) >
                                          7
                                      ? Colors.blue
                                      : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            FutureBuilder<ModelUsers?>(
                              future: userFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData) {
                                  return const Text('User not found');
                                } else {
                                  final user = snapshot.data!;
                                  return Text(
                                    'supervisi: ${user.namalengkap}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    TambahProjectPage(apiService: widget.apiService),
                // Ganti HalamanTujuan dengan nama halaman yang sesuai.
              ),
            );
          },
          tooltip: 'Tambahkan Item',
          child: const Icon(
            Icons.add_business_outlined,
            size: 50.0,
            color: Colors.black,
          )),
    );
  }
}
