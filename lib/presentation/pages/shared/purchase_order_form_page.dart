import 'package:flutter/material.dart';
import 'purchase_order_cart_page.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../widgets/barcode_scanner_widget.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/supplier.dart';
import '../../../domain/usecases/produk/get_produk_by_id.dart';
import '../../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../blocs/purchase_order/purchase_order_bloc.dart';
import '../../blocs/purchase_order/purchase_order_state.dart';
import '../../blocs/produk/produk_bloc.dart';
import '../../blocs/supplier/supplier_bloc.dart';
import '../../utils/dialog_utils.dart';
import 'supplier_page.dart';
import 'produk_form_page.dart';
import '../../widgets/cari_produk_dialog.dart';

import '../../../domain/entities/purchase_order.dart';
import '../../../domain/entities/purchase_order_item.dart';
import '../../../domain/entities/satuan_produk.dart';
import '../../../domain/entities/produk.dart';

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

  List<Produk> _allProducts = [];
  List<Produk> _filtered = [];
  bool _loading = true;
  Timer? _debounce;
  final Map<String, int> _tempQty = {};
  final Map<String, SatuanProduk?> _tempSatuan = {};


  @override
  void initState() {
    super.initState();
    _loadProducts();
    if (widget.initialPo != null) {
      _selectedSupplier = Supplier(
        id: widget.initialPo!.supplierId ?? '',
        nama: widget.initialPo!.namaSupplier ?? '',
        telepon: '',
        alamat: '',
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
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



  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchaseOrderBloc, PurchaseOrderState>(
      listener: (context, state) {
        if (!_isSaving) return;
        if (state is PurchaseOrderSuccess) {
          _isSaving = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context); // pop cart sheet
            Navigator.pop(context); // pop PO form -> back to PO list
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.initialPo != null ? 'Edit Purchase Order' : 'Buat Purchase Order'),
        ),
        body: Column(
          children: [
            _buildSupplierSection(),
            _buildSearchBox(),
            Expanded(child: _buildProductList()),
            _buildBottomBar(),
          ],
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

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final products = await sl<GetAllProduk>()();
      final active = products.where((p) => !p.isArchived).toList()
        ..sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
      if (!mounted) return;
      setState(() {
        _allProducts = active;
        _filtered = active;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() => _filtered = _allProducts);
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _filtered = _allProducts.where((p) {
        return p.nama.toLowerCase().contains(q) ||
               (p.barcode?.toLowerCase().contains(q) ?? false);
      }).toList();
    });
  }

  int _getQty(Produk p) => _tempQty[p.id!] ?? 1;
  SatuanProduk? _getSatuan(Produk p) => _tempSatuan[p.id!];
  
  String _satuanName(Produk p) {
    final s = _getSatuan(p);
    return s != null ? s.nama : (p.satuan ?? 'pcs');
  }
  
  double _hargaFor(Produk p) {
    final s = _getSatuan(p);
    return s != null && s.hargaBeli > 0 ? s.hargaBeli : (p.hargaBeli * (s?.konversi ?? 1.0));
  }

  void _incQty(Produk p) {
    setState(() {
      _tempQty[p.id!] = _getQty(p) + 1;
    });
  }

  void _decQty(Produk p) {
    setState(() {
      final current = _getQty(p);
      if (current > 1) {
        _tempQty[p.id!] = current - 1;
      }
    });
  }
  
  void _showQtyInputDialog(Produk produk) {
    final qtyController = TextEditingController(text: _getQty(produk).toString());
    qtyController.selection = TextSelection(baseOffset: 0, extentOffset: qtyController.text.length);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Jumlah ${produk.nama}'),
        content: TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Jumlah'),
          onSubmitted: (val) {
            final q = int.tryParse(val) ?? 1;
            if (q > 0) {
              setState(() => _tempQty[produk.id!] = q);
            }
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              final q = int.tryParse(qtyController.text) ?? 1;
              if (q > 0) {
                setState(() => _tempQty[produk.id!] = q);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSatuanPicker(Produk produk) {
    final satuanList = produk.satuanList ?? [];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Pilih Satuan - ${produk.nama}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text('${produk.nama} (${produk.satuan ?? 'pcs'})'),
                subtitle: const Text('Satuan Dasar (Konversi: 1)'),
                onTap: () {
                  setState(() => _tempSatuan[produk.id!] = null);
                  Navigator.pop(ctx);
                },
              ),
              ...satuanList.map((s) => ListTile(
                title: Text(s.nama),
                subtitle: Text('Konversi: ${s.konversi.toInt()} ${produk.satuan ?? 'pcs'}'),
                onTap: () {
                  setState(() => _tempSatuan[produk.id!] = s);
                  Navigator.pop(ctx);
                },
              )),
            ],
          ),
        );
      },
    );
  }
  
  void _addToCart(Produk produk) {
    final qty = _getQty(produk);
    final satuan = _getSatuan(produk);
    final harga = _hargaFor(produk);
    
    setState(() {
      final existingIndex = _items.indexWhere(
        (i) => i.produkId == produk.id && i.satuanId == satuan?.id,
      );
      if (existingIndex != -1) {
        final ex = _items[existingIndex];
        final newQty = ex.qtyPesan + qty;
        _items[existingIndex] = ex.copyWith(
          qtyPesan: newQty,
          totalHarga: newQty * ex.hargaSatuan,
        );
      } else {
        _items.add(
          ItemPoForm(
            produkId: produk.id!,
            namaProduk: produk.nama,
            satuanName: satuan?.nama ?? (produk.satuan ?? 'pcs'),
            qtyPesan: qty,
            hargaSatuan: harga,
            totalHarga: qty * harga,
            satuanId: satuan?.id,
            konversi: satuan?.konversi ?? 1.0,
          ),
        );
      }
      _tempQty[produk.id!] = 1;
    });
    
    _showTopToast(context, '$qty ${_satuanName(produk)} ${produk.nama} ditambahkan ke PO');
  }

  void _showTopToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 60,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 1), () => entry.remove());
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProducts('');
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                setState(() {});
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  _filterProducts(query);
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _openScanner,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_filtered.isEmpty) return const Center(child: Text('Produk tidak ditemukan', style: TextStyle(color: AppTheme.grey)));
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _filtered.length,
      itemBuilder: (context, index) => _buildProductCard(_filtered[index]),
    );
  }
  
  Widget _buildProductCard(Produk produk) {
    final cardColor = Theme.of(context).cardColor;
    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produk.nama,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  _currency.format(_hargaFor(produk)),
                  style: const TextStyle(
                    color: AppTheme.lightGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Stok: ${produk.stok}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                InkWell(
                  onTap: () => _showSatuanPicker(produk),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _satuanName(produk),
                          style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.primary),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: () => _decQty(produk),
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                ),
                GestureDetector(
                  onTap: () => _showQtyInputDialog(produk),
                  child: SizedBox(
                    width: 40,
                    child: Text(
                      '${_getQty(produk)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => _incQty(produk),
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: () => _addToCart(produk),
                  icon: const Icon(Icons.add_shopping_cart, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
  void _openCartPage() async {
    final purchaseOrderBloc = context.read<PurchaseOrderBloc>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: purchaseOrderBloc,
          child: PurchaseOrderCartPage(
          items: _items,
          selectedSupplier: _selectedSupplier,
          initialPo: widget.initialPo,
          catatNotes: '',
        ),
      ),
      ),
    );

    if (result == 'success') {
      setState(() {
        _items.clear();
        _selectedSupplier = null;
      });
      Navigator.pop(context, true);
    } else if (result is Map<String, dynamic>) {
      setState(() {
        _items.clear();
        _items.addAll(result['items'] as List<ItemPoForm>);
      });
    }
  }

  Widget _buildBottomBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_items.length} item', style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    _currency.format(_total),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _items.isEmpty ? null : _openCartPage,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Buat PO'),
            ),
          ],
        ),
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


