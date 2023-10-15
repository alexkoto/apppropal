// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // import 'package:app_manpropal/pages/laporan_harian_page.dart';
// // import 'package:app_manpropal/pages/lhp_page.dart';
// import 'package:app_manpropal/constants.dart';
// import 'package:app_manpropal/pages/laporanscreen/laporan_page.dart';
// import 'package:app_manpropal/pages/mainscreen/admin_drawer.dart';
// import 'package:app_manpropal/pages/clientscreen/client_page.dart';
// import 'package:app_manpropal/pages/laporanscreen/cetak_laporan_page.dart';
// import 'package:app_manpropal/pages/mainscreen/components/temp_section_home.dart';
// import 'package:app_manpropal/pages/projectscreen/detail_project_page.dart';

// import 'package:app_manpropal/pages/projectscreen/project_page.dart';
// import 'package:app_manpropal/pages/mainscreen/user_drawer.dart';
// import 'package:app_manpropal/pages/userscreen/user_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:app_manpropal/pages/authscreen/signin_page.dart';

// import '../../services/api_services.dart';

// class HomePage extends StatefulWidget {
//   final ApiService apiService;
//   final String username;
//   final String iduser;
//   final String idlevel;
//   final String namalengkap;
//   final VoidCallback onLogout;

//   const HomePage({
//     Key? key,
//     required this.apiService,
//     required this.username,
//     required this.iduser,
//     required this.idlevel,
//     required this.namalengkap,
//     required this.onLogout,
//   }) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // ignore: prefer_typing_uninitialized_variables
//   var height;
//   // ignore: prefer_typing_uninitialized_variables
//   var width;
// //list data
//   bool isRefreshing = false;
//   Map<String, dynamic> levelData = {};

//   List imgData = [
//     "assets/images/mobil.png",
//     "assets/images/project.png",
//     "assets/images/client.png",
//     "assets/images/tiang.png",
//     "assets/images/report.png",
//     "assets/images/report.png",
//   ];

//   List title = [
//     "In Preparation",
//     "In Progress",
//     "Under Review",
//     "Completed",
//     "Report",
//     "Report",
//   ];

//   @override
//   void initState() {
//     //untuk cek log

//     super.initState();
//   }

// //************LOGOUT */
//   // Pindahkan fungsi logOut ke dalam HomePage
//   void logOut(context) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove('iduser');
//     prefs.remove('namalengkap');
//     prefs.remove('username');
//     prefs.remove('password');
//     prefs.remove('idaktifasi');
//     prefs.remove('idlevel');

//     // Pindah ke SignInPage dan hapus HomePage dari tumpukan navigasi
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SignInPage(apiService: widget.apiService),
//       ),
//     );
//   }

// //************LOGOUT */

//   Future<void> _getLevelById(String idlevel) async {
//     try {
//       final String? level =
//           await widget.apiService.getLevelById(widget.idlevel);
//       if (level != null) {
//         setState(() {
//           levelData = {'level': level};
//         });
//       } else {
//         debugPrint('Level is null');
//       }
//     } catch (e) {
//       debugPrint('Failed to get level: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;

//     bool isAdmin = (widget.idlevel == '1');

//     return Scaffold(
//       backgroundColor: flexSchemeDark.background,

//       drawer:
//           isAdmin // Gunakan properti isAdmin untuk memilih drawer yang sesuai
//               ? AdminDrawer(
//                   apiService: widget.apiService,
//                   iduser: widget.iduser,
//                   username: widget.username,
//                   idlevel: widget.idlevel,
//                   namalengkap: widget.namalengkap,
//                   getLevelById: _getLevelById,
//                   //*Halaman Dashboard******/
//                   onDashboardTap: () {
//                     // Handle action when Dashboard is tapped
//                   },
//                   //*********Halaman Project*/
//                   onProjectManagementTap: () {
//                     // Handle action when Users is tapped
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => ProjectPage(
//                           apiService: widget.apiService,
//                           iduser: widget.iduser,
//                           idlevel: widget.idlevel,
//                         ),
//                         // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//                       ),
//                     );
//                   },
//                   //*********Halaman User*/
//                   onUserManagementTap: () {
//                     // Handle action when Users is tapped
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => UserPage(
//                           apiService: widget.apiService,
//                         ),
//                         // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//                       ),
//                     );
//                   },
//                   //*********Halaman Client*/
//                   onClientManagementTap: () {
//                     // Handle action when Users is tapped
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ClientPage(apiService: widget.apiService),
//                         // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//                       ),
//                     );
//                   },
//                   //*********Halaman Report*/
//                   onLaporanManagementTap: () {
//                     // Handle action when Users is tapped
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const CetakLaporanPage(),
//                         // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//                       ),
//                     );
//                   },
//                   //*********Logout*/
//                   onLogout: () {
//                     logOut(context);
//                   },
//                 )
//               : UserDrawer(
//                   apiService: widget.apiService,
//                   getLevelById: _getLevelById,
//                   iduser: widget.iduser,
//                   username: widget.username,
//                   idlevel: widget.idlevel,
//                   namalengkap: widget.namalengkap,

//                   onDashboardTap: () {
//                     // Handle action when Dashboard is tapped
//                   },
//                   //*********Halaman Project*/
//                   onProjectManagementTap: () {
//                     // Handle action when Users is tapped
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => ProjectPage(
//                           apiService: widget.apiService,
//                           iduser: widget.iduser,
//                           idlevel: widget.idlevel,
//                         ),
//                         // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//                       ),
//                     );
//                   },
//                   //*********Halaman Report*/
//                   onLaporanManagementTap: () {
//                     // Handle action when Users is tapped
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const CetakLaporanPage(),
//                         // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//                       ),
//                     );
//                   },
//                   onLogout: () {
//                     logOut(context);
//                   },
//                 ),

// //************DrawerScreen */

//       body: Container(
//         width: width,
//         color: flexSchemeDark.primaryContainer,
//         child: Column(
//           children: [
//             Container(
//                 decoration: const BoxDecoration(),
//                 // height: height * 0.25,
//                 width: width,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 32,
//                         left: 16,
//                         right: 16,
//                       ),
//                       child: TempHeadHomepage(namalengkap: widget.namalengkap),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 45,
//                         left: 16,
//                         bottom: 5,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Dashboard",
//                             style: TextStyle(
//                                 fontSize: 25,
//                                 color: flexSchemeDark.onBackground,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.25),
//                           ),
//                           Text(
//                             "Sistem Management Project",
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 color: flexSchemeDark.onBackground,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.25),
//                           ),
//                         ],
//                       ),
//                     ),
//                     GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 1.2,
//                         mainAxisSpacing: 5,
//                       ),
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       primary: false,
//                       itemCount: imgData.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             switch (index) {
//                               case 0:
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => DetailProjectPage(
//                                       item: title[index],
//                                       apiService: widget.apiService,
//                                       iduser: widget.iduser,
//                                       idlevel: widget.idlevel,
//                                       idstatus: '1',
//                                     ), // Ganti DetailPage dengan halaman detail yang sesuai
//                                   ),
//                                 );
//                                 break;
//                               case 1:
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => DetailProjectPage(
//                                       item: title[index],
//                                       apiService: widget.apiService,
//                                       iduser: widget.iduser,
//                                       idlevel: widget.idlevel,
//                                       idstatus: '2',
//                                     ), // Ganti DetailPage dengan halaman detail yang sesuai
//                                   ),
//                                 );
//                                 break;
//                               case 2:
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => DetailProjectPage(
//                                       item: title[index],
//                                       apiService: widget.apiService,
//                                       iduser: widget.iduser,
//                                       idlevel: widget.idlevel,
//                                       idstatus: '3',
//                                     ), // Ganti DetailPage dengan halaman detail yang sesuai
//                                   ),
//                                 );
//                                 break;
//                               case 3:
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => DetailProjectPage(
//                                       item: title[index],
//                                       apiService: widget.apiService,
//                                       iduser: widget.iduser,
//                                       idlevel: widget.idlevel,
//                                       idstatus: '4',
//                                     ), // Ganti DetailPage dengan halaman detail yang sesuai
//                                   ),
//                                 );
//                                 break;
//                               case 4:
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => LaporanPage(
//                                       item: title[index],
//                                       apiService: widget.apiService,
//                                       iduser: widget.iduser,
//                                       idlevel: widget.idlevel,
//                                     ), // Ganti DetailPage dengan halaman detail yang sesuai
//                                   ),
//                                 );
//                                 break;
//                               case 5:
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => LaporanPage(
//                                       item: title[index],
//                                       apiService: widget.apiService,
//                                       iduser: widget.iduser,
//                                       idlevel: widget.idlevel,
//                                     ), // Ganti DetailPage dengan halaman detail yang sesuai
//                                   ),
//                                 );
//                                 break;
//                             }
//                           },
//                           // child:

//                           // Container(
//                           //   margin: const EdgeInsets.symmetric(
//                           //     vertical: 35,
//                           //     horizontal: 35,
//                           //   ),
//                           //   decoration: BoxDecoration(
//                           //     borderRadius: BorderRadius.circular(20),
//                           //     color: outlineVariantColor,
//                           //     boxShadow: const [
//                           //       BoxShadow(
//                           //         color: Colors.black26,
//                           //         spreadRadius: 1,
//                           //         blurRadius: 6,
//                           //       )
//                           //     ],
//                           //   ),
//                           //   child: Column(
//                           //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           //     children: [
//                           //       Image.asset(
//                           //         imgData[index],
//                           //         width: 30,
//                           //       ),
//                           //       Text(
//                           //         title[index],
//                           //         style: const TextStyle(
//                           //           fontSize: 12,
//                           //           fontWeight: FontWeight.bold,
//                           //         ),
//                           //       )
//                           //     ],
//                           //   ),
//                           // ),

//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Card(
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Image.asset(
//                                     imgData[index],
//                                     width: 30,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       title[index],
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 )),
//             SizedBox(
//               height: height * 0.05,
//               width: width,
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "PT.PRISAN ARTHA LESTARI",
//                     style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "2023",
//                     style: TextStyle(fontSize: 10),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
