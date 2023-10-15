// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/pages/utils/date.dart';
import 'package:flutter/material.dart';

import 'package:app_manpropal/constants.dart';

class TempHeadHomepage extends StatelessWidget {
  final String namalengkap;
  final String currentDate;

  TempHeadHomepage({
    Key? key,
    required this.namalengkap,
  })  : currentDate =
            CurrentDate.getCurrentDate(), // Inisialisasi currentDate di sini
        super(key: key);

  // String _getCurrentDate() {
  //   final now = DateTime.now();
  //   final day = now.day.toString().padLeft(2, '0');
  //   final month = now.month.toString().padLeft(2, '0');
  //   final year = now.year.toString();
  //   return '$day/$month/$year';
  // }

  // String currentDate = CurrentDate.getCurrentDate();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              namalengkap,
              style: TextStyle(
                color: flexSchemeLight.onBackground,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              currentDate, // Ganti _getCurrentDate() dengan fungsi yang mengembalikan tanggal yang Anda inginkan
              style: TextStyle(
                color: flexSchemeLight.onBackground,
                fontSize: 10,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: flexSchemeLight.background,
            borderRadius: BorderRadius.circular(12),
          ),
          // ignore: prefer_const_constructors
          padding: EdgeInsets.all(12),
          child: Icon(
            Icons.notifications,
            color: flexSchemeLight.onSecondary,
          ),
        )
      ],
    );
  }
}

class TempSearchBox extends StatelessWidget {
  const TempSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: flexSchemeLight.outline,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: flexSchemeLight.surface,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'cari....',
            style: TextStyle(
              color: flexSchemeLight.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class TempTitleDashboard extends StatelessWidget {
  final String judul;
  final String subJudul;

  const TempTitleDashboard({
    Key? key,
    required this.judul,
    required this.subJudul,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: TextStyle(
                color: flexSchemeLight.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subJudul,
              style: TextStyle(
                color: flexSchemeLight.onBackground,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
