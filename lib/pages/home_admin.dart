import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeAdmin extends StatefulWidget {
  final String username;
  final String iduser;
  final String idlevel;
  final String namalengkap;

  const HomeAdmin({
    Key? key,
    required this.username,
    required this.iduser,
    required this.idlevel,
    required this.namalengkap,
  }) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

Color _mainDarkColor = const Color(0xff002638);

class _HomeAdminState extends State<HomeAdmin> {
  //list data
  List _listdata = [];
  // buat loodingnya
  bool _isloading = true;

  Future<void> _getPekerjaan() async {
    try {
      final url = Uri.parse("https://prisan.co.id/app_propal/pro.php");
      final response = await http.post(url, body: {
        "iduser": widget.iduser,
        "idlevel": widget.idlevel,
      });

      if (response.statusCode == 200) {
        // if (kDebugMode) {
        //   print(response.body);
        // }
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
          // startloading;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.engineering_rounded,
          color: _mainDarkColor,
          size: 50,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Home Admin",
                  style: TextStyle(
                      color: _mainDarkColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.namalengkap,
                  style: TextStyle(color: _mainDarkColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_listdata[index]['Project_Name']),
                    subtitle: Text(_listdata[index]['no_kontrak']),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,

        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         const ProjectTambah(), // Ganti HalamanTujuan dengan nama halaman yang sesuai.
          //   ),
          // );
        },
        tooltip: 'Tambahkan Item',
        // child: const Icon(Icons.add),
        child: Image.asset('assets/images/newproject.png'),
      ),
    );
  }
}
