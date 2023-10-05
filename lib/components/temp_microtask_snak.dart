import 'package:flutter/material.dart';

class AlexMicrotasks {
  void runMicrotask(BuildContext context, String message, Color color) async {
    Future.microtask(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          backgroundColor: color,
        ),
      );
    });
  }
}
