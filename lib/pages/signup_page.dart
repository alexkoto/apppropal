// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/pages/signin_page.dart';
import 'package:flutter/material.dart';

import '../components/temp_textformfield.dart';
import '../components/temp_toast.dart';
import '../services/api_services.dart';

class SignupPage extends StatefulWidget {
  final ApiService apiService;
  const SignupPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //**************TextEditingController*************************** */
  final ctrlUsername = TextEditingController();
  final ctrlPassword = TextEditingController();
  final ctrlNamalengkap = TextEditingController();

  //**************TextEditingController*************************** */

  void _register(BuildContext context) async {
    final String namalengkap = ctrlNamalengkap.text;
    final String username = ctrlUsername.text;
    final String password = ctrlPassword.text;

    try {
      // Panggil metode pendaftaran dari ApiService
      // Anda perlu menentukan metode ini sesuai dengan API Anda.
      await widget.apiService.register(username, password, namalengkap);

      // Pendaftaran berhasil, Anda dapat menambahkan tindakan selanjutnya seperti navigasi atau menampilkan pesan.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Pendaftaran berhasil!'),
      //     duration: Duration(seconds: 3),
      //   ),
      // );

      String message = 'Pendaftaran berhasil!';
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

      Future.delayed(const Duration(milliseconds: 1), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SignInPage(
            apiService: widget.apiService,
          ),
        ));
      });
    } catch (e) {
      // Tangani kesalahan yang mungkin terjadi selama pendaftaran
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Pendaftaran gagal: $e'),
      //     duration: Duration(seconds: 3),
      //   ),
      // );
      String message = 'Pendaftaran gagal: $e';
      Color color = Colors.blue;
      // ignore: use_build_context_synchronously
      TempToast().showToast(context, message, color);
    }
  }

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
                Image.asset(
                  'assets/images/user.png',
                  width: 80,
                ),
                const SizedBox(height: 25),

//selamat Datang
                Text(
                  'REGISTER',
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),

                //textfield username
                const SizedBox(height: 25),
                TempTextfield(
                  controller: ctrlNamalengkap,
                  hintText: 'Nama',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

//textfield username
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

                const SizedBox(height: 10),

//Tombol Sigin
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    _register(context);
                  },
                  child: const Text('Daftar'),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignInPage(
                            apiService: widget.apiService,
                          ),
                        ));
                      },
                      child: const Text('Sign In'),
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
