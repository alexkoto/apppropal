// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/constants.dart';
import 'package:flutter/material.dart';

class TempLogo extends StatelessWidget {
  final String imagePath;
  const TempLogo({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: flexSchemeLight.surface),
          borderRadius: BorderRadius.circular(10),
          color: flexSchemeLight.onSurface,
        ),
        child: Image.asset(
          imagePath,
          height: 50,
        ));
  }
}
