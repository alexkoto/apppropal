import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/models/model_aktifasi.dart';
import 'package:app_manpropal/models/model_level.dart';
import 'package:app_manpropal/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  final ApiService apiService;

  const AddUserPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

// class _SignInPageState extends State<SignInPage>
class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idaktifasiController = TextEditingController();
  final TextEditingController _idlevelController = TextEditingController();

  List<ModelLevels> levels = [];
  int? selectedLevel;
  List<ModelAktifasis> dataAktifasi = [];
  int? selectedAktifasi;
  Future<void> _tambahUser() async {
    try {
      final newUser = await widget.apiService.addUser(
          _namalengkapController.text,
          _usernameController.text,
          _passwordController.text,
          _idaktifasiController.text,
          _idlevelController.text);

      Navigator.pop(context, true);
    } catch (e) {
      // Tangani kesalahan jika gagal mengupdate klien
      if (kDebugMode) {
        print("Gagal menambahkan klien: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLevel();
    _loadAktifasi();
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
                    textInputType: TextInputType.visiblePassword,
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
                  TempDropdown(
                    labelText: 'Level User',
                    value: selectedLevel,
                    onChange: (int? newValue) {
                      setState(() {
                        selectedLevel = newValue;
                        _idlevelController.text = newValue.toString();
                      });
                    },
                    items: levels.map((ModelLevels levelId) {
                      final int idkategori = int.tryParse(levelId.idlevel) ?? 0;
                      return DropdownMenuItem<int>(
                        value: idkategori,
                        child: Text(levelId.level),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  TempButton(onTap: _tambahUser, label: 'Tambah User'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
