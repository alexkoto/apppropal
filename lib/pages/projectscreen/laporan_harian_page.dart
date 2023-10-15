import 'dart:async';
import 'dart:convert';

import 'package:app_manpropal/components/temp_button.dart';
import 'package:app_manpropal/components/temp_textformfield.dart';
import 'package:app_manpropal/pages/projectscreen/pekerjaan_harian.dart';
import 'package:app_manpropal/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

import 'package:app_manpropal/services/config_upload.dart';

final dio = Dio();

enum Cuaca { cerah, berawan, hujan }

class LaporanHarianPage extends StatefulWidget {
  final ApiService apiService;

  final Map<String, dynamic> itemData;

  const LaporanHarianPage({
    Key? key,
    required this.apiService,
    required this.itemData,
  }) : super(key: key);

  @override
  State<LaporanHarianPage> createState() => _LaporanHarianPageState();
}

class _LaporanHarianPageState extends State<LaporanHarianPage> {
  late String keyPro; // Deklarasikan variabel keyPro
  // Timer? _timer;
  final _tglController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _personilController = TextEditingController();
  final _cuacaController = TextEditingController();
  final _cattController = TextEditingController();

  Cuaca? _weather;

  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAddress = "";

//*******input Tabel tb_prolhp */
  Future<void> _inputLhp() async {
    String tanggal = _tglController.text.replaceAll('-', '');
    String nolhp = '$keyPro$tanggal';
    Map<String, String> requestData = {
      'keypro': keyPro,
      'nolhp': nolhp,
      'tanggal': _tglController.text,
      'lan': _latitudeController.text,
      'lon': _longitudeController.text,
      'lokasi': _lokasiController.text,
      'personil': _personilController.text,
      'cuaca': _cuacaController.text,
      'catatan_spv': _cattController.text,
    };

    try {
      final success = await widget.apiService.inputLhp(requestData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data telah disimpan.'),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan data.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  Future<void> _getDetail() async {
    try {
      final detaildata = await widget.apiService.getDetail(keyPro);
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      if (kDebugMode) {
        print("service disable");
      }
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinate() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
      });
      double latitude = _currentLocation!.latitude;
      double longitude = _currentLocation!.longitude;
      String address = _currentAddress;

      _latitudeController.text = latitude.toString();
      _longitudeController.text = longitude.toString();
      _lokasiController.text = address;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//**Ambil gambar */
//**metod 1 */

  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';
  String _uploadStatus = '';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    // Dio dio = Dio();
    String error = 'No Error Detected';

    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  _saveImage(String keypro) async {
    int count = 0;

    for (var i = 0; i < images.length; i++) {
      ByteData byteData = await images[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        filename: images[i].name,
        contentType: MediaType('image', 'jpg'),
      );

      FormData formData = FormData.fromMap({
        "image": multipartFile,
        "keypro": keyPro,
      });
      EasyLoading.show(status: 'upload........');
      // EasyLoading.showProgress(0.3, status: 'downloading...');

      var response = await dio.post(UPLOAD_URL, data: formData);
      if (response.statusCode == 200) {
        count++;
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Success! $count');
        final responseData = response.data.toString();
        final responseJson = json.decode(responseData);
        if (kDebugMode) {
          print(response.data);
          setState(() {
            _uploadStatus = responseJson['message'];
          });
        }
      } else {
        EasyLoading.showError('Failed with Error');
      }
    }
  }

//******* */

  //**Ambil gambar */

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _tglController.dispose();
  //   _latitudeController.dispose();
  //   _longitudeController.dispose();
  //   _lokasiController.dispose();
  //   _personilController.dispose();
  //   _cuacaController.dispose();
  //   _cattController.dispose();
  // }

  // @override
  // void dispose() {
  //   _tglController.dispose();
  //   _latitudeController.dispose();
  //   _longitudeController.dispose();
  //   _lokasiController.dispose();
  //   _personilController.dispose();
  //   _cuacaController.dispose();
  //   _cattController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    keyPro = widget.itemData['keypro'];
    _getDetail();
    EasyLoading.addStatusCallback((status) {
      if (kDebugMode) {
        print('EasyLoading Status $status');
      }
      if (status == EasyLoadingStatus.dismiss) {
        // _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nomor: $keyPro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Tempdateinput(
                  controller: _tglController,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        _tglController.text =
                            selectedDate.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  labelText1: 'Tanggal'),
              const SizedBox(height: 20),

              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TempFormfieldInput(
                              controller: _latitudeController,
                              labelText: 'Latitude',
                              textInputType: TextInputType.text,
                              enable: false)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: TempFormfieldInput(
                              controller: _longitudeController,
                              labelText: 'Longitude',
                              textInputType: TextInputType.text,
                              enable: false)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TempFormfieldInput(
                  controller: _lokasiController,
                  labelText: 'Alamat',
                  textInputType: TextInputType.text,
                  enable: false),

              const SizedBox(height: 16),
              TempButton(
                  onTap: () async {
                    _currentLocation = await _getCurrentLocation();
                    await _getAddressFromCoordinate();
                  },
                  label: 'Pilih Lokasi'),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: TempFormfieldInput(
                      controller: _personilController,
                      labelText: 'Jumlah',
                      textInputType: TextInputType.number,
                      enable: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Orang",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 3,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cuaca',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Cerah'),
                        leading: Radio<Cuaca>(
                          value: Cuaca.cerah,
                          groupValue: _weather,
                          onChanged: (Cuaca? value) {
                            setState(() {
                              _weather = value;
                              _cuacaController.text = 'Cerah';
                            });
                          },
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Berawan'),
                        leading: Radio<Cuaca>(
                          value: Cuaca.berawan,
                          groupValue: _weather,
                          onChanged: (Cuaca? value) {
                            setState(() {
                              _weather = value;
                              _cuacaController.text = 'Berawan';
                            });
                          },
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Hujan'),
                        leading: Radio<Cuaca>(
                          value: Cuaca.hujan,
                          groupValue: _weather,
                          onChanged: (Cuaca? value) {
                            setState(() {
                              _weather = value;
                              _cuacaController.text = 'Hujan';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 16),
              TempButton(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PekerjaanHarian(
                        keyPro: keyPro,
                        apiService: widget.apiService,
                      ),
                    ),
                  );
                },
                label: 'Pekerjaan Hari ini',
              ),

              // SizedBox(
              //   height: 300,
              //   child: GridView.builder(
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 1,
              //       childAspectRatio: 2.5,
              //     ),
              //     itemCount: _detailpro.length,
              //     itemBuilder: (context, index) {
              //       return Card(
              //         child: ListTile(
              //           leading: const CircleAvatar(
              //             child: Icon(
              //               Icons.construction,
              //             ),
              //           ),
              //           title: Text(
              //             _detailpro[index]['detail_pekerjaan'],
              //             style: const TextStyle(fontSize: 12.0),
              //           ),
              //           subtitle: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                   '${'Jumlah: ' + _detailpro[index]['jumlah']} ' +
              //                       _detailpro[index]['satuan']),
              //               Text(
              //                   '${'Realisasi: ' + _detailpro[index]['realisasi']} ' +
              //                       _detailpro[index]['satuan']),
              //               Text(
              //                   '${'Selisih: ' + _detailpro[index]['selisih']} ' +
              //                       _detailpro[index]['satuan']),
              //             ],
              //           ),
              //           trailing: const CircleAvatar(child: Icon(Icons.add)),
              //           onTap: () {
              //             showDialog(
              //               context: context,
              //               builder: (context) {
              //                 return AlertDialog(
              //                   title: const Text('Terpasang Hari ini'),
              //                   content: SizedBox(
              //                     width: double.maxFinite,
              //                     child: Column(
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         Text(_detailpro[index]
              //                             ['detail_pekerjaan']),
              //                         Row(
              //                           children: [
              //                             Expanded(
              //                               child: TextFormField(
              //                                 controller: _terpasangController,
              //                                 decoration: const InputDecoration(
              //                                   labelText: 'Terpasang',
              //                                 ),
              //                               ),
              //                             ),
              //                             Text(
              //                               _detailpro[index]['satuan'],
              //                               style: const TextStyle(
              //                                 fontSize:
              //                                     16, // Sesuaikan ukuran font sesuai kebutuhan
              //                                 fontWeight: FontWeight
              //                                     .bold, // Sesuaikan gaya font sesuai kebutuhan
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                   actions: [
              //                     TextButton(
              //                       onPressed: () async {
              //                         await Future.delayed(
              //                             const Duration(milliseconds: 100));
              //                         Navigator.of(context).pop();

              //                         // Salin context ke dalam variabel lokal
              //                         final BuildContext localContext = context;

              //                         String terpasang =
              //                             _terpasangController.text;
              //                         String keypro =
              //                             widget.itemData['keypro'].toString();

              //                         String tanggal = _tglController.text
              //                             .replaceAll('-', '');
              //                         String nolhp = '$keypro$tanggal';
              //                         String nolhpp = '$keypro$tanggal';
              //                         String detailPekerjaan =
              //                             _detailpro[index]['detail_pekerjaan'];
              //                         String satuan =
              //                             _detailpro[index]['satuan'];

              //                         try {
              //                           final url = Uri.parse(
              //                               "https://prisan.co.id/app_propal/add_prolhp_pek.php");

              //                           final response =
              //                               await http.post(url, body: {
              //                             "keypro": keypro,
              //                             "nolhp": nolhp,
              //                             "nolhpp": nolhpp,
              //                             "detail_pekerjaan": detailPekerjaan,
              //                             "satuan": satuan,
              //                             "jumlah": terpasang,
              //                           });
              //                           if (response.statusCode == 200) {
              //                             ScaffoldMessenger.of(localContext)
              //                                 .showSnackBar(
              //                               const SnackBar(
              //                                 content: Text(
              //                                     'Data berhasil disimpan.'),
              //                               ),
              //                             );
              //                             _terpasangController.text = '';
              //                             _getDetail();
              //                           } else {
              //                             ScaffoldMessenger.of(localContext)
              //                                 .showSnackBar(
              //                               const SnackBar(
              //                                 content:
              //                                     Text('Gagal menyimpan data.'),
              //                               ),
              //                             );
              //                           }
              //                         } catch (e) {
              //                           if (kDebugMode) {
              //                             print(e);
              //                           }
              //                           ScaffoldMessenger.of(localContext)
              //                               .showSnackBar(
              //                             SnackBar(
              //                               content:
              //                                   Text('Terjadi kesalahan: $e'),
              //                             ),
              //                           );
              //                         }
              //                       },
              //                       child: const Text('Simpan'),
              //                     ),
              //                     TextButton(
              //                       onPressed: () {
              //                         Navigator.of(context).pop();
              //                       },
              //                       child: const Text('Batal'),
              //                     ),
              //                   ],
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       );
              //     },
              //   ),
              // ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              TextFormField(
                controller: _cattController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                ),
                maxLines: null,
              ),
              const SizedBox(height: 32),

//**Ambil gambar */
              Center(child: Text('Error: $_error')),
              ElevatedButton(
                onPressed: loadAssets,
                child: const Text("Ambil Gambar Realisasi "),
              ),
              SizedBox(
                height: 100,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  children: List.generate(images.length, (index) {
                    Asset asset = images[index];
                    return AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    );
                  }),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  _saveImage(keyPro);
                },
                child: const Text('Uplaoad Gambar realisasi'),
              ),
              Center(child: Text(_uploadStatus)),

//**Ambil gambar */

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _inputLhp,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
