// // ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:multi_image_picker/multi_image_picker.dart';

// enum Cuaca { cerah, berawan, hujan }

// class LaporanHarianPage extends StatefulWidget {
//   final Map<String, dynamic> itemData;

//   const LaporanHarianPage({
//     Key? key,
//     required this.itemData,
//   }) : super(key: key);

//   @override
//   State<LaporanHarianPage> createState() => _LaporanHarianPageState();
// }

// class _LaporanHarianPageState extends State<LaporanHarianPage> {
//   List _detailpro = [];
//   final _tglController = TextEditingController();
//   final _latitudeController = TextEditingController();
//   final _longitudeController = TextEditingController();
//   final _lokasiController = TextEditingController();
//   final _personilController = TextEditingController();
//   final _cuacaController = TextEditingController();
//   final _cattController = TextEditingController();

//   final _terpasangController = TextEditingController();

//   Cuaca? _weather = Cuaca.cerah;
//   Position? _currentLocation;
//   late bool servicePermission = false;
//   late LocationPermission permission;
//   String _currentAddress = "";

//   @override
//   void initState() {
//     super.initState();
//     _getDetail(widget.itemData['idpro']);
//   }

//   Future<void> _inputLhp() async {
//     String idpro = widget.itemData['idpro'].toString().padLeft(3, '0');
//     String tanggal = _tglController.text
//         .replaceAll('-', ''); // Menghapus tanda "-" dari tanggal
//     String nolhp = '$idpro$tanggal'; // Menggabungkan idpro dan tanggal
//     // Selanjutnya, Anda dapat mengirim idlhp ke server atau melakukan apa yang diperlukan dengannya

//     try {
//       final url = Uri.parse("https://prisan.co.id/app_propal/add_prolhp.php");
//       final response = await http.post(url, body: {
//         'idpro': idpro,
//         'nolhp': nolhp, // Ganti dengan nilai yang sesuai
//         'tanggal': _tglController.text,
//         'lan': _latitudeController.text,
//         'lon': _longitudeController.text,
//         'lokasi': _lokasiController.text,
//         'personil': _personilController.text,
//         'cuaca': _cuacaController.text,
//         'catatan_spv': _cattController.text,
//       });
//       debugPrint("log: ${response.body}");
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Data telah disimpan.'),
//           ),
//         );
//         Navigator.of(context).popUntil((route) => route.isFirst);
//       } else {
//         // Gagal, munculkan pesan kesalahan atau tindakan yang sesuai
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Gagal menyimpan data.'),
//           ),
//         );
//       }
//     } catch (e) {
//       // Tangani kesalahan jika ada
//       if (kDebugMode) {
//         print(e);
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Terjadi kesalahan: $e'),
//         ),
//       );
//     }
//   }

//   Future<void> _getDetail(String idpro) async {
//     try {
//       final url =
//           Uri.parse("https://prisan.co.id/app_propal/detail_project.php");
//       final response = await http.post(url, body: {"idpro": idpro});
//       debugPrint("log: ${response.body}");
//       if (kDebugMode) {
//         print(response.body);
//       }

//       if (response.statusCode == 200) {
//         if (kDebugMode) {
//           print(response.body);
//         }
//         final detaildata = jsonDecode(response.body);
//         setState(() {
//           _detailpro = detaildata;
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   Future<Position> _getCurrentLocation() async {
//     servicePermission = await Geolocator.isLocationServiceEnabled();
//     if (!servicePermission) {
//       if (kDebugMode) {
//         print("service disable");
//       }
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   _getAddressFromCoordinate() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentLocation!.latitude, _currentLocation!.longitude);
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//             "${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
//       });
//       double latitude = _currentLocation!.latitude;
//       double longitude = _currentLocation!.longitude;
//       String address = _currentAddress;

//       _latitudeController.text = latitude.toString();
//       _longitudeController.text = longitude.toString();
//       _lokasiController.text = address;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   List<Asset> _images = <Asset>[];
//   String _uploadStatus = '';

//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 2, // Ubah sesuai kebutuhan
//         enableCamera: true,
//       );
//     } on Exception catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }

//     if (!mounted) return;

//     setState(() {
//       _images = resultList;
//     });
//   }

//   Future<void> uploadImages() async {
//     final uri = Uri.parse(
//         'https://prisan.co.id/app_propal/upload.php'); // Ganti dengan URL server Anda

//     try {
//       final request = http.MultipartRequest('POST', uri);

//       for (var asset in _images) {
//         final byteData = await asset.getByteData();
//         final buffer = byteData.buffer.asUint8List();
//         final multipartFile = http.MultipartFile.fromBytes(
//           'images',
//           buffer,
//           filename: 'image.jpg',
//         );
//         request.files.add(multipartFile);
//       }

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         setState(() {
//           _uploadStatus = 'Gambar berhasil diunggah!';
//         });
//       } else {
//         setState(() {
//           _uploadStatus = 'Gagal mengunggah gambar.';
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error: $e');
//       }
//       setState(() {
//         _uploadStatus = 'Terjadi kesalahan: $e';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tglController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     _lokasiController.dispose();
//     _personilController.dispose();
//     _cuacaController.dispose();
//     _cattController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Laporan Harian Pekerjaan'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Tanggal',
//                 ),
//                 controller: _tglController,
//                 readOnly: true,
//                 onTap: () async {
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );

//                   if (selectedDate != null) {
//                     setState(() {
//                       _tglController.text =
//                           selectedDate.toLocal().toString().split(' ')[0];
//                     });
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               const SizedBox(height: 10),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _latitudeController,
//                           decoration:
//                               const InputDecoration(labelText: 'Latitude'),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: TextFormField(
//                           controller: _longitudeController,
//                           decoration:
//                               const InputDecoration(labelText: 'Longitude'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 maxLines: null,
//                 controller: _lokasiController,
//                 decoration: const InputDecoration(
//                   labelText: 'Alamat',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   _currentLocation = await _getCurrentLocation();
//                   await _getAddressFromCoordinate();
//                 },
//                 child: const Text('Pilih Lokasi'),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: TextFormField(
//                       controller: _personilController,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.end,
//                       decoration: const InputDecoration(
//                         labelText: 'Jumlah',
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                     flex: 3,
//                     child: Text(
//                       "Orang",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         height: 3,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Card(
//                 elevation: 2,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Cuaca',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ListTile(
//                         dense: true,
//                         title: const Text('Cerah'),
//                         leading: Radio<Cuaca>(
//                           value: Cuaca.cerah,
//                           groupValue: _weather,
//                           onChanged: (Cuaca? value) {
//                             setState(() {
//                               _weather = value;
//                               _cuacaController.text = 'Cerah';
//                             });
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         dense: true,
//                         title: const Text('Berawan'),
//                         leading: Radio<Cuaca>(
//                           value: Cuaca.berawan,
//                           groupValue: _weather,
//                           onChanged: (Cuaca? value) {
//                             setState(() {
//                               _weather = value;
//                               _cuacaController.text = 'Berawan';
//                             });
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         dense: true,
//                         title: const Text('Hujan'),
//                         leading: Radio<Cuaca>(
//                           value: Cuaca.hujan,
//                           groupValue: _weather,
//                           onChanged: (Cuaca? value) {
//                             setState(() {
//                               _weather = value;
//                               _cuacaController.text = 'Hujan';
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 300,
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1,
//                     childAspectRatio: 2.5,
//                   ),
//                   itemCount: _detailpro.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       child: ListTile(
//                         leading: const CircleAvatar(
//                           child: Icon(
//                             Icons.construction,
//                           ),
//                         ),
//                         title: Text(
//                           _detailpro[index]['detail_pekerjaan'],
//                           style: const TextStyle(fontSize: 12.0),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 '${'Jumlah: ' + _detailpro[index]['jumlah']} ' +
//                                     _detailpro[index]['satuan']),
//                             Text(
//                                 '${'Realisasi: ' + _detailpro[index]['realisasi']} ' +
//                                     _detailpro[index]['satuan']),
//                             Text(
//                                 '${'Selisih: ' + _detailpro[index]['selisih']} ' +
//                                     _detailpro[index]['satuan']),
//                           ],
//                         ),
//                         trailing: const CircleAvatar(child: Icon(Icons.add)),
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 title: const Text('Terpasang Hari ini'),
//                                 content: SizedBox(
//                                   width: double.maxFinite,
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(_detailpro[index]
//                                           ['detail_pekerjaan']),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: TextFormField(
//                                               controller: _terpasangController,
//                                               decoration: const InputDecoration(
//                                                 labelText: 'Terpasang',
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             _detailpro[index]['satuan'],
//                                             style: const TextStyle(
//                                               fontSize:
//                                                   16, // Sesuaikan ukuran font sesuai kebutuhan
//                                               fontWeight: FontWeight
//                                                   .bold, // Sesuaikan gaya font sesuai kebutuhan
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () async {
//                                       await Future.delayed(const Duration(
//                                           milliseconds:
//                                               100)); // Tambahkan penundaan sebentar
//                                       Navigator.of(context).pop();
//                                       String terpasang =
//                                           _terpasangController.text;
//                                       String idpro = widget.itemData['idpro']
//                                           .toString()
//                                           .padLeft(3, '0');

//                                       String tanggal = _tglController.text
//                                           .replaceAll('-',
//                                               ''); // Menghapus tanda "-" dari tanggal
//                                       String nolhp =
//                                           '$idpro$tanggal'; // Menggabungkan idpro dan tanggal
//                                       String nolhpp =
//                                           '$idpro$tanggal'; // Menggabungkan idpro dan tanggal
//                                       String detailPekerjaan =
//                                           _detailpro[index]['detail_pekerjaan'];
//                                       String satuan =
//                                           _detailpro[index]['satuan'];

//                                       try {
//                                         final url = Uri.parse(
//                                             "https://prisan.co.id/app_propal/add_prolhp_pek.php");
//                                         final response =
//                                             await http.post(url, body: {
//                                           "idpro": idpro,
//                                           "nolhp": nolhp,
//                                           "nolhpp": nolhpp,
//                                           "detail_pekerjaan": detailPekerjaan,
//                                           "satuan": satuan,
//                                           "jumlah": terpasang,
//                                         });
//                                         if (response.statusCode == 200) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                   'Data berhasil disimpan.'),
//                                             ),
//                                           );
//                                           _terpasangController.text = '';
//                                           _getDetail(widget.itemData['idpro']);
//                                         } else {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               content:
//                                                   Text('Gagal menyimpan data.'),
//                                             ),
//                                           );
//                                         }
//                                       } catch (e) {
//                                         if (kDebugMode) {
//                                           print(e);
//                                         }
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           SnackBar(
//                                             content:
//                                                 Text('Terjadi kesalahan: $e'),
//                                           ),
//                                         );
//                                       }
//                                     },
//                                     child: const Text('Simpan'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('Batal'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _cattController,
//                 decoration: const InputDecoration(
//                   labelText: 'Catatan',
//                 ),
//                 maxLines: null,
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: loadAssets,
//                 // onPressed: () {},

//                 child: const Text('Pilih Gambar'),
//               ),
//               const SizedBox(height: 32),
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   children: List.generate(_images.length, (index) {
//                     Asset asset = _images[index];
//                     return AssetThumb(
//                       asset: asset,
//                       width: 300,
//                       height: 300,
//                     );
//                   }),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: uploadImages,
//                 child: const Text('Unggah Gambar'),
//               ),
//               Text(_uploadStatus),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: _inputLhp,
//                 child: const Text('Simpan'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
