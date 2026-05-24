import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/hutang_piutang.dart';
import '../../blocs/hutang/hutang_bloc.dart';
import '../../blocs/hutang/hutang_event.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/toko_service.dart';

class HutangFormPage extends StatefulWidget {
  const HutangFormPage({super.key});

  @override
  State<HutangFormPage> createState() => _HutangFormPageState();
}

class _HutangFormPageState extends State<HutangFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  DateTime? _jatuhTempo;

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Hutang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan *',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah *',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Jatuh Tempo (opsional)',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _jatuhTempo != null
                        ? '${_jatuhTempo!.day}/${_jatuhTempo!.month}/${_jatuhTempo!.year}'
                        : 'Pilih tanggal',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _jatuhTempo = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final hutang = HutangPiutang(
      tokoId: sl<TokoService>().tokoId ?? '',
      namaPelanggan: _namaController.text.trim(),
      jumlah: double.parse(_jumlahController.text.trim()),
      tanggalJatuhTempo: _jatuhTempo,
    );

    context.read<HutangBloc>().add(AddHutangManual(hutang));
    Navigator.pop(context);
  }
}
