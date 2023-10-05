// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_manpropal/components/temp_microtask_snak.dart';
import 'package:app_manpropal/pages/signup_page.dart';
import 'package:app_manpropal/services/api_services.dart';

import '../components/temp_button.dart';
import '../components/temp_textformfield.dart';
import '../models/model_signin.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  final ApiService apiService;
  const SignInPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
    //*********autologin */
    checkLoginStatus();
  }

//TextEditingController
  final TextEditingController ctrlUsername = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();
  final TextEditingController ctrlNamaLengkap = TextEditingController();

//*********autologin */
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final iduser = prefs.getString('iduser');
    if (iduser != null) {
      navigateToHomePage(prefs);
    }
  }

  Future<void> navigateToHomePage(SharedPreferences prefs) async {
    String message = 'Selamat datang kembali!';
    Color color = Colors.blue;
    AlexMicrotasks().runMicrotask(context, message, color);

    final iduser = prefs.getString('iduser');
    final namalengkap = prefs.getString('namalengkap');
    final username = prefs.getString('username');
    // final password = prefs.getString('password');
    // final idaktifasi = prefs.getString('idaktifasi');
    final idlevel = prefs.getString('idlevel');

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomePage(
        apiService: widget.apiService,
        iduser: iduser!,
        namalengkap: namalengkap!,
        username: username!,
        // password: password!,
        // idaktifasi: idaktifasi!,
        idlevel: idlevel!, onLogout: logOut,
        // onLogout: logOut,
      ),
    ));
  }

//*********autologin */

  Future<void> _signIn(BuildContext context) async {
    try {
      final ModelSignIn signInData = await widget.apiService.signIn(
        ctrlUsername.text,
        ctrlPassword.text,
      );

      // Proses signInData sesuai dengan kebutuhan Anda.
      // Contoh:
      if (signInData.idlevel == "1") {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('iduser', signInData.iduser);
        prefs.setString('namalengkap', signInData.namalengkap);
        prefs.setString('username', signInData.username);
        prefs.setString('password', signInData.password);
        prefs.setString('idaktifasi', signInData.idaktifasi);
        prefs.setString('idlevel', signInData.idlevel);
        prefs.setBool("isLoggedIn", true);
        debugPrint("logsetString : $signInData.iduser");

        String message = 'Selamat datang Admin';
        Color color = Colors.blue;
        AlexMicrotasks().runMicrotask(context, message, color);

        Future.delayed(const Duration(milliseconds: 0), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
              apiService: widget.apiService,
              iduser: signInData.iduser,
              namalengkap: signInData.namalengkap,
              username: signInData.username,
              idlevel: signInData.idlevel, onLogout: logOut,
              // onLogout: logOut,
              // password: signInData.password,
              // idaktifasi: signInData.idaktifasi,
            ),
          ));
        });
      } else if (signInData.idlevel == "2") {
        debugPrint("log :");
        String message = 'Selamat datang User';
        Color color = Colors.blue;

        Future.microtask(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 3),
              backgroundColor: color,
            ),
          );
        });

        Future.delayed(const Duration(milliseconds: 0), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
              apiService: widget.apiService,
              iduser: signInData.iduser,
              username: signInData.username,
              idlevel: signInData.idlevel,
              namalengkap: signInData.namalengkap, onLogout: logOut,
              // onLogout: logOut,
            ),
          ));
        });
      } else {
        debugPrint("log :");
        String message = 'Akun Anda Belum Terdaftar!';
        Color color = Colors.blue;

        Future.microtask(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 3),
              backgroundColor: color,
            ),
          );
        });

        Future.delayed(const Duration(milliseconds: 0), () {});
      }
    } catch (e) {
      String message = "Gagal masuk. Cek kembali username dan password Anda.";
      Color color = Colors.red;
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
            backgroundColor: color,
          ),
        );
      });

      Future.delayed(const Duration(milliseconds: 1), () {});
    }
  }

//**********Logout */
  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('spiduser');
    prefs.remove('spnamalengkap');
    prefs.remove('spusername');
    prefs.remove('sppassword');
    prefs.remove('spidaktifasi');
    prefs.remove('spidlevel');

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SignInPage(apiService: widget.apiService),
    ));
  }
//**********Logout */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    'assets/images/logoPAL2.png',
                  ),
                ),

                const SizedBox(height: 25),
                //selamat Datang
                Text(
                  'Selamat Datang',
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),

                //textfield username
                const SizedBox(height: 25),
                TempTextfield(
                  controller: ctrlUsername,
                  hintText: 'Username',
                  obscureText: false,
                ),

                //textfield Password
                const SizedBox(height: 10),
                TempTextfield(
                  controller: ctrlPassword,
                  hintText: 'Password',
                  obscureText: true,
                ),

                //Lupa Password
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Lupa Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //Tombol Sigin
                const SizedBox(height: 50),
                TempButton(
                  label: 'Sign In',
                  onTap: () async {
                    await _signIn(context);
                    debugPrint("userlog : ${ctrlUsername.text}");
                    debugPrint("passlog : ${ctrlPassword.text}");
                  },
                ),

                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignupPage(apiService: widget.apiService),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
