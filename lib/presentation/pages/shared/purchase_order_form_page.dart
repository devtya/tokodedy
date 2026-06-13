import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../widgets/barcode_scanner_widget.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/supplier.dart';
import '../../../domain/usecases/produk/get_produk_by_id.dart';
import '../../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../blocs/purchase_order/purchase_order_bloc.dart';
import '../../blocs/purchase_order/purchase_order_event.dart';
import '../../blocs/purchase_order/purchase_order_state.dart';
import '../../blocs/produk/produk_bloc.dart';
import '../../blocs/supplier/supplier_bloc.dart';
import '../../utils/dialog_utils.dart';
import 'supplier_page.dart';
import 'produk_form_page.dart';
import '../../widgets/cari_produk_dialog.dart';

import '../../../domain/entities/purchase_order.dart';
import '../../../domain/entities/purchase_order_item.dart';
import '../../../domain/repositories/purchase_order_repository.dart';

class PurchaseOrderFormPage extends StatefulWidget {
  final PurchaseOrder? initialPo;
  final List<PurchaseOrderItem>? initialItems;

  const PurchaseOrderFormPage({
    super.key,
    this.initialPo,
    this.initialItems,
  });

  @override
  State<PurchaseOrderFormPage> createState() => _PurchaseOrderFormPageState();
}

class _PurchaseOrderFormPageState extends State<PurchaseOrderFormPage> {
  Supplier? _selectedSupplier;
  final List<ItemPoForm> _items = [];
  final List<ItemPoForm> _movedToBesokItems = [];
  final _currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  final _searchController = TextEditingController();
  final _filterController = TextEditingController();
  String _searchQuery = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPo != null) {
      _selectedSupplier = Supplier(
        id: widget.initialPo!.supplierId ?? '',
        nama: widget.initialPo!.namaSupplier ?? '',
        telepon: '',
        alamat: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    if (widget.initialItems != null) {
      for (var item in widget.initialItems!) {
        _items.add(ItemPoForm(
          produkId: item.produkId,
          namaProduk: item.namaProduk ?? '',
          satuanName: '', // Bisa diambil dari ekstrak string
          qtyPesan: item.qtyPesan,
          hargaSatuan: item.hargaSatuan,
          totalHarga: item.subtotal,
          satuanId: item.satuanId,
          konversi: item.konversi,
        ));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  double get _total => _items.fold(0.0, (s, i) => s + i.subtotal);
  bool get _isFormValid => _items.isNotEmpty;

  Future<void> _addNewProduct(String nama) async {
    final isNumeric = double.tryParse(nama) != null;
    final produkBloc = sl<ProdukBloc>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: produkBloc,
          child: ProdukFormPage(
            initialName: isNumeric ? null : nama,
            initialBarcode: isNumeric ? nama : null,
          ),
        ),
      ),
    );

    if (result != null && result is List<String>) {
      for (final id in result) {
        final p = await sl<GetProdukById>()(id);
        if (p != null && mounted) {
          setState(() {
            _items.add(ItemPoForm(
              produkId: p.id!,
              namaProduk: p.nama,
              satuanName: p.satuan ?? 'pcs',
              qtyPesan: 1,
              hargaSatuan: p.hargaBeli,
              totalHarga: p.hargaBeli,
            ));
          });
        }
      }
    } else if (result != null && result is String) {
      final p = await sl<GetProdukById>()(result);
      if (p != null && mounted) {
        setState(() {
          _items.add(ItemPoForm(
            produkId: p.id!,
            namaProduk: p.nama,
            satuanName: p.satuan ?? 'pcs',
            qtyPesan: 1,
            hargaSatuan: p.hargaBeli,
            totalHarga: p.hargaBeli,
          ));
        });
      }
    }
  }

  Future<void> _openScanner() async {
    final barcode = await showBarcodeScannerDialog(context);
    if (barcode == null) return;
    final produk = await sl<GetProdukByBarcode>().call(barcode);
    if (!mounted) return;
    if (produk == null) {
      final tambah = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Produk Tidak Ditemukan'),
          content: Text('Produk dengan barcode $barcode belum terdaftar. Tambah barang baru?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Tambah Baru'),
            ),
          ],
        ),
      );

      if (tambah == true) {
        if (!mounted) return;
        final produkBloc2 = sl<ProdukBloc>();
        final newId = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: produkBloc2,
              child: ProdukFormPage(initialBarcode: barcode),
            ),
          ),
        );
        if (newId != null && newId is String) {
          final p = await sl<GetProdukById>()(newId);
          if (p != null && mounted) {
            setState(() {
              _items.add(ItemPoForm(
                produkId: p.id!,
                namaProduk: p.nama,
                satuanName: p.satuan ?? 'pcs',
                qtyPesan: 1,
                hargaSatuan: p.hargaBeli,
                totalHarga: p.hargaBeli,
              ));
            });
          }
        }
      }
      return;
    }

    DialogUtils.showPilihSatuanDialog(
      context: context,
      produk: produk,
      isPembelian: true,
      onSelected: (id, namaProduk, satuanName, harga, satuanId, konversi) {
        DialogUtils.showQuantityDialog(
          context: context,
          namaProduk: '$namaProduk - $satuanName',
          onSubmitted: (qty) {
            setState(() {
              final existing = _items.indexWhere(
                (i) => i.produkId == id && i.satuanId == satuanId,
              );
              if (existing != -1) {
                final existingItem = _items[existing];
                final newJumlah = existingItem.qtyPesan + qty;
                _items[existing] = existingItem.copyWith(
                  qtyPesan: newJumlah,
                  totalHarga: newJumlah * existingItem.hargaSatuan,
                );
              } else {
                _items.add(ItemPoForm(
                  produkId: id,
                  namaProduk: namaProduk,
                  satuanName: satuanName,
                  qtyPesan: qty,
                  hargaSatuan: harga,
                  totalHarga: qty * harga,
                  satuanId: satuanId,
                  konversi: konversi,
                ));
              }
            });
          },
        );
      },
    );
  }

  void _showEditItemDialog(int index, ItemPoForm item) {
    final qtyController = TextEditingController(text: item.qtyPesan.toString());
    final hargaController = TextEditingController(
      text: item.hargaSatuan.toStringAsFixed(2),
    );
    final totalController = TextEditingController(
      text: item.totalHarga.toStringAsFixed(0),
    );

    qtyController.selection = TextSelection(
      baseOffset: 0, extentOffset: qtyController.text.length,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit - ${item.namaProduk}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Harga Satuan', prefixText: 'Rp '),
              onChanged: (val) {
                final harga = double.tryParse(val) ?? 0;
                final qty = int.tryParse(qtyController.text) ?? 1;
                totalController.text = (harga * qty).toStringAsFixed(0);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Pesan'),
              onChanged: (val) {
                final qty = int.tryParse(val) ?? 1;
                final harga = double.tryParse(hargaController.text) ?? 0;
                totalController.text = (harga * qty).toStringAsFixed(0);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Harga', prefixText: 'Rp '),
              onChanged: (val) {
                final total = double.tryParse(val) ?? 0;
                final qty = int.tryParse(qtyController.text) ?? 1;
                if (qty > 0) {
                  hargaController.text = (total / qty).toStringAsFixed(2);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final newJumlah = int.tryParse(qtyController.text) ?? 1;
              final newTotal = double.tryParse(totalController.text) ?? (item.qtyPesan * item.hargaSatuan);
              if (newJumlah > 0 && newTotal >= 0) {
                final newHarga = newTotal / newJumlah;
                setState(() => _items[index] = item.copyWith(
                  qtyPesan: newJumlah,
                  hargaSatuan: newHarga,
                  totalHarga: newTotal,
                ));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _pilihSupplier() {
    Navigator.push<Supplier>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: sl<SupplierBloc>(),
          child: const SupplierPage(isPicking: true),
        ),
      ),
    ).then((supplier) {
      if (supplier != null) {
        setState(() => _selectedSupplier = supplier);
      }
    });
  }

  Future<void> _submit() async {
    if (_items.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tambahkan minimal 1 barang terlebih dahulu')),
        );
      }
      return;
    }

    if (_selectedSupplier == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih supplier terlebih dahulu')),
        );
      }
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Purchase Order'),
        content: Text('Buat Purchase Order dari ${_selectedSupplier!.nama} dengan total ${_currency.format(_total)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Buat PO'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    final bloc = context.read<PurchaseOrderBloc>();
    final itemsData = _items.map((i) => ItemPoData(
      produkId: i.produkId,
      namaProduk: i.namaProduk,
      qtyPesan: i.qtyPesan,
      hargaSatuan: i.hargaSatuan,
      subtotal: i.subtotal,
      satuanId: i.satuanId,
      konversi: i.konversi,
    )).toList();

    setState(() => _isSaving = true);
    if (widget.initialPo != null) {
      bloc.add(EditPurchaseOrderEvent(
        poId: widget.initialPo!.id!,
        supplierId: _selectedSupplier!.id,
        namaSupplier: _selectedSupplier!.nama,
        items: itemsData,
      ));
    } else {
      bloc.add(AddPurchaseOrderEvent(
        supplierId: _selectedSupplier!.id,
        namaSupplier: _selectedSupplier!.nama,
        items: itemsData,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialPo != null;
    return BlocListener<PurchaseOrderBloc, PurchaseOrderState>(
      listener: (context, state) async {
        if (state is PurchaseOrderSuccess) {
          _isSaving = false;
          if (_movedToBesokItems.isNotEmpty) {
            try {
              final repo = sl<PurchaseOrderRepository>();
              final po = PurchaseOrder(
                supplierId: _selectedSupplier?.id,
                namaSupplier: _selectedSupplier?.nama,
                status: 'open',
                totalHarga: _movedToBesokItems.fold(0.0, (s, i) => s + i.totalHarga),
                notes: 'Draft PO Besok',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              final newPoId = await repo.addPurchaseOrder(po);
              for (final item in _movedToBesokItems) {
                await repo.addPurchaseOrderItem(
                  PurchaseOrderItem(
                    poId: newPoId,
                    produkId: item.produkId,
                    namaProduk: item.namaProduk,
                    qtyPesan: item.qtyPesan,
                    hargaSatuan: item.hargaSatuan,
                    subtotal: item.totalHarga,
                    satuanId: item.satuanId,
                    konversi: item.konversi,
                  ),
                );
              }
            } catch (e) {
              debugPrint('Gagal menyimpan PO Besok: $e');
            }
          }
          if (context.mounted && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          }
        } else if (state is PurchaseOrderError) {
          _isSaving = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal: ${state.message}'), backgroundColor: AppTheme.warningRed),
            );
          }
        }
      },
      child: PopScope(
        canPop: true,
        child: Scaffold(
          appBar: AppBar(title: Text(isEdit ? 'Edit Purchase Order' : 'Buat Purchase Order')),
          body: Column(
            children: [
              _buildSupplierSection(),
              _buildSearchSection(),
              Expanded(child: _buildCartList()),
              _buildBottomPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: InkWell(
        onTap: _pilihSupplier,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _selectedSupplier != null ? AppTheme.primary : AppTheme.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.store, size: 18, color: _selectedSupplier != null ? AppTheme.primary : AppTheme.neutralGrey),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUPPLIER',
                      style: TextStyle(
                        color: _selectedSupplier != null ? AppTheme.primary : AppTheme.neutralGrey,
                        fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      _selectedSupplier?.nama ?? 'Ketuk untuk memilih supplier',
                      style: TextStyle(
                        color: _selectedSupplier != null ? Colors.white : AppTheme.neutralGrey,
                        fontSize: 14, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.neutralGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _openCariProduk() {
    showDialog(
      context: context,
      builder: (ctx) => CariProdukDialog(
        getAllProduk: sl(),
        searchProduk: sl(),
        isPembelian: true,
        supplierId: _selectedSupplier?.id,
        onAddToCart: (id, namaProduk, satuanName, hargaJual, hargaBeli, qty, {String? satuanId, double konversi = 1.0}) {
          setState(() {
            final existing = _items.indexWhere(
              (i) => i.produkId == id && i.satuanId == satuanId,
            );
            if (existing != -1) {
              final existingItem = _items[existing];
              final newJumlah = existingItem.qtyPesan + qty;
              _items[existing] = existingItem.copyWith(
                qtyPesan: newJumlah,
                totalHarga: newJumlah * existingItem.hargaSatuan,
              );
            } else {
              _items.add(ItemPoForm(
                produkId: id,
                namaProduk: namaProduk,
                satuanName: satuanName,
                qtyPesan: qty,
                hargaSatuan: hargaBeli,
                totalHarga: qty * hargaBeli,
                satuanId: satuanId,
                konversi: konversi,
              ));
            }
          });
        },
        onAddNewProduct: (query) async {
          Navigator.pop(ctx);
          await _addNewProduct(query);
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            readOnly: true,
            onTap: _openCariProduk,
            decoration: InputDecoration(
              hintText: 'Tambah Produk (Cari / Scan)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _openScanner,
              ),
            ),
          ),
        ),
        if (_items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _filterController,
              decoration: InputDecoration(
                hintText: 'Filter di keranjang...',
                prefixIcon: const Icon(Icons.filter_list, size: 20),
                isDense: true,
                filled: true,
                fillColor: AppTheme.surface,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _filterController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCartList() {
    if (_items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada item', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Cari produk untuk memulai', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }
    
    final displayItems = _searchQuery.isEmpty 
        ? _items 
        : _items.where((i) => i.namaProduk.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: displayItems.length,
      onReorder: (oldIndex, newIndex) {
        if (_searchQuery.isNotEmpty) return; // Disable reorder while filtering
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return Card(
          key: ValueKey('${item.produkId}_${item.satuanId}'),
          margin: const EdgeInsets.only(bottom: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.namaProduk,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (val) {
                        if (val == 'pending') {
                          setState(() {
                            _movedToBesokItems.add(item);
                            _items.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Produk dipindah ke antrean PO Besok')),
                          );
                        } else if (val == 'delete') {
                          setState(() => _items.removeAt(index));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'pending',
                          child: Text('Pindah ke PO Besok'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus Permanen', style: TextStyle(color: AppTheme.warningRed)),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showEditItemDialog(index, item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 12, color: AppTheme.neutralGrey),
                              const SizedBox(width: 4),
                              Text(
                                '${_currency.format(item.hargaSatuan)} / ${item.satuanName}',
                                style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currency.format(item.subtotal),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.satuanName,
                      style: const TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: OutlinedButton(
                            onPressed: () {
                              if (item.qtyPesan > 1) {
                                final newQty = item.qtyPesan - 1;
                                setState(() => _items[index] = item.copyWith(
                                  qtyPesan: newQty,
                                  totalHarga: newQty * item.hargaSatuan,
                                ));
                              } else {
                                setState(() => _items.removeAt(index));
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(30, 30),
                              side: const BorderSide(color: AppTheme.neutralGrey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Icon(Icons.remove, size: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.qtyPesan}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              final newQty = item.qtyPesan + 1;
                              setState(() => _items[index] = item.copyWith(
                                qtyPesan: newQty,
                                totalHarga: newQty * item.hargaSatuan,
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(30, 30),
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              elevation: 0,
                            ),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                _currency.format(_total),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isFormValid && !_isSaving) ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid ? AppTheme.primary : Colors.grey.shade600,
                foregroundColor: _isFormValid ? AppTheme.onPrimary : Colors.white38,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(widget.initialPo != null ? 'Simpan Perubahan' : 'Buat Purchase Order'),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemPoForm {
  final String produkId;
  final String namaProduk;
  final String satuanName;
  final int qtyPesan;
  final double hargaSatuan;
  final double totalHarga;
  final String? satuanId;
  final double konversi;

  const ItemPoForm({
    required this.produkId,
    required this.namaProduk,
    required this.satuanName,
    required this.qtyPesan,
    required this.hargaSatuan,
    required this.totalHarga,
    this.satuanId,
    this.konversi = 1.0,
  });

  double get subtotal => totalHarga;

  ItemPoForm copyWith({
    String? produkId,
    String? namaProduk,
    String? satuanName,
    int? qtyPesan,
    double? hargaSatuan,
    double? totalHarga,
    String? satuanId,
    double? konversi,
  }) {
    return ItemPoForm(
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      satuanName: satuanName ?? this.satuanName,
      qtyPesan: qtyPesan ?? this.qtyPesan,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      totalHarga: totalHarga ?? this.totalHarga,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
    );
  }
}


