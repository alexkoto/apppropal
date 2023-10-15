// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/constants.dart';
import 'package:flutter/material.dart';

class TempDrawerHeader extends StatelessWidget {
  final String namalengkap;
  final String username;
  const TempDrawerHeader({
    Key? key,
    required this.namalengkap,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        namalengkap,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(username,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w100,
          )),
      decoration: BoxDecoration(
          color: flexSchemeLight.background,
          image: DecorationImage(
              alignment: Alignment.centerRight,
              image: AssetImage('assets/images/pdkb.png'))),
    );
  }
}

class TempDrawerListTile extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String title;
  const TempDrawerListTile({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
