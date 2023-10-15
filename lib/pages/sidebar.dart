// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/pages/laporanscreen/cetak_laporan_page.dart';
import 'package:app_manpropal/pages/clientscreen/client_page.dart';
import 'package:app_manpropal/pages/projectscreen/tambah_project.dart';
import 'package:app_manpropal/pages/userscreen/user_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class DrawerScreen extends StatefulWidget {
  final ApiService apiService;
  final String iduser;
  final String username;
  final String idlevel; // Menggunakan tipe data int
  final String namalengkap;
  const DrawerScreen({
    Key? key,
    required this.apiService,
    required this.iduser,
    required this.username,
    required this.idlevel,
    required this.namalengkap,
  }) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Map<String, dynamic> levelData = {};

  @override
  void initState() {
    super.initState();
    _getLevelById(widget.idlevel);
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
      debugPrint('Failed to get level: $e');
    }
  }

  final List drawerMenuListname = const [
    {
      "leading": Image(
        image: AssetImage('assets/images/project.png'),
        height: 30,
      ),
      "title": "Projects",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 1,
    },
    {
      "leading": Image(
        image: AssetImage('assets/images/project-management.png'),
        height: 30,
      ),
      "title": "Laporan",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 2,
    },
    {
      "leading": Image(
        image: AssetImage('assets/images/user.png'),
        // color: Color(0xFF13C0E3),
        height: 30,
      ),
      "title": "Users",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 3,
    },
    {
      "leading": Image(
        image: AssetImage('assets/images/client.png'),
        height: 30,
      ),
      "title": "Clients",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 4,
    },
    {
      "leading": Image(
        image: AssetImage('assets/images/newproject.png'),
        height: 30,
      ),
      "title": "New Project",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 5,
    },
    {
      "leading": Image(
        image: AssetImage('assets/images/no-charges.png'),
        height: 30,
      ),
      "title": "Sign Out",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 280,
        child: Drawer(
          child: ListView(
            children: [
              ListTile(
                // leading: CircleAvatar(
                leading: Image.asset('assets/images/Clogo.png'),
                title: Text(
                  widget.namalengkap,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Text('Level: ${levelData['level']}'),
              ),
              const SizedBox(
                height: 1,
              ),
              ...drawerMenuListname.map((sideMenuData) {
                return ListTile(
                  leading: sideMenuData['leading'],
                  title: Text(
                    sideMenuData['title'],
                  ),
                  trailing: sideMenuData['trailing'],
                  onTap: () {
                    Navigator.pop(context);
                    if (sideMenuData['action_id'] == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              TambahProjectPage(apiService: widget.apiService),
                          // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                        ),
                      );
                    } else if (sideMenuData['action_id'] == 2) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CetakLaporanPage(),
                          // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                        ),
                      );
                    } else if (sideMenuData['action_id'] == 3) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserPage(
                            apiService: widget.apiService,
                          ),
                          // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                        ),
                      );
                    } else if (sideMenuData['action_id'] == 4) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ClientPage(apiService: widget.apiService),
                          // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
