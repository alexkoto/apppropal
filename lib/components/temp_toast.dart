import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TempToast {
  void showToast(BuildContext context, String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: color,
      textColor: Colors.white,
      timeInSecForIosWeb: 1,
      // fontSize: 16.0
    );
  }
}
