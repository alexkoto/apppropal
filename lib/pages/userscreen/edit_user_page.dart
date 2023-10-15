// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/models/model_aktifasi.dart';
import 'package:app_manpropal/models/model_level.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/models/model_user.dart';
import 'package:app_manpropal/services/api_services.dart';

class EditUserPage extends StatefulWidget {
  final ApiService apiService;
  final ModelUsers dataUser;

  const EditUserPage({
    Key? key,
    required this.apiService,
    required this.dataUser,
  }) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController _iduserController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idaktifasiController = TextEditingController();
  final TextEditingController _idlevelController = TextEditingController();

  List<ModelLevels> levels = [];
  int? selectedLevel;
  List<ModelAktifasis> dataAktifasi = [];
  int? selectedAktifasi;

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai awal field dengan data klien yang akan diedit
    _iduserController.text = widget.dataUser.iduser;
    _usernameController.text = widget.dataUser.username;
    _namalengkapController.text = widget.dataUser.namalengkap;
    _passwordController.text = widget.dataUser.password;
    _idaktifasiController.text = widget.dataUser.idaktifasi;
    _idlevelController.text = widget.dataUser.idlevel;
    _loadLevel();
    _loadAktifasi();
    if (kDebugMode) {
      print(_iduserController.text);
    }
  }

  Future<void> _loadLevel() async {
    try {
      final loadedLevels = await widget.apiService.getLevels();
      setState(() {
        levels = loadedLevels;
      });
    } catch (e) {
      // Tangani kesalahan saat mengambil data pengguna.
    }
  }

  Future<void> _loadAktifasi() async {
    try {
      final loadedAktifasi = await widget.apiService.getAktifasis();
      setState(() {
        dataAktifasi = loadedAktifasi;
      });
    } catch (e) {
      // Tangani kesalahan saat mengambil data pengguna.
    }
  }

  Future<void> _updateUser() async {
    try {
      final updatedUser = await widget.apiService.updateUser(
        widget.dataUser.iduser,
        _namalengkapController.text,
        _usernameController.text,
        _passwordController.text,
        _idaktifasiController.text,
        _idlevelController.text,
      );

      Navigator.pop(context, updatedUser);
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
                  controller: _namalengkapController,
                  labelText: 'Nama Lengkap',
                  textInputType: TextInputType.streetAddress,
                  enable: true,
                ),
                const SizedBox(height: 16.0),
                TempFormfieldInput(
                  controller: _usernameController,
                  labelText: 'Username',
                  textInputType: TextInputType.name,
                  enable: true,
                ),
                const SizedBox(height: 16.0),
                TempFormfieldInput(
                  controller: _passwordController,
                  labelText: 'Password',
                  textInputType: TextInputType.emailAddress,
                  enable: true,
                ),
                const SizedBox(height: 16.0),
                TempDropdown(
                  labelText: 'Aktifasi User',
                  value: selectedAktifasi,
                  onChange: (int? newValue) {
                    setState(() {
                      selectedAktifasi = newValue;
                      _idaktifasiController.text = newValue.toString();
                    });
                  },
                  items: dataAktifasi.map((ModelAktifasis dataAktifasi) {
                    final int idAktifasi =
                        int.tryParse(dataAktifasi.idaktifasi) ?? 0;
                    return DropdownMenuItem<int>(
                      value: idAktifasi,
                      child: Text(dataAktifasi.aktifasi),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                TempButton(onTap: _updateUser, label: 'Update User'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
