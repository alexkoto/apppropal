import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeAdmin extends StatefulWidget {
  String username;
  String iduser;
  String idlevel;
  String namalengkap;

  HomeAdmin({
    Key? key,
    required this.username,
    required this.iduser,
    required this.idlevel,
    required this.namalengkap,
  }) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("widget.username.toString()"),
    );
  }
}
