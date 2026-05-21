import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/toko.dart';

class PengaturanTokoPage extends StatefulWidget {
  const PengaturanTokoPage({super.key});

  @override
  State<PengaturanTokoPage> createState() => _PengaturanTokoPageState();
}

class _PengaturanTokoPageState extends State<PengaturanTokoPage> {
  final _authRepo = sl<AuthRepository>();
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _tokoId;

  @override
  void initState() {
    super.initState();
    _loadToko();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _loadToko() async {
    setState(() => _loading = true);
    try {
      final toko = await _authRepo.fetchToko();
      if (toko != null && mounted) {
        _tokoId = toko.id;
        _namaController.text = toko.nama;
        _alamatController.text = toko.alamat ?? '';
        _teleponController.text = toko.telepon ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await _authRepo.updateToko(Toko(
        id: _tokoId,
        nama: _namaController.text.trim(),
        alamat: _alamatController.text.trim().isEmpty
            ? null
            : _alamatController.text.trim(),
        telepon: _teleponController.text.trim().isEmpty
            ? null
            : _teleponController.text.trim(),
      ));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan toko berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Toko')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_tokoId != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.fingerprint, color: Colors.grey, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ID Toko',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _tokoId!,
                                    style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () {
                                // Tampilkan snackbar setelah copy
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ID Toko disalin!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Toko *',
                      prefixIcon: Icon(Icons.store),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama toko wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Toko',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _teleponController,
                    decoration: const InputDecoration(
                      labelText: 'Telepon',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_saving ? 'Menyimpan...' : 'Simpan'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
