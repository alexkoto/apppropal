// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // import 'package:app_manpropal/pages/laporan_harian_page.dart';
// // import 'package:app_manpropal/pages/lhp_page.dart';
// import 'package:app_manpropal/pages/admin_drawer.dart';
// import 'package:app_manpropal/pages/clientscreen/client_page.dart';
// import 'package:app_manpropal/pages/laporanscreen/cetak_laporan_page.dart';
// import 'package:app_manpropal/pages/projectscreen/project_page.dart';
// import 'package:app_manpropal/pages/user_drawer.dart';
// import 'package:app_manpropal/pages/userscreen/user_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:app_manpropal/pages/authscreen/signin_page.dart';
// import 'package:app_manpropal/pages/take_image.dart';
// import 'package:app_manpropal/pages/tambah_project.dart';

// import '../services/api_services.dart';

// class HomeAdmin extends StatefulWidget {
//   final ApiService apiService;
//   final String username;
//   final String iduser;
//   final String idlevel;
//   final String namalengkap;
//   final VoidCallback onLogout;

//   const HomeAdmin({
//     Key? key,
//     required this.apiService,
//     required this.username,
//     required this.iduser,
//     required this.idlevel,
//     required this.namalengkap,
//     required this.onLogout,
//   }) : super(key: key);

//   @override
//   State<HomeAdmin> createState() => _HomeAdminState();
// }

// Color _mainDarkColor = const Color(0xff002638);

// class _HomeAdminState extends State<HomeAdmin> {
// //list data
//   List _listdata = [];
//   bool isRefreshing = false;
//   Map<String, dynamic> levelData = {};

//   Future<void> _getPekerjaan() async {
//     await Future.delayed(const Duration(seconds: 2));
//     try {
//       final data =
//           await widget.apiService.getPekerjaan(widget.iduser, widget.idlevel);
//       setState(() {
//         _listdata = data;
//         isRefreshing = false;
//       });
//     } catch (e) {
//       // Handle errors here
//     }
//   }

//   @override
//   void initState() {
//     _getPekerjaan();
//     //untuk cek log

//     super.initState();
//   }

// //************LOGOUT */
//   // Pindahkan fungsi logOut ke dalam HomeAdmin
//   void logOut(context) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove('iduser');
//     prefs.remove('namalengkap');
//     prefs.remove('username');
//     prefs.remove('password');
//     prefs.remove('idaktifasi');
//     prefs.remove('idlevel');

//     // Pindah ke SignInPage dan hapus HomeAdmin dari tumpukan navigasi
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
//     bool isAdmin = (widget.idlevel == '1');

//     return Scaffold(
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
//                   //*********Halaman Client*/
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
//                   onLogout: () {
//                     logOut(context);
//                   },
//                 ),

// //************DrawerScreen */
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         // elevation: 0,
//         // centerTitle: true,
//         title: const Text("Home Page"),
//         leading: Icon(
//           Icons.engineering_rounded,
//           color: _mainDarkColor,
//           size: 50,
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Tambahkan logic logout di sini
//               logOut(context);
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         strokeWidth: CircularProgressIndicator.strokeAlignCenter,
//         onRefresh: () {
//           setState(() {
//             isRefreshing = true;
//           });
//           return _getPekerjaan();
//         },
//         child: ListView.builder(
//             itemCount: _listdata.length,
//             itemBuilder: ((context, index) {
//               return Card(
//                 child: ListTile(
//                   title: Text(_listdata[index]['nmpro']),
//                   subtitle: Text(_listdata[index]['nopro']),
//                   onTap: () {
//                     // Navigasi ke halaman detail dengan membawa data item
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             LaporanHarianPage(itemData: _listdata[index]),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             })),
//       ),

//       floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) =>
//                     TambahProjectPage(apiService: widget.apiService),
//                 // Ganti HalamanTujuan dengan nama halaman yang sesuai.
//               ),
//             );
//           },
//           tooltip: 'Tambahkan Item',
//           child: const Icon(
//             Icons.construction,
//             size: 50.0,
//             color: Colors.black,
//           )),
//     );
//   }
// }
