import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/database/supplier_products_dao.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/usecases/supplier/get_all_supplier.dart';
import '../../domain/usecases/supplier/search_supplier.dart';

class SupplierKonfirmasiDialog extends StatefulWidget {
  final Supplier? preSelectedSupplier;
  final GetAllSupplier getAllSupplier;
  final SearchSupplier searchSupplier;
  final SupplierProductsDao supplierProductsDao;

  const SupplierKonfirmasiDialog({
    super.key,
    this.preSelectedSupplier,
    required this.getAllSupplier,
    required this.searchSupplier,
    required this.supplierProductsDao,
  });

  @override
  State<SupplierKonfirmasiDialog> createState() =>
      _SupplierKonfirmasiDialogState();
}

class _SupplierKonfirmasiDialogState extends State<SupplierKonfirmasiDialog> {
  final _searchController = TextEditingController();
  List<Supplier> _suppliers = [];
  Supplier? _selectedSupplier;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedSupplier = widget.preSelectedSupplier;
    _loadSuppliers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortSuppliers(List<Supplier> list) {
    if (_selectedSupplier != null) {
      final id = _selectedSupplier!.id;
      _suppliers = [
        ...list.where((s) => s.id == id),
        ...list.where((s) => s.id != id),
      ];
    } else {
      _suppliers = list;
    }
  }

  Future<void> _loadSuppliers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final suppliers = await widget.getAllSupplier();
      setState(() {
        _sortSuppliers(suppliers);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Gagal memuat supplier';
      });
    }
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (query.isEmpty) {
        final suppliers = await widget.getAllSupplier();
        setState(() {
          _sortSuppliers(suppliers);
          _loading = false;
        });
      } else {
        final results = await widget.searchSupplier(query);
        setState(() {
          _sortSuppliers(results);
          _loading = false;
        });
      }
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'Gagal mencari supplier';
      });
    }
  }

  void _konfirmasi() {
    if (_selectedSupplier == null) {
      setState(() => _error = 'Pilih supplier terlebih dahulu');
      return;
    }
    Navigator.pop(context, _selectedSupplier);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                const Text(
                  'Konfirmasi Supplier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari supplier...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _search('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    _search(value);
                  },
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _error!,
                style: const TextStyle(color: AppTheme.warningRed, fontSize: 13),
              ),
            ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _suppliers.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada supplier',
                            style: TextStyle(color: AppTheme.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _suppliers.length,
                          itemBuilder: (context, index) {
                            final supplier = _suppliers[index];
                            final isSelected =
                                _selectedSupplier?.id == supplier.id;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.surface,
                                child: Icon(
                                  Icons.store,
                                  size: 18,
                                  color: isSelected
                                      ? AppTheme.onPrimary
                                      : AppTheme.neutralGrey,
                                ),
                              ),
                              title: Text(supplier.nama),
                              subtitle: supplier.telepon != null
                                  ? Text(
                                      supplier.telepon!,
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  : null,
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedSupplier = supplier;
                                  _error = null;
                                });
                              },
                            );
                          },
                        ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _konfirmasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Konfirmasi Simpan'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
