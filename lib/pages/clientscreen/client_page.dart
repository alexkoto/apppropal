import 'package:app_manpropal/models/model_clients.dart';
import 'package:app_manpropal/pages/clientscreen/add_client_page.dart';
import 'package:app_manpropal/pages/clientscreen/edit_client_page.dart';
import 'package:app_manpropal/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClientPage extends StatefulWidget {
  final ApiService apiService;

  const ClientPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<ModelClients> _listClient = [];
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _getClient();
  }

  Future<void> _getClient() async {
    try {
      final data = await widget.apiService.getClients();
      setState(() {
        _listClient = data;
        isRefreshing = false;
      });
    } catch (e) {
      // Handle errors here
    }
  }

  Future<void> _handleEditClient(ModelClients client) async {
    // Navigasi ke halaman edit dengan membawa data client
    final editedClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EditClientPage(apiService: widget.apiService, client: client),
      ),
    );

    if (editedClient != null) {
      // Jika ada perubahan, perbarui daftar klien
      setState(() {
        // Cari indeks client yang diubah
        final index =
            _listClient.indexWhere((c) => c.idclient == editedClient.idclient);

        if (index >= 0) {
          // Ganti data klien dengan data yang baru
          _listClient[index] = editedClient;
        }
      });
      // setelah di update panggil lagi fungsi getclient
      await _getClient();
    }
  }

  Future<void> _handleDeleteClient(ModelClients client) async {
    // Tambahkan logika untuk menghapus data klien di sini
    try {
      await widget.apiService.deleteClient(client.idclient);
      // if (kDebugMode) {
      //   print('delete id:${client.idclient}');
      // }
      // Jika berhasil menghapus, perbarui daftar klien
      setState(() {
        _listClient.removeWhere((c) => c.idclient == client.idclient);
      });
    } catch (e) {
      // Tangani kesalahan jika gagal menghapus klien
      if (kDebugMode) {
        print("Gagal menghapus klien: $e");
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
            return _getClient();
          },
          child: ListView.builder(
            itemCount: _listClient.length,
            itemBuilder: ((context, index) {
              final client = _listClient[index];
              return Card(
                child: ListTile(
                  title: Text(client.nama),
                  subtitle: Text(client.email),
                  onTap: () {
                    _handleEditClient(client);
                  },
                  onLongPress: () {
                    // Tampilkan menu untuk menghapus klien
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
                                _handleEditClient(client);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () {
                                Navigator.pop(context);
                                _handleDeleteClient(client);
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
              builder: (context) =>
                  AddClientPage(apiService: widget.apiService),
            ),
          );

          if (result != null && result) {
            // Jika ada penambahan klien, ambil kembali data klien
            await _getClient();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
