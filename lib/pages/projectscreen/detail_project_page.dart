// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:app_manpropal/pages/laporan_harian_page.dart';
// import 'package:app_manpropal/pages/lhp_page.dart';
import 'package:app_manpropal/constants.dart';
import 'package:app_manpropal/pages/projectscreen/laporan_harian_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_manpropal/pages/authscreen/signin_page.dart';
import 'package:app_manpropal/services/api_services.dart';

class DetailProjectPage extends StatefulWidget {
  final String item; // Sesuaikan tipe data dengan data yang ingin ditampilkan
  final ApiService apiService;
  final String iduser;
  final String idlevel;
  final String idstatus;

  const DetailProjectPage({
    Key? key,
    required this.item,
    required this.apiService,
    required this.iduser,
    required this.idlevel,
    required this.idstatus,
  }) : super(key: key);

  @override
  State<DetailProjectPage> createState() => _DetailProjectPageState();
}

class _DetailProjectPageState extends State<DetailProjectPage> {
//list data
  List _listdata = [];
  bool isRefreshing = false;
  Map<String, dynamic> levelData = {};

  Future<void> _getPekerjaan() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final data = await widget.apiService
          .getPekerjaanByStatus(widget.iduser, widget.idlevel, widget.idstatus);
      setState(() {
        _listdata = data;
        isRefreshing = false;
      });
    } catch (e) {
      // Handle errors here
    }
  }

  @override
  void initState() {
    _getPekerjaan();

    //untuk cek log

    super.initState();
  }

//************LOGOUT */
  // Pindahkan fungsi logOut ke dalam DetailProjectPage
  void logOut(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('iduser');
    prefs.remove('namalengkap');
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('idaktifasi');
    prefs.remove('idlevel');

    // Pindah ke SignInPage dan hapus DetailProjectPage dari tumpukan navigasi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(apiService: widget.apiService),
      ),
    );
  }

//************LOGOUT */

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
      debugPrint('Failed to get level: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = (widget.idlevel == '1');

    return Scaffold(
//************DrawerScreen */
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.item),
      ),
      body: RefreshIndicator(
        strokeWidth: CircularProgressIndicator.strokeAlignCenter,
        onRefresh: () {
          setState(() {
            isRefreshing = true;
          });
          return _getPekerjaan();
        },
        child: ListView.builder(
          itemCount: _listdata.length,
          itemBuilder: ((context, index) {
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
                    color: flexSchemeLight.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Pekerjaan : ' + _listdata[index]['nmpro'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Colors.black45,
                        thickness: 1,
                      ),
                      Text(
                        'Nomor : ' + _listdata[index]['nopro'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Serah Terima : ' + _listdata[index]['selesai'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
