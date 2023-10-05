import 'package:app_manpropal/models/model_clients.dart';
import 'package:app_manpropal/models/model_data_pekerjaan.dart';
import 'package:app_manpropal/models/model_statuspro.dart';
import 'package:app_manpropal/models/model_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../services/api_services.dart';

class TambahProjectPage extends StatefulWidget {
  final ApiService apiService;

  const TambahProjectPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  _TambahProjectPageState createState() => _TambahProjectPageState();
}

class _TambahProjectPageState extends State<TambahProjectPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _nilaiController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _statusIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();

  String newProjectStartDate = '';
  String newProjectEndDate = '';

  List<ModelUsers> users = [];
  List<ModelClients> clients = [];
  int? selectedUserId;
  int? selectedClientId;
  int? selectedStatusProId;
  List<ModelStatuspro> statusProList = [];

  // Variabel untuk menyimpan daftar controller dan pekerjaan
  List<TextEditingController> pekerjaanControllers = [TextEditingController()];
  List<ModelDataPekerjaan?> selectedPekerjaan = [null];

  Future<void> _tambahkanProject() async {
    try {
      // Mengambil semua pekerjaan yang telah dipilih
      final List<String> selectedPekerjaanTexts = selectedPekerjaan
          .map((pekerjaan) => pekerjaan?.pekerjaan ?? '')
          .toList();

      await widget.apiService.tambahkanProject(
        nmpro: _namaController.text,
        nopro: _nomorController.text,
        mulai: _startDateController.text,
        selesai: _endDateController.text,
        nilai: _nilaiController.text,
        idclient: _clientIdController.text,
        idstatus: _statusIdController.text,
        iduser: _userIdController.text,
        // pekerjaan: selectedPekerjaanTexts,
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan proyek. Coba lagi.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadClients();
    _loadStatusPro();
  }

  Future<void> _loadUsers() async {
    try {
      final loadedUsers = await widget.apiService.getUsers();
      setState(() {
        users = loadedUsers;
      });
    } catch (e) {
      // Tangani kesalahan saat mengambil data pengguna.
    }
  }

  Future<void> _loadClients() async {
    try {
      final loadedClients = await widget.apiService.getClients();
      setState(() {
        clients = loadedClients;
      });
    } catch (e) {
      // Tangani kesalahan saat mengambil data klien.
    }
  }

  Future<void> _loadStatusPro() async {
    try {
      final loadedStatusPro = await widget.apiService.getStatusPro();
      setState(() {
        statusProList = loadedStatusPro;
      });
    } catch (e) {
      // Tangani kesalahan saat mengambil data statuspro.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambahkan Project Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Project',
                labelStyle: TextStyle(fontSize: 14.0),
              ),
              style: TextStyle(fontSize: 12.0),
            ),
            TextFormField(
              controller: _nomorController,
              decoration: const InputDecoration(
                labelText: 'SPK/SPBJ/WO/Kode Project',
                labelStyle: TextStyle(fontSize: 14.0),
              ),
              style: TextStyle(fontSize: 12.0),
            ),
            const SizedBox(height: 14.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Mulai',
                      labelStyle: TextStyle(fontSize: 14.0),
                    ),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (selectedDate != null) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        setState(() {
                          _startDateController.text = formattedDate;
                          newProjectStartDate = formattedDate;
                        });
                      }
                    },
                    readOnly: true,
                    controller: _startDateController,
                  ),
                ),
                const SizedBox(width: 16.0), // Jarak antara kedua input
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Selesai',
                      labelStyle: TextStyle(fontSize: 14.0),
                    ),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (selectedDate != null) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        setState(() {
                          _endDateController.text = formattedDate;
                          newProjectEndDate = formattedDate;
                        });
                      }
                    },
                    readOnly: true,
                    controller: _endDateController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nilaiController,
              decoration: const InputDecoration(
                labelText: 'Nilai',
                labelStyle: TextStyle(fontSize: 14.0),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 12.0),
            ),
            const SizedBox(height: 16.0),
            // Daftar input Pilih Pekerjaan
            Column(
              children: List.generate(pekerjaanControllers.length, (index) {
                return Row(
                  children: [
                    Expanded(
                      child: TypeAheadFormField<ModelDataPekerjaan>(
                        textFieldConfiguration: TextFieldConfiguration(
                          maxLines: null,
                          controller: pekerjaanControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Pilih Pekerjaan ${index + 1}',
                            labelStyle: TextStyle(fontSize: 14.0),
                          ),
                          style: TextStyle(fontSize: 12.0),
                        ),
                        suggestionsCallback: (pattern) async {
                          final List<ModelDataPekerjaan> suggestions =
                              await widget.apiService.searchPekerjaan(pattern);
                          return suggestions;
                        },
                        itemBuilder: (context, ModelDataPekerjaan suggestion) {
                          return ListTile(
                            title: Text(suggestion.pekerjaan),
                          );
                        },
                        onSuggestionSelected: (ModelDataPekerjaan suggestion) {
                          setState(() {
                            pekerjaanControllers[index].text =
                                suggestion.pekerjaan;
                            selectedPekerjaan[index] = suggestion;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih pekerjaan';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          pekerjaanControllers.removeAt(index);
                          selectedPekerjaan.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pekerjaanControllers.add(TextEditingController());
                  selectedPekerjaan.add(null);
                });
              },
              child: Text('Tambah Pekerjaan'),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Pilih ID Client',
                labelStyle: TextStyle(fontSize: 14.0),
              ),
              value: selectedClientId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedClientId = newValue;
                  _clientIdController.text = newValue.toString();
                });
              },
              items: clients.map((ModelClients client) {
                final int idclient = int.tryParse(client.idclient) ?? 0;
                return DropdownMenuItem<int>(
                  value: idclient,
                  child: Text(client.nama),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Pilih Status Pro',
                labelStyle: TextStyle(fontSize: 14.0),
              ),
              value: selectedStatusProId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedStatusProId = newValue;
                  _statusIdController.text = newValue.toString();
                });
              },
              items: statusProList.map((ModelStatuspro statuspro) {
                final int idkategori = int.tryParse(statuspro.idkategori) ?? 0;
                return DropdownMenuItem<int>(
                  value: idkategori,
                  child: Text(statuspro.kategoriStatus),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Pilih User',
                labelStyle: TextStyle(fontSize: 14.0),
              ),
              value: selectedUserId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedUserId = newValue;
                  _userIdController.text = newValue.toString();
                });
              },
              items: users.map((ModelUsers user) {
                final int userId = int.tryParse(user.iduser) ?? 0;
                return DropdownMenuItem<int>(
                  value: userId,
                  child: Text(user.namalengkap),
                );
              }).toList(),
            ),
            const SizedBox(height: 300.0),
            ElevatedButton(
              onPressed: _tambahkanProject,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
