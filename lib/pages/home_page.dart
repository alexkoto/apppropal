// import 'package:app_manpropal/pages/laporan_harian_page.dart';
// import 'package:app_manpropal/pages/lhp_page.dart';
import 'package:app_manpropal/pages/take_image.dart';

import 'package:app_manpropal/pages/signin_page.dart';
import 'package:app_manpropal/pages/tambah_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:app_manpropal/pages/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  final ApiService apiService;
  final String username;
  final String iduser;
  final String idlevel;
  final String namalengkap;
  final VoidCallback onLogout;
  const HomePage({
    Key? key,
    required this.apiService,
    required this.username,
    required this.iduser,
    required this.idlevel,
    required this.namalengkap,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

Color _mainDarkColor = const Color(0xff002638);

class _HomePageState extends State<HomePage> {
//list data
  List _listdata = [];

  bool isRefreshing = false;

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
      // Handle errors here
    }
  }

  @override
  void initState() {
    _getPekerjaan();
    //untuk cek log
    if (kDebugMode) {
      print(_listdata);
    }
    super.initState();
  }

//************LOGOUT */
  void logOut(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('iduser');
    prefs.remove('namalengkap');
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('idaktifasi');
    prefs.remove('idlevel');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(apiService: widget.apiService),
      ),
    );
  }
//************LOGOUT */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//************DrawerScreen */
      drawer: DrawerScreen(
        apiService: widget.apiService,
        iduser: widget.iduser,
        username: widget.username,
        idlevel: int.parse(widget.idlevel),
        namalengkap: widget.namalengkap,
      ),
//************DrawerScreen */
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // elevation: 0,
        // centerTitle: true,
        title: const Text("Home Page"),
        leading: Icon(
          Icons.engineering_rounded,
          color: _mainDarkColor,
          size: 50,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Tambahkan logic logout di sini
              logOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
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
                child: ListTile(
                  title: Text(_listdata[index]['nmpro']),
                  subtitle: Text(_listdata[index]['nopro']),
                  onTap: () {
                    // Navigasi ke halaman detail dengan membawa data item
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LaporanHarianPage(itemData: _listdata[index]),
                      ),
                    );
                  },
                ),
              );
            })),
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
            Icons.construction,
            size: 50.0,
            color: Colors.black,
          )),
    );
  }
}
