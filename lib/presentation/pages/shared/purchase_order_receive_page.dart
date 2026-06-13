import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/purchase_order.dart';
import '../../../domain/entities/purchase_order_item.dart';
import '../../../domain/repositories/purchase_order_repository.dart';
import '../../../domain/usecases/stok/terima_purchase_order.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/entities/produk.dart';
import '../../widgets/price_validation_dialog.dart';


class PurchaseOrderReceivePage extends StatefulWidget {
  final String poId;

  const PurchaseOrderReceivePage({super.key, required this.poId});

  @override
  State<PurchaseOrderReceivePage> createState() => _PurchaseOrderReceivePageState();
}

class _PurchaseOrderReceivePageState extends State<PurchaseOrderReceivePage> {
  final _currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  PurchaseOrder? _po;
  List<PurchaseOrderItem> _items = [];
  final Map<String, TextEditingController> _terimaControllers = {};
  final _filterController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = sl<PurchaseOrderRepository>();
    final po = await repo.getPurchaseOrderById(widget.poId);
    final items = await repo.getItemsByPoId(widget.poId);

    if (mounted) {
      setState(() {
        _po = po;
        _items = items;
        _isLoading = false;
        for (final item in items) {
          final sisa = item.qtyPesan - item.qtyTerima;
          _terimaControllers[item.id!] = TextEditingController(text: sisa.toString());
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _terimaControllers.values) {
      c.dispose();
    }
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final itemsTerima = <ItemTerima>[];
    bool hasItems = false;

    for (final item in _items) {
      final controller = _terimaControllers[item.id!];
      if (controller == null) continue;
      final qtyTerima = int.tryParse(controller.text) ?? 0;
      if (qtyTerima > 0) {
        hasItems = true;
        itemsTerima.add(ItemTerima(
          poItemId: item.id!,
          produkId: item.produkId,
          qtyTerima: qtyTerima,
          satuanId: item.satuanId,
          konversi: item.konversi,
          hargaBeliBaru: item.hargaSatuan,
        ));
      }
    }

    if (!hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada item yang diterima')),
      );
      return;
    }

    if (!_isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Qty terima tidak boleh melebihi sisa pesanan'),
          backgroundColor: AppTheme.warningRed,
        ),
      );
      return;
    }

    final allProduk = await sl<GetAllProduk>().call();
    if (!mounted) return;
    final Map<String, Produk> produkMap = {for (var p in allProduk) p.id!: p};
    
    final List<PurchaseOrderItem> zeroPriceItems = [];
    final List<PriceValidationItem> changedItems = [];

    for (final terima in itemsTerima) {
      final p = produkMap[terima.produkId];
      if (p != null) {
        final s = p.satuanList?.where((sl) => sl.id == terima.satuanId).firstOrNull;
        final hJual = s != null ? s.hargaJual : (p.hargaJual * terima.konversi);
        if (hJual <= 0) {
          final poItem = _items.firstWhere((i) => i.id == terima.poItemId);
          zeroPriceItems.add(poItem);
        }
        
        final hargaBeliLama = s != null ? s.hargaBeli : (p.hargaBeli * terima.konversi);
        if (terima.hargaBeliBaru != null && terima.hargaBeliBaru! > hargaBeliLama) {
          changedItems.add(PriceValidationItem(
            produkId: terima.produkId,
            konversi: terima.konversi,
            hargaBeliSatuan: terima.hargaBeliBaru!,
          ));
        }
      }
    }

    if (zeroPriceItems.isNotEmpty) {
      final errList = zeroPriceItems.map((e) => '- ${e.namaProduk ?? e.produkId} (${e.satuanId == null ? "dasar" : "konversi"})').join('\n');
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Harga Jual 0'),
          content: Text(
            'Ada item dengan satuan yang belum memiliki harga jual (Rp 0):\n\n$errList\n\nPastikan untuk mengatur harga jual di menu Produk nanti. Tetap lanjutkan penerimaan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warningRed),
              child: const Text('Tetap Lanjutkan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    if (changedItems.isNotEmpty) {
      if (!mounted) return;
      final proceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PriceValidationDialog(
          changedItems: changedItems,
          produkMap: produkMap,
        ),
      );
      if (proceed != true) return;
    }

    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Penerimaan'),
        content: Text('Terima ${itemsTerima.length} item dari ${_po?.namaSupplier ?? "Supplier"}? Pembelian akan dibuat otomatis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen, foregroundColor: Colors.white),
            child: const Text('Terima Barang'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    setState(() => _isSaving = true);
    try {
      final usecase = sl<TerimaPurchaseOrder>();
      await usecase(poId: widget.poId, itemsTerima: itemsTerima);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barang diterima, pembelian berhasil dibuat'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: AppTheme.warningRed),
        );
      }
    }
  }

  bool _isValid() {
    for (final item in _items) {
      final controller = _terimaControllers[item.id!];
      if (controller == null) continue;
      final qtyTerima = int.tryParse(controller.text) ?? 0;
      final sisa = item.qtyPesan - item.qtyTerima;
      if (qtyTerima > sisa) return false;
      if (qtyTerima < 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terima Barang - ${_po?.namaSupplier ?? "PO"}'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  void _showEditHargaDialog(int index, PurchaseOrderItem item) {
    final hargaCtrl = TextEditingController(text: item.hargaSatuan.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Harga Beli'),
        content: TextField(
          controller: hargaCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Harga Beli Baru',
            prefixText: 'Rp ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newHarga = double.tryParse(hargaCtrl.text) ?? item.hargaSatuan;
              setState(() {
                final globalIndex = _items.indexWhere((i) => i.id == item.id);
                if (globalIndex != -1) {
                  _items[globalIndex] = _items[globalIndex].copyWith(hargaSatuan: newHarga);
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final totalPesan = _items.fold(0.0, (s, i) => s + i.subtotal);
    double totalTerima = 0;
    for (final item in _items) {
      final ctrl = _terimaControllers[item.id!];
      final qty = int.tryParse(ctrl?.text ?? '0') ?? 0;
      totalTerima += qty * item.hargaSatuan;
    }

    final displayItems = _searchQuery.isEmpty 
        ? _items 
        : _items.where((i) => (i.namaProduk ?? '').toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Column(
      children: [
        if (_items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: displayItems.length,
            onReorder: (oldIndex, newIndex) {
              if (_searchQuery.isNotEmpty) return;
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final item = displayItems[index];
              final sisa = item.qtyPesan - item.qtyTerima;
              return Card(
                key: ValueKey('${item.id}'),
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaProduk ?? 'Produk #${item.produkId}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesan: ${item.qtyPesan}x',
                                  style: const TextStyle(fontSize: 13, color: AppTheme.neutralGrey),
                                ),
                                if (item.qtyTerima > 0)
                                  Text(
                                    'Sudah diterima: ${item.qtyTerima}x',
                                    style: const TextStyle(fontSize: 13, color: AppTheme.primaryGreen),
                                  ),
                                Text(
                                  'Sisa: ${sisa}x',
                                  style: TextStyle(fontSize: 13, color: sisa > 0 ? AppTheme.warningRed : AppTheme.primaryGreen),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => _showEditHargaDialog(index, item),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit, size: 12, color: AppTheme.neutralGrey),
                                      const SizedBox(width: 4),
                                      Text(
                                        _currency.format(item.hargaSatuan),
                                        style: const TextStyle(fontSize: 13, color: AppTheme.primaryGreen),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (item.satuanId != null)
                                Text(
                                  '/ ${item.namaProduk?.split(' - ').last ?? item.satuanId!}',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.neutralGrey),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Terima:', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: _terimaControllers[item.id!],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'maks ${sisa}x',
                            style: const TextStyle(fontSize: 11, color: AppTheme.neutralGrey),
                          ),
                          const Spacer(),
                          Text(
                            _currency.format(
                              (int.tryParse(_terimaControllers[item.id!]?.text ?? '0') ?? 0) * item.hargaSatuan,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
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
                  const Text('Total Pesanan:', style: TextStyle(color: AppTheme.neutralGrey)),
                  Text(_currency.format(totalPesan), style: const TextStyle(color: AppTheme.neutralGrey)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Diterima:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    _currency.format(totalTerima),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.inventory_2),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Terima & Buat Pembelian'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
