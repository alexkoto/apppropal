// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:app_manpropal/pages/laporan_harian_page.dart';
// import 'package:app_manpropal/pages/lhp_page.dart';
import 'package:app_manpropal/constants.dart';
import 'package:app_manpropal/pages/laporanscreen/laporan_page.dart';
import 'package:app_manpropal/pages/mainscreen/admin_drawer.dart';
import 'package:app_manpropal/pages/clientscreen/client_page.dart';
import 'package:app_manpropal/pages/laporanscreen/cetak_laporan_page.dart';
import 'package:app_manpropal/pages/mainscreen/components/home_page_title.dart';
import 'package:app_manpropal/pages/mainscreen/components/temp_footer.dart';
import 'package:app_manpropal/pages/mainscreen/components/temp_section_home.dart';
import 'package:app_manpropal/pages/projectscreen/detail_project_page.dart';

import 'package:app_manpropal/pages/projectscreen/project_page.dart';
import 'package:app_manpropal/pages/mainscreen/user_drawer.dart';
import 'package:app_manpropal/pages/userscreen/user_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_manpropal/pages/authscreen/signin_page.dart';

import '../../services/api_services.dart';

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

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var height;
  // ignore: prefer_typing_uninitialized_variables
  var width;
//list data
  bool isRefreshing = false;
  Map<String, dynamic> levelData = {};

  List imgData = [
    "assets/images/mobil.png",
    "assets/images/project.png",
    "assets/images/client.png",
    "assets/images/tiang.png",
    "assets/images/report.png",
  ];

  List title = [
    "In Preparation",
    "In Progress",
    "Under Review",
    "Completed",
    "Report",
  ];

  @override
  void initState() {
    //untuk cek log

    super.initState();
  }

//************LOGOUT */
  // Pindahkan fungsi logOut ke dalam HomePage
  void logOut(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('iduser');
    prefs.remove('namalengkap');
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('idaktifasi');
    prefs.remove('idlevel');

    // Pindah ke SignInPage dan hapus HomePage dari tumpukan navigasi
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    bool isAdmin = (widget.idlevel == '1');

    return Scaffold(
      backgroundColor: flexSchemeLight.background,
      drawer:
          isAdmin // Gunakan properti isAdmin untuk memilih drawer yang sesuai
              ? AdminDrawer(
                  apiService: widget.apiService,
                  iduser: widget.iduser,
                  username: widget.username,
                  idlevel: widget.idlevel,
                  namalengkap: widget.namalengkap,
                  getLevelById: _getLevelById,
                  //*Halaman Dashboard******/
                  onDashboardTap: () {
                    // Handle action when Dashboard is tapped
                  },
                  //*********Halaman Project*/
                  onProjectManagementTap: () {
                    // Handle action when Users is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProjectPage(
                          apiService: widget.apiService,
                          iduser: widget.iduser,
                          idlevel: widget.idlevel,
                        ),
                        // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                      ),
                    );
                  },
                  //*********Halaman User*/
                  onUserManagementTap: () {
                    // Handle action when Users is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserPage(
                          apiService: widget.apiService,
                        ),
                        // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                      ),
                    );
                  },
                  //*********Halaman Client*/
                  onClientManagementTap: () {
                    // Handle action when Users is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientPage(apiService: widget.apiService),
                        // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                      ),
                    );
                  },
                  //*********Halaman Report*/
                  onLaporanManagementTap: () {
                    // Handle action when Users is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CetakLaporanPage(),
                        // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                      ),
                    );
                  },
                  //*********Logout*/
                  onLogout: () {
                    logOut(context);
                  },
                )
              : UserDrawer(
                  apiService: widget.apiService,
                  getLevelById: _getLevelById,
                  iduser: widget.iduser,
                  username: widget.username,
                  idlevel: widget.idlevel,
                  namalengkap: widget.namalengkap,

                  onDashboardTap: () {
                    // Handle action when Dashboard is tapped
                  },
                  //*********Halaman Project*/
                  onProjectManagementTap: () {
                    // Handle action when Users is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProjectPage(
                          apiService: widget.apiService,
                          iduser: widget.iduser,
                          idlevel: widget.idlevel,
                        ),
                        // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                      ),
                    );
                  },
                  //*********Halaman Report*/
                  onLaporanManagementTap: () {
                    // Handle action when Users is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CetakLaporanPage(),
                        // Ganti HalamanTujuan dengan nama halaman yang sesuai.
                      ),
                    );
                  },
                  onLogout: () {
                    logOut(context);
                  },
                ),

//************DrawerScreen */
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        backgroundColor: flexSchemeLight.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TempHeadHomepage(
              namalengkap: widget.namalengkap,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: HomePageTitle(
                judul: 'Dashboard', subjudul: 'Sistem Manajemen Kerja'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Status Project'),
                  Container(
                    decoration: BoxDecoration(
                      color: flexSchemeLight.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        // bottom: 10,
                        ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 2,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: imgData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            //   switch (index) {
                            //     case 0:
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => DetailProjectPage(
                            //             item: title[index],
                            //             apiService: widget.apiService,
                            //             iduser: widget.iduser,
                            //             idlevel: widget.idlevel,
                            //             idstatus: '1',
                            //           ), // Ganti DetailPage dengan halaman detail yang sesuai
                            //         ),
                            //       );
                            //       break;
                            //     case 1:
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => DetailProjectPage(
                            //             item: title[index],
                            //             apiService: widget.apiService,
                            //             iduser: widget.iduser,
                            //             idlevel: widget.idlevel,
                            //             idstatus: '2',
                            //           ), // Ganti DetailPage dengan halaman detail yang sesuai
                            //         ),
                            //       );
                            //       break;
                            //     case 2:
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => DetailProjectPage(
                            //             item: title[index],
                            //             apiService: widget.apiService,
                            //             iduser: widget.iduser,
                            //             idlevel: widget.idlevel,
                            //             idstatus: '3',
                            //           ), // Ganti DetailPage dengan halaman detail yang sesuai
                            //         ),
                            //       );
                            //       break;
                            //     case 3:
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => DetailProjectPage(
                            //             item: title[index],
                            //             apiService: widget.apiService,
                            //             iduser: widget.iduser,
                            //             idlevel: widget.idlevel,
                            //             idstatus: '4',
                            //           ), // Ganti DetailPage dengan halaman detail yang sesuai
                            //         ),
                            //       );
                            //       break;
                            //     case 4:
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => LaporanPage(
                            //             item: title[index],
                            //             apiService: widget.apiService,
                            //             iduser: widget.iduser,
                            //             idlevel: widget.idlevel,
                            //             idstatus: '5',
                            //           ), // Ganti DetailPage dengan halaman detail yang sesuai
                            //         ),
                            //       );
                            //       break;
                            //   }
                            //
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: flexSchemeLight.outlineVariant,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  imgData[index],
                                  width: 30,
                                ),
                                Text(
                                  title[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Fotter()
        ],
      ),
    );
  }
}
