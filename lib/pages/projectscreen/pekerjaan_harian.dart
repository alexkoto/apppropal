import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/constants.dart';
import 'package:app_manpropal/models/model_data_pekerjaan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_manpropal/services/api_services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class PekerjaanHarian extends StatefulWidget {
  final ApiService apiService;
  final String keyPro;

  const PekerjaanHarian({
    Key? key,
    required this.apiService,
    required this.keyPro,
  }) : super(key: key);

  @override
  State<PekerjaanHarian> createState() => _PekerjaanHarianState();
}

class _PekerjaanHarianState extends State<PekerjaanHarian> {
  final _keyproController = TextEditingController();
  final _dateController = TextEditingController();
  List<TextEditingController> pekerjaanControllers = [TextEditingController()];
  List<TextEditingController> satuanControllers = [TextEditingController()];
  List<TextEditingController> jumlahControllers = [TextEditingController()];
  String newDate = '';

  List<ModelDataPekerjaan?> selectedPekerjaan = [null];
  List<ModelDataPekerjaan?> selectedSatuan = [null];

  @override
  void initState() {
    _keyproController.text = widget.keyPro;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan Hari ini'),
      ),
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
              const SizedBox(
                height: defaultVer,
              ),
              Tempdateinput(
                controller: _dateController,
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
                      _dateController.text = formattedDate;
                      newDate = formattedDate;
                    });
                  }
                },
                labelText1: "Tanggal",
              ),
              const SizedBox(
                height: defaultVer,
              ),
              Column(
                children: List.generate(pekerjaanControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TypeAheadFormField<ModelDataPekerjaan>(
                                autoFlipDirection: true,
                                textFieldConfiguration: TextFieldConfiguration(
                                  maxLines: 1,
                                  controller: pekerjaanControllers[index],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: flexSchemeLight.outline),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: 'Masukan Pekerjaan',
                                    labelText: 'Pekerjaan ${index + 1}',
                                    labelStyle: const TextStyle(fontSize: 12.0),
                                  ),
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                suggestionsBoxDecoration:
                                    SuggestionsBoxDecoration(
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
                          ],
                        ),
                        const SizedBox(
                          height: defaultVer,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: jumlahControllers[index],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: flexSchemeLight.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Jumlah',
                                  labelText: 'Jumlah',
                                  labelStyle: const TextStyle(fontSize: 12.0),
                                ),
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: satuanControllers[index],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: flexSchemeLight.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Satuan',
                                  labelText: 'Satuan',
                                  labelStyle: const TextStyle(fontSize: 12.0),
                                ),
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  final int indexToRemove = index;
                                  pekerjaanControllers.removeAt(indexToRemove);
                                  selectedPekerjaan.removeAt(indexToRemove);
                                  jumlahControllers.removeAt(indexToRemove);
                                  satuanControllers.removeAt(indexToRemove);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: defaultVer,
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Color.fromARGB(69, 4, 4, 4),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 4 * defaultVer,
              ),
              TempButton(
                onTap: () {
                  setState(() {
                    pekerjaanControllers.add(TextEditingController());
                    selectedPekerjaan.add(null); // Menambahkan elemen null
                    jumlahControllers.add(TextEditingController());
                    satuanControllers.add(TextEditingController());
                  });
                },
                label: 'Tambah Pekerjaan',
              ),
              const SizedBox(
                height: 2 * defaultVer,
              ),
              TempButton(onTap: _simpan, label: 'Submit'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simpan() async {
    try {
      final List<String> selectedPekerjaanHarianList = [];
      for (int index = 0; index < pekerjaanControllers.length; index++) {
        final String keypro = _keyproController.text;
        final String date = _dateController.text;
        final String pekerjaanText = pekerjaanControllers[index].text;
        final String jumlahText = jumlahControllers[index].text;
        final String satuanText = satuanControllers[index].text;

        if (pekerjaanText.isNotEmpty) {
          selectedPekerjaanHarianList
              .add("$keypro; $date; $pekerjaanText; $jumlahText; $satuanText");
        }
      }

      await widget.apiService.pekerjaanHarian(selectedPekerjaanHarianList);

      if (kDebugMode) {
        for (int i = 0; i < selectedPekerjaanHarianList.length; i++) {
          print("Hasil $i: ${selectedPekerjaanHarianList[i]}");
        }
      }

      // Tambahkan pesan kesuksesan atau tampilan lain sesuai kebutuhan.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data pekerjaan harian berhasil disimpan'),
        ),
      );
      Navigator.pop(context);
      // Bersihkan input setelah penyimpanan sukses.
      pekerjaanControllers.clear();
      satuanControllers.clear();
      jumlahControllers.clear();
    } catch (e) {
      print(e);
      // Handle error, menampilkan pesan kesalahan, jika diperlukan.
    }
  }
}
