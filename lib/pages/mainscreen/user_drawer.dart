// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/pages/mainscreen/components/temp_drawer.dart';
import 'package:flutter/material.dart';

import 'package:app_manpropal/services/api_services.dart';

class UserDrawer extends StatelessWidget {
  final Function(String) getLevelById; // Tambahkan properti
  final Function onProjectManagementTap;
  final Function onLaporanManagementTap;

  final Function onDashboardTap;
  final ApiService apiService;
  final String iduser;
  final String username;
  final String idlevel; // Menggunakan tipe data int
  final String namalengkap;
  final Function() onLogout; // Tambahkan properti ini

  const UserDrawer({
    Key? key,
    required this.getLevelById,
    required this.onProjectManagementTap,
    required this.onDashboardTap,
    required this.onLaporanManagementTap,
    required this.apiService,
    required this.iduser,
    required this.username,
    required this.idlevel,
    required this.namalengkap,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          TempDrawerHeader(namalengkap: namalengkap, username: username),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              onDashboardTap();
            },
          ),
          TempDrawerListTile(
            icon: Icons.work,
            title: 'Project',
            onTap: () {
              Navigator.pop(context);
              onProjectManagementTap();
            },
          ),
          TempDrawerListTile(
            icon: Icons.note,
            title: 'Report',
            onTap: () {
              Navigator.pop(context);
              onLaporanManagementTap();
            },
          ),
          TempDrawerListTile(
            icon: Icons.exit_to_app,
            title: 'Sign Out',
            onTap: () {
              Navigator.pop(context);
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}
