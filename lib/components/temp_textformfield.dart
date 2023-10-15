// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TempDropdown extends StatelessWidget {
  final String labelText;
  // final VoidCallback? onChanged;
  final int? value;
  final Function(int?)? onChange;
  final List<DropdownMenuItem<int>>? items;
  // final
  const TempDropdown({
    Key? key,
    required this.labelText,
    required this.value,
    required this.onChange,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: DropdownButtonFormField<int>(
          isExpanded: true,
          elevation: 4,
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),

          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                gapPadding: 4,
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 14.0),
          ),
          value: value,
          onChanged: onChange,
          items: items),
    );
  }
}

class Tempdateinput extends StatelessWidget {
  final TextEditingController controller;
  final Function()? onTap;
  final String labelText1;

  const Tempdateinput({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.labelText1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          // labelText: labelText1,
          labelText: labelText1,
          labelStyle: const TextStyle(fontSize: 14.0),
        ),
        onTap: onTap,
        readOnly: true,
        controller: controller,
      ),
    );
  }
}

class TempFormfieldInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType textInputType;
  final bool enable;
  const TempFormfieldInput({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.textInputType,
    required this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        keyboardType: textInputType,
        maxLines: null,
        style: const TextStyle(
          fontSize: 12.0,
        ),
        controller: controller,
        decoration: InputDecoration(
            enabled: enable,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: flexSchemeLight.inversePrimary),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 14.0),
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

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
