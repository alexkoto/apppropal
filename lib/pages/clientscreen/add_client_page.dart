import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddClientPage extends StatefulWidget {
  final ApiService apiService;

  const AddClientPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _picController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();

  Future<void> _tambahClient() async {
    try {
      final newClient = await widget.apiService.addClient(
          _namaController.text,
          _alamatController.text,
          _picController.text,
          _emailController.text,
          _telpController.text);

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      // Tangani kesalahan jika gagal mengupdate klien
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TempFormfieldInput(
                    controller: _namaController,
                    labelText: 'Nama Client',
                    textInputType: TextInputType.name,
                    enable: true,
                  ),
                  const SizedBox(height: 16.0),
                  TempFormfieldInput(
                    controller: _alamatController,
                    labelText: 'Alamat',
                    textInputType: TextInputType.streetAddress,
                    enable: true,
                  ),
                  const SizedBox(height: 16.0),
                  TempFormfieldInput(
                    controller: _emailController,
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    enable: true,
                  ),
                  const SizedBox(height: 16.0),
                  TempFormfieldInput(
                    controller: _telpController,
                    labelText: 'Telepon',
                    textInputType: TextInputType.phone,
                    enable: true,
                  ),
                  const SizedBox(height: 16.0),
                  TempFormfieldInput(
                    controller: _picController,
                    labelText: 'Gambar',
                    textInputType: TextInputType.url,
                    enable: true,
                  ),
                  const SizedBox(height: 16.0),
                  TempButton(onTap: _tambahClient, label: 'Tambah Client'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
