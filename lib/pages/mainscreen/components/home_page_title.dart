// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_manpropal/constants.dart';

class HomePageTitle extends StatelessWidget {
  final String judul;
  final String subjudul;

  const HomePageTitle({
    Key? key,
    required this.judul,
    required this.subjudul,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: flexSchemeLight.outlineVariant.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20)),
      width: double.infinity,
      // height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: TextStyle(
                  fontSize: 25,
                  color: flexSchemeLight.onBackground,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.25),
            ),
            Divider(
              color: flexSchemeLight.scrim.withOpacity(0.5),
            ),
            Text(
              subjudul,
              style: TextStyle(
                  fontSize: 12,
                  color: flexSchemeLight.onBackground,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.25),
            ),
          ],
        ),
      ),
    );
  }
}
