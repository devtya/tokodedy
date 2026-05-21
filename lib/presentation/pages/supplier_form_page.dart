import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/supplier.dart';
import '../blocs/supplier/supplier_bloc.dart';
import '../blocs/supplier/supplier_event.dart';

class SupplierFormPage extends StatefulWidget {
  final Supplier? supplier;

  const SupplierFormPage({super.key, this.supplier});

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;

  bool get _isEditing => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.supplier?.nama ?? '');
    _teleponController = TextEditingController(
      text: widget.supplier?.telepon ?? '',
    );
    _alamatController = TextEditingController(
      text: widget.supplier?.alamat ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final supplier = Supplier(
      id: widget.supplier?.id,
      tokoId: widget.supplier?.tokoId ?? sl<TokoService>().tokoId ?? '',
      nama: _namaController.text.trim(),
      telepon: _teleponController.text.trim().isEmpty
          ? null
          : _teleponController.text.trim(),
      alamat: _alamatController.text.trim().isEmpty
          ? null
          : _alamatController.text.trim(),
    );

    if (_isEditing) {
      context.read<SupplierBloc>().add(UpdateSupplierEvent(supplier));
    } else {
      context.read<SupplierBloc>().add(AddSupplierEvent(supplier));
    }

    if (widget.supplier == null) {
      Navigator.pop(context, supplier);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Supplier' : 'Tambah Supplier'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Supplier *'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teleponController,
                decoration: const InputDecoration(
                  labelText: 'Telepon',
                  hintText: 'Opsional',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Opsional',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEditing ? 'Simpan' : 'Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
