import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/database/supplier_products_dao.dart';
import '../../../domain/entities/produk.dart';
import '../utils/dialog_utils.dart';
import '../../domain/usecases/produk/get_all_produk.dart';
import '../../domain/usecases/produk/search_produk.dart';

class CariProdukDialog extends StatefulWidget {
  final GetAllProduk getAllProduk;
  final SearchProduk searchProduk;
  final void Function(
    String produkId,
    String namaProduk,
    double harga,
    double hargaBeli,
    int qty, {
    String? satuanId,
    double konversi,
  }) onAddToCart;
  final bool isPembelian;
  final Future<void> Function(String query)? onAddNewProduct;
  final String? supplierId;

  const CariProdukDialog({
    super.key,
    required this.getAllProduk,
    required this.searchProduk,
    required this.onAddToCart,
    this.isPembelian = false,
    this.onAddNewProduct,
    this.supplierId,
  });

  @override
  State<CariProdukDialog> createState() => _CariProdukDialogState();
}

class _CariProdukDialogState extends State<CariProdukDialog> {
  final _searchController = TextEditingController();
  List<Produk> _products = [];
  Set<String> _supplierProductIds = {};
  bool _loading = true;
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<Set<String>> _getSupplierProductIds() async {
    if (widget.supplierId == null) return {};
    final dao = sl<SupplierProductsDao>();
    final ids = await dao.getProductsBySupplier(widget.supplierId!);
    return ids.toSet();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final products = await widget.getAllProduk();
      final supplierIds = await _getSupplierProductIds();
      final sorted = List<Produk>.from(products);
      sorted.sort((a, b) {
        final aIsSupplier = supplierIds.contains(a.id);
        final bIsSupplier = supplierIds.contains(b.id);
        if (aIsSupplier && !bIsSupplier) return -1;
        if (!aIsSupplier && bIsSupplier) return 1;
        return 0;
      });
      setState(() {
        _products = sorted;
        _supplierProductIds = supplierIds;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    try {
      final supplierIds = _supplierProductIds;
      List<Produk> results;
      if (query.isEmpty) {
        results = await widget.getAllProduk();
      } else {
        results = await widget.searchProduk(query);
      }
      results.sort((a, b) {
        final aIsSupplier = supplierIds.contains(a.id);
        final bIsSupplier = supplierIds.contains(b.id);
        if (aIsSupplier && !bIsSupplier) return -1;
        if (!aIsSupplier && bIsSupplier) return 1;
        return 0;
      });
      setState(() {
        _products = results;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _pilihProduk(Produk produk) {
    DialogUtils.showPilihSatuanDialog(
      context: context,
      produk: produk,
      isPembelian: widget.isPembelian,
      onSelected: (id, nama, harga, satuanId, konversi) {
        DialogUtils.showQuantityDialog(
          context: context,
          namaProduk: nama,
          onSubmitted: (qty) {
            widget.onAddToCart(
              id,
              nama,
              harga,
              produk.hargaBeli, // harga pokok dari entitas produk
              qty,
              satuanId: satuanId,
              konversi: konversi,
            );
            Navigator.pop(context);
          },
        );
      },
    );
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
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
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
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Produk tidak ditemukan',
                            style: TextStyle(color: AppTheme.grey),
                          ),
                          if (widget.isPembelian &&
                              widget.onAddNewProduct != null) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await widget.onAddNewProduct!(
                                  _searchController.text.trim(),
                                );
                                if (mounted) Navigator.pop(context);
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Tambah Barang Baru'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: AppTheme.onPrimary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final produk = _products[index];
                        final stokOk = produk.stok > 0;
                        final isFromSupplier =
                            _supplierProductIds.contains(produk.id);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: stokOk
                                ? AppTheme.lightGreen
                                : Colors.grey.shade200,
                            child: Text(
                              '${produk.stok}',
                              style: TextStyle(
                                fontSize: 11,
                                color: stokOk
                                    ? AppTheme.primaryGreen
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Flexible(child: Text(produk.nama)),
                              if (isFromSupplier) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Dari Supplier Ini',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            '${_currency.format(widget.isPembelian ? produk.hargaBeli : produk.hargaJual)} / ${produk.satuan}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: AppTheme.accentGreen,
                            ),
                            onPressed: () => _pilihProduk(produk),
                          ),
                          onTap: () => _pilihProduk(produk),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ),
        ],
      ),
    );
  }
}
