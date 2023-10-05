// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:app_manpropal/pages/home_page.dart';
import 'package:app_manpropal/pages/signin_page.dart';

import 'services/api_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService(baseUrl: 'https://prisan.co.id/app_propal');

  // Periksa apakah ada data login yang tersimpan
  final iduser = prefs.getString('iduser');
  debugPrint("userlogid : $iduser");
  final spnamalengkap = prefs.getString('namalengkap');
  final username = prefs.getString('username');
  final password = prefs.getString('password');
  final idaktifasi = prefs.getString('idaktifasi');
  final idlevel = prefs.getString('idlevel');

  runApp(MyApp(
    apiService: apiService,
    iduser: iduser,
    namalengkap: spnamalengkap,
    username: username,
    password: password,
    idaktifasi: idaktifasi,
    idlevel: idlevel,
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final String? iduser;
  final String? namalengkap;
  final String? username;
  final String? password;
  final String? idaktifasi;
  final String? idlevel;
  final Function? logout;

  const MyApp({
    Key? key,
    required this.apiService,
    this.iduser,
    this.namalengkap,
    this.username,
    this.password,
    this.idaktifasi,
    this.idlevel,
    this.logout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: iduser != null
          ? HomePage(
              apiService: apiService,
              iduser: iduser.toString(),
              username: username.toString(),
              idlevel: idlevel.toString(),
              namalengkap: "${namalengkap}saaa", onLogout: () {},
              // onLogout: onLogout,
            )
          : SignInPage(apiService: apiService),
      // Tentukan rute awal di dalam MaterialApp
      // initialRoute: iduser != null ? '/home' : '/signin',
      // routes: {
      //   '/signin': (context) => SignInPage(apiService: apiService),
      //   '/home': (context) => HomePage(
      //         apiService: apiService,
      //         iduser: iduser ?? '',
      //         username: username ?? '',
      //         namalengkap: namalengkap ?? '',
      //         idlevel: idlevel ?? '',
      //         onLogout: () {},
      //       ),
      // },
      builder: EasyLoading.init(),
    );
  }
}
