import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/models/model_clients.dart';
import 'package:app_manpropal/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditClientPage extends StatefulWidget {
  final ApiService apiService;
  final ModelClients client;

  const EditClientPage({
    Key? key,
    required this.apiService,
    required this.client,
  }) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  final _idclientController = TextEditingController();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _picController = TextEditingController();
  final _emailController = TextEditingController();
  final _telpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai awal field dengan data klien yang akan diedit
    _idclientController.text = widget.client.idclient.toString();
    _namaController.text = widget.client.nama;
    _alamatController.text = widget.client.alamat;
    _picController.text = widget.client.pic;
    _emailController.text = widget.client.email;
    _telpController.text = widget.client.telp;
    // if (kDebugMode) {
    //   print(_idclientController.text);
    // }
  }

  Future<void> _updateClient() async {
    try {
      final updatedClient = await widget.apiService.updateClient(
        widget.client.idclient.toString(),
        _namaController.text,
        _alamatController.text,
        _picController.text,
        _emailController.text,
        _telpController.text,
      );

      Navigator.pop(context, updatedClient);
    } catch (e) {
      // Tangani kesalahan jika gagal mengupdate klien
      if (kDebugMode) {
        print("Gagal mengupdate klien: $e");
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
                TempButton(onTap: _updateClient, label: 'Update Client'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
