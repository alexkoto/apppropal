// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_manpropal/models/model_user.dart';
import 'package:app_manpropal/pages/userscreen/add_user_page.dart';
import 'package:app_manpropal/pages/userscreen/edit_user_page.dart';
import 'package:app_manpropal/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final ApiService apiService;
  const UserPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<ModelUsers> _listUser = [];
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

//****_getUser */
  Future<void> _getUser() async {
    try {
      final data = await widget.apiService.getUsers();
      setState(() {
        _listUser = data;
        isRefreshing = false;
      });
    } catch (e) {
      // Handle errors here
    }
  }

//****_handleEditUser */

  Future<void> _handleEditUser(ModelUsers dataUser) async {
    final editedUser = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EditUserPage(apiService: widget.apiService, dataUser: dataUser),
      ),
    );

    if (editedUser != null) {
      // Jika ada perubahan, perbarui daftar user
      setState(() {
        // Cari indeks dataUser yang diubah
        final index =
            _listUser.indexWhere((c) => c.iduser == editedUser.iduser);

        if (index >= 0) {
          // Ganti data user dengan data yang baru
          _listUser[index] = editedUser;
        }
      });
    }
  }

  Future<void> _handleDeleteUser(ModelUsers dataUser) async {
    // Tambahkan logika untuk menghapus data user di sini
    try {
      await widget.apiService.deleteUser(dataUser.iduser);
      // if (kDebugMode) {
      //   print('delete id:${dataUser.iduser}');
      // }
      // Jika berhasil menghapus, perbarui daftar user
      setState(() {
        _listUser.removeWhere((c) => c.iduser == dataUser.iduser);
      });
    } catch (e) {
      // Tangani kesalahan jika gagal menghapus user
      if (kDebugMode) {
        print("Gagal menghapus user: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              isRefreshing = true;
            });
            return _getUser();
          },
          child: ListView.builder(
            itemCount: _listUser.length,
            itemBuilder: ((context, index) {
              final dataUser = _listUser[index];
              return Card(
                child: ListTile(
                  title: Text(dataUser.namalengkap),
                  subtitle: Text(dataUser.username),
                  onTap: () {
                    _handleEditUser(dataUser);
                  },
                  onLongPress: () {
                    // Tampilkan menu untuk menghapus user
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                _handleEditUser(dataUser);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () {
                                Navigator.pop(context);
                                _handleDeleteUser(dataUser);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddUserPage(apiService: widget.apiService),
            ),
          );

          if (result != null && result) {
            // Jika ada penambahan klien, ambil kembali data klien
            await _getUser();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
