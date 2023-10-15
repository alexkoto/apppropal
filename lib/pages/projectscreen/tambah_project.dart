// ignore_for_file: use_build_context_synchronously

import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/constants.dart';
import 'package:app_manpropal/models/model_clients.dart';
import 'package:app_manpropal/models/model_data_pekerjaan.dart';
import 'package:app_manpropal/models/model_statuspro.dart';
import 'package:app_manpropal/models/model_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../services/api_services.dart';

class TambahProjectPage extends StatefulWidget {
  final ApiService apiService;

  const TambahProjectPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<TambahProjectPage> createState() => _TambahProjectPageState();
}

class _TambahProjectPageState extends State<TambahProjectPage> {
  final _keyproController = TextEditingController();
  final _namaController = TextEditingController();
  final _nomorController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _nilaiController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _statusIdController = TextEditingController();
  final _userIdController = TextEditingController();

  String newProjectStartDate = '';
  String newProjectEndDate = '';

  List<ModelUsers> users = [];
  List<ModelClients> clients = [];
  int? selectedUserId;
  int? selectedClientId;
  int? selectedStatusProId;
  List<ModelStatuspro> statusProList = [];
  List<String> selectedSatuanTexts = [];
  List<String> selectedPekerjaanTexts = [];

  // Variabel untuk menyimpan daftar controller dan pekerjaan
  List<TextEditingController> pekerjaanControllers = [TextEditingController()];
  List<TextEditingController> satuanControllers = [TextEditingController()];

  List<ModelDataPekerjaan?> selectedPekerjaan = [null];
  List<ModelDataPekerjaan?> selectedSatuan = [null];

  //**********1 */

//*******membuat keyproyek */
// String timestampToHumanReadable(int timestamp) {
//   var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//   var formatter = DateFormat('dd MMMM yyyy HH:mm:ss');
//   return formatter.format(date);
// }

  Future<void> _tambahkanProject() async {
    try {
      List<String> selectedPekerjaanList = [];

      for (TextEditingController controller in pekerjaanControllers) {
        String pekerjaanText = controller.text;
        String keypro = _keyproController.text;
        String nopro = _nomorController.text;

        if (pekerjaanText.isNotEmpty) {
          selectedPekerjaanList.add("$keypro; $nopro; $pekerjaanText");
        }
      }

      await widget.apiService.tambahkanProject(
        keypro: _keyproController.text,
        nmpro: _namaController.text,
        nopro: _nomorController.text,
        mulai: _startDateController.text,
        selesai: _endDateController.text,
        nilai: _nilaiController.text,
        idclient: _clientIdController.text,
        idstatus: _statusIdController.text,
        iduser: _userIdController.text,
      );

      await widget.apiService.kirimDataPekerjaan(selectedPekerjaanList);

      if (kDebugMode) {
        for (int i = 0; i < selectedPekerjaanList.length; i++) {
          print("Hasil $i: ${selectedPekerjaanList[i]}");
        }
      }

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
    int currentUnixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    setState(() {
      _keyproController.text = currentUnixTimestamp.toString();
    });
    if (kDebugMode) {
      print("Unix epoch time saat ini: $currentUnixTimestamp");
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Tambahkan Project Baru'),
      // ),
      backgroundColor: flexSchemeLight.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25.0),
              TempFormfieldInput(
                controller: _keyproController,
                labelText: 'Key Project',
                textInputType: TextInputType.none,
                enable: false,
              ),
              const SizedBox(height: 14.0),
              TempFormfieldInput(
                controller: _namaController,
                labelText: 'Nama Project',
                textInputType: TextInputType.multiline,
                enable: true,
              ),
              const SizedBox(height: 14.0),
              TempFormfieldInput(
                controller: _nomorController,
                labelText: 'SPK/SPBJ/WO/Kode Project',
                textInputType: TextInputType.text,
                enable: true,
              ),
              const SizedBox(height: 14.0),
              Row(
                children: [
                  Expanded(
                    child: Tempdateinput(
                        controller: _startDateController,
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
                        labelText1: "Tanggal Mulai"),
                  ),
                  Expanded(
                      child: Tempdateinput(
                          controller: _endDateController,
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
                          labelText1: 'Tanggal Selesai'))
                ],
              ),
              const SizedBox(height: 16.0),
              TempFormfieldInput(
                controller: _nilaiController,
                labelText: 'Nilai Pekerjaan ',
                textInputType: TextInputType.number,
                enable: true,
              ),
              const SizedBox(height: 16.0),
              Column(
                children: List.generate(pekerjaanControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TypeAheadFormField<ModelDataPekerjaan>(
                            autoFlipDirection: true,
                            // autoFlipMinHeight: 2,
                            // animationStart: BorderSide.strokeAlignCenter,
                            textFieldConfiguration: TextFieldConfiguration(
                              maxLines: null,
                              controller: pekerjaanControllers[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: flexSchemeLight.outline),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Masukan Pekerjaan',
                                labelText: 'Pekerjaan ${index + 1}',
                                labelStyle: const TextStyle(fontSize: 14.0),
                              ),
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              elevation: 10.0,
                              color: Theme.of(context).cardColor,
                            ),
                            suggestionsCallback: (pattern) async {
                              final List<ModelDataPekerjaan> suggestions =
                                  await widget.apiService
                                      .searchPekerjaan(pattern);
                              return suggestions;
                            },
                            itemSeparatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder:
                                (context, ModelDataPekerjaan suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion.pekerjaan,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected:
                                (ModelDataPekerjaan suggestion) {
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
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              pekerjaanControllers.removeAt(index);
                              selectedPekerjaan.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16.0),
              TempButton(
                  onTap: () {
                    setState(() {
                      pekerjaanControllers.add(TextEditingController());
                      selectedPekerjaan.add(null);
                    });
                  },
                  label: 'Tambah Pekerjaan'),
              const SizedBox(height: 16.0),
              TempDropdown(
                labelText: 'Client',
                value: selectedClientId,
                onChange: (int? newValue) {
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
              TempDropdown(
                labelText: 'Status Project',
                value: selectedStatusProId,
                onChange: (int? newValue) {
                  setState(() {
                    selectedStatusProId = newValue;
                    _statusIdController.text = newValue.toString();
                  });
                },
                items: statusProList.map((ModelStatuspro statuspro) {
                  final int idkategori =
                      int.tryParse(statuspro.idkategori) ?? 0;
                  return DropdownMenuItem<int>(
                    value: idkategori,
                    child: Text(statuspro.kategoriStatus),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TempDropdown(
                labelText: 'PIC Projects',
                value: selectedUserId,
                onChange: (int? newValue) {
                  setState(() {
                    selectedUserId = newValue;
                    _userIdController.text = newValue.toString();
                  });
                },
                items: users.map((ModelUsers user) {
                  final int userId = int.tryParse(user.iduser) ?? 0;
                  return DropdownMenuItem<int>(
                    alignment: AlignmentDirectional.centerStart,
                    value: userId,
                    child: Text(
                      user.namalengkap,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TempButton(onTap: _tambahkanProject, label: 'Simpan'),
            ],
          ),
        ),
      ),
    );
  }
}
