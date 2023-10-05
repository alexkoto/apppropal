import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class TempFormfield extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText, text;
  // final String textValue;

  const TempFormfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.text,
    // required this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(
          fontSize: 15,
        ),
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: text,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

class TempTextcur extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText, text;
  final bool decimal;
  // final String textValue;

  const TempTextcur({
    super.key,
    required this.controller,
    required this.hintText,
    required this.decimal,
    required this.text,
    // required this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
        ),
        // textAlign: TextAlign.center,
        controller: controller,
        inputFormatters: <TextInputFormatter>[
          CurrencyTextInputFormatter(
            locale: 'id',
            decimalDigits: 0,
            symbol: 'Rp. ',
          ),
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            labelText: text,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

class TempTextfield extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  // final String textValue;

  const TempTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    // required this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
