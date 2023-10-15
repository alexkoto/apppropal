// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_manpropal/services/api_services.dart';

class LaporanPage extends StatefulWidget {
  final String item; // Sesuaikan tipe data dengan data yang ingin ditampilkan
  final ApiService apiService;
  final String iduser;
  final String idlevel;
  final String idstatus;

  const LaporanPage({
    Key? key,
    required this.item,
    required this.apiService,
    required this.iduser,
    required this.idlevel,
    required this.idstatus,
  }) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cetak Laporan'),
      ),
    );
  }
}
