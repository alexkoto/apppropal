import 'package:app_manpropal/constants.dart';
import 'package:flutter/material.dart';

class TempButton extends StatelessWidget {
  final Function()? onTap;
  final String label;

  const TempButton({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: flexSchemeLight.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(
          label,
          style: TextStyle(
            color: flexSchemeLight.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}
