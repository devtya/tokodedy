import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/barcode_scanner_widget.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/supplier_products_dao.dart';
import '../../domain/entities/produk.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/usecases/produk/get_all_produk.dart';
import '../../domain/usecases/produk/update_produk.dart';
import '../../domain/usecases/produk/get_produk_by_id.dart';
import '../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../domain/entities/notifikasi.dart';
import '../../domain/usecases/notifikasi/add_notifikasi.dart';
import '../../domain/repositories/produk_repository.dart';
import '../utils/dialog_utils.dart';
import '../blocs/pembelian/pembelian_bloc.dart';
import '../blocs/pembelian/pembelian_event.dart';
import '../blocs/pembelian/pembelian_state.dart';
import '../blocs/produk/produk_bloc.dart';
import '../blocs/supplier/supplier_bloc.dart';
import 'produk_form_page.dart';
import 'supplier_page.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../../domain/repositories/pembelian_repository.dart';
import '../../domain/repositories/pending_pembelian_repository.dart';
import '../../domain/entities/pending_pembelian.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/cari_produk_dialog.dart';
import '../widgets/supplier_konfirmasi_dialog.dart';
import 'pending_pembelian_page.dart';
import '../../core/services/toko_service.dart';

class PembelianFormPage extends StatefulWidget {
  final String? pendingId;
  final String? existingPembelianId;
  const PembelianFormPage({
    super.key,
    this.pendingId,
    this.existingPembelianId,
  });

  @override
  State<PembelianFormPage> createState() => _PembelianFormPageState();
}

class _PembelianFormPageState extends State<PembelianFormPage> {
  Supplier? _selectedSupplier;
  final List<_ItemPembelian> _items = [];
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _searchController = TextEditingController();

  bool _isPpnEnabled = false;
  double _ppnPercent = 11.0;
  final TextEditingController _ppnController = TextEditingController(
    text: '11',
  );

  bool _forcePop = false;
  String? _pembelianId;
  bool _isSaving = false;
  List<_ItemPembelian>? _pendingSaveItems;
  String? _pendingSaveSupplierId;

  @override
  void initState() {
    super.initState();
    if (widget.pendingId != null) {
      _loadPending(widget.pendingId!);
    } else if (widget.existingPembelianId != null) {
      _loadExisting(widget.existingPembelianId!);
    }
  }

  Future<void> _loadPending(String id) async {
    final pendingRepo = sl<PendingPembelianRepository>();
    final pending = await pendingRepo.getPendingById(id);
    if (pending != null) {
      final items = await pendingRepo.getItemsByPendingId(id);

      Supplier? supplier;
      if (pending.supplierId != null) {
        final supplierRepo = sl<SupplierRepository>();
        supplier = await supplierRepo.getSupplierById(pending.supplierId!);
      }

      if (mounted) {
        setState(() {
          _selectedSupplier = supplier;
          _isPpnEnabled = pending.isPpnEnabled;
          _ppnPercent = pending.ppnPercent;
          _ppnController.text = _ppnPercent.toStringAsFixed(0);

          _items.clear();
          for (final item in items) {
            _items.add(
              _ItemPembelian(
                produkId: item.produkId,
                namaProduk: item.namaProduk,
                jumlah: item.jumlah,
                hargaBeliSatuan: item.hargaBeliSatuan,
                hargaBeliLama: item.hargaBeliLama,
                totalHarga: item.jumlah * item.hargaBeliSatuan,
                diskonTipe: item.diskonTipe,
                diskonValue: item.diskonValue,
              ),
            );
          }
        });
      }
      await pendingRepo.deletePending(id);
    }
  }

  Future<void> _loadExisting(String id) async {
    final repo = sl<PembelianRepository>();
    final pembelian = await repo.getPembelianById(id);
    if (pembelian == null) return;

    final items = await repo.getItemsByPembelianId(id);

    Supplier? supplier;
    final supplierRepo = sl<SupplierRepository>();
    final allSupplier = await supplierRepo.getAllSupplier();
    supplier = allSupplier.where(
      (s) => s.nama == pembelian.namaSupplier,
    ).firstOrNull;

    if (mounted) {
      setState(() {
        _pembelianId = id;
        _selectedSupplier = supplier;

        _items.clear();
        for (final item in items) {
          _items.add(
            _ItemPembelian(
              produkId: item.produkId,
              namaProduk: item.namaProduk ?? '',
              jumlah: item.jumlah,
              hargaBeliSatuan: item.hargaBeliSatuan,
              hargaBeliLama: item.hargaBeliSatuan,
              totalHarga: item.subtotal,
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _ppnController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  double get _total => _items.fold(0.0, (s, i) => s + i.subtotal);
  double get _totalDiskon => _items.fold(0.0, (s, i) => s + i.diskonRp);
  double get _totalPpn =>
      _isPpnEnabled ? ((_total - _totalDiskon) * _ppnPercent / 100) : 0.0;
  double get _totalFinal => (_total - _totalDiskon) + _totalPpn;
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
            _items.add(
              _ItemPembelian(
                produkId: p.id!,
                namaProduk: p.nama,
                jumlah: 1,
                hargaBeliSatuan: p.hargaBeli,
                hargaBeliLama: p.hargaBeli,
                totalHarga: 1 * p.hargaBeli,
              ),
            );
          });
        }
      }
    } else if (result != null && result is String) {
      final p = await sl<GetProdukById>()(result);
      if (p != null && mounted) {
        setState(() {
          _items.add(
            _ItemPembelian(
              produkId: p.id!,
              namaProduk: p.nama,
              jumlah: 1,
              hargaBeliSatuan: p.hargaBeli,
              hargaBeliLama: p.hargaBeli,
              totalHarga: 1 * p.hargaBeli,
            ),
          );
        });
      }
      return;
    }
  }

  Future<void> _openScanner() async {
    final barcode = await showBarcodeScannerDialog(context);
    if (barcode == null) return;
    final produk = await sl<GetProdukByBarcode>().call(barcode);
    if (produk == null) {
      final tambah = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Produk Tidak Ditemukan'),
          content: Text(
            'Produk dengan barcode $barcode belum terdaftar. Tambah barang baru?',
          ),
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
              _items.add(
                _ItemPembelian(
                  produkId: p.id!,
                  namaProduk: p.nama,
                  jumlah: 1,
                  hargaBeliSatuan: p.hargaBeli,
                  hargaBeliLama: p.hargaBeli,
                  totalHarga: 1 * p.hargaBeli,
                ),
              );
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
      onSelected: (id, nama, harga, satuanId, konversi) {
        DialogUtils.showQuantityDialog(
          context: context,
          namaProduk: nama,
          onSubmitted: (qty) {
            setState(() {
              final existing = _items.indexWhere(
                (i) => i.produkId == id && i.satuanId == satuanId,
              );
              if (existing != -1) {
                final existingItem = _items[existing];
                final newJumlah = existingItem.jumlah + qty;
                _items[existing] = existingItem.copyWith(
                  jumlah: newJumlah,
                  totalHarga: newJumlah * existingItem.hargaBeliSatuan,
                );
              } else {
                _items.add(
                  _ItemPembelian(
                    produkId: id,
                    namaProduk: nama,
                    jumlah: qty,
                    hargaBeliSatuan: harga,
                    hargaBeliLama: harga,
                    totalHarga: qty * harga,
                    satuanId: satuanId,
                    konversi: konversi,
                  ),
                );
              }
            });
          },
        );
      },
    );
  }

  void _showDiskonDialog(int index, _ItemPembelian item) {
    final valueController = TextEditingController();
    int tipe = item.diskonTipe;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Diskon - ${item.namaProduk}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Tidak')),
                  ButtonSegment(value: 1, label: Text('%')),
                  ButtonSegment(value: 2, label: Text('Rp')),
                ],
                selected: {tipe},
                onSelectionChanged: (v) => setDialogState(() => tipe = v.first),
              ),
              const SizedBox(height: 12),
              if (tipe > 0)
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: tipe == 1 ? 'Persen (%)' : 'Nominal (Rp)',
                    hintText: tipe == 1 ? '10' : '5000',
                  ),
                  keyboardType: TextInputType.number,
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
                final value = double.tryParse(valueController.text) ?? 0;
                setState(() {
                  _items[index] = item.copyWith(
                    diskonTipe: tipe,
                    diskonValue: value,
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditItemDialog(int index, _ItemPembelian item) {
    final qtyController = TextEditingController(text: item.jumlah.toString());
    final hargaController = TextEditingController(
      text: item.hargaBeliSatuan.toStringAsFixed(2),
    );
    final totalController = TextEditingController(
      text: item.totalHarga.toStringAsFixed(0),
    );

    qtyController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: qtyController.text.length,
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
              decoration: const InputDecoration(
                labelText: 'Harga Beli Satuan',
                prefixText: 'Rp ',
              ),
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
              decoration: const InputDecoration(labelText: 'Jumlah Item'),
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
              decoration: const InputDecoration(
                labelText: 'Total Harga',
                prefixText: 'Rp ',
              ),
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
              final newTotal = double.tryParse(totalController.text) ??
                  (item.jumlah * item.hargaBeliSatuan);
              if (newJumlah > 0 && newTotal >= 0) {
                final newHarga = newTotal / newJumlah;
                setState(
                  () => _items[index] = item.copyWith(
                    jumlah: newJumlah,
                    hargaBeliSatuan: newHarga,
                    totalHarga: newTotal,
                  ),
                );
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
          const SnackBar(
            content: Text('Tambahkan minimal 1 barang terlebih dahulu'),
          ),
        );
      }
      return;
    }

    final supplier = await showDialog<Supplier>(
      context: context,
      builder: (ctx) => SupplierKonfirmasiDialog(
        preSelectedSupplier: _selectedSupplier,
        getAllSupplier: sl(),
        searchSupplier: sl(),
        supplierProductsDao: sl(),
      ),
    );

    if (supplier == null) return;
    if (!mounted) return;

    setState(() => _selectedSupplier = supplier);

    final authState = context.read<AuthBloc>().state;
    final isKasir =
        authState is Authenticated && authState.user.role == 'kasir';

    if (isKasir) {
      try {
        final pendingRepo = sl<PendingPembelianRepository>();
        final pending = PendingPembelian(
          tokoId: sl<TokoService>().tokoId ?? '',
          supplierId: _selectedSupplier?.id,
          namaSupplier: _selectedSupplier?.nama,
          isPpnEnabled: _isPpnEnabled,
          ppnPercent: _ppnPercent,
        );
        final pendingId = await pendingRepo.addPending(pending);
        for (final item in _items) {
          await pendingRepo.addItem(
            pendingId,
            PendingPembelianItemData(
              produkId: item.produkId,
              namaProduk: item.namaProduk,
              jumlah: item.jumlah,
              hargaBeliSatuan: item.hargaBeliSatuan,
              hargaBeliLama: item.hargaBeliLama,
              diskonTipe: item.diskonTipe,
              diskonValue: item.diskonValue,
            ),
          );
        }

        final addNotifikasi = sl<AddNotifikasi>();
        await addNotifikasi(
          Notifikasi(
            tokoId: sl<TokoService>().tokoId ?? '',
            judul: 'Pembelian Pending Baru',
            pesan:
                'Kasir menambahkan draft pembelian baru dari ${_selectedSupplier?.nama ?? "Supplier tidak diketahui"}.',
            tipe: 'INFO',
          ),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pembelian disimpan ke draft (Pending)'),
            ),
          );
          setState(() => _forcePop = true);
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan ke pending: $e')),
          );
        }
      }
      return;
    }

    if (!mounted) return;

    final bloc = context.read<PembelianBloc>();

    if (_pembelianId == null) {
      final allProduk = await sl<GetAllProduk>().call();
      final Map<String, Produk> produkMap = {for (var p in allProduk) p.id!: p};
      final List<_ItemPembelian> changedItems = [];

      for (final item in _items) {
        if (item.hargaBeliSatuan != item.hargaBeliLama) {
          changedItems.add(item);
        }
      }

      if (changedItems.isNotEmpty) {
        final proceed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _PriceValidationDialog(
            changedItems: changedItems,
            produkMap: produkMap,
          ),
        );
        if (proceed != true) return;
      }

      if (!mounted) return;

      _pendingSaveItems = List.from(_items);
      _pendingSaveSupplierId = _selectedSupplier!.id!;
      setState(() => _isSaving = true);
      bloc.add(
        AddPembelianEvent(
          namaSupplier: _selectedSupplier!.nama,
          supplierId: _pendingSaveSupplierId,
          items: _items
              .map(
                (i) => ItemPembelianData(
                  produkId: i.produkId,
                  namaProduk: i.namaProduk,
                  jumlah: i.jumlah,
                  hargaBeliSatuan: i.hargaBeliSatuan,
                  subtotal: i.subtotal,
                  satuanId: i.satuanId,
                  konversi: i.konversi,
                ),
              )
              .toList(),
        ),
      );
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Update Pembelian'),
          content: const Text(
            'Perubahan ini akan mengupdate stok dan HPP produk terkait. Lanjutkan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
      if (!mounted) return;

      _pendingSaveItems = List.from(_items);
      _pendingSaveSupplierId = _selectedSupplier!.id!;
      setState(() => _isSaving = true);
      bloc.add(
        UpdatePembelianEvent(
          pembelianId: _pembelianId!,
          namaSupplier: _selectedSupplier!.nama,
          items: _items
              .map(
                (i) => ItemPembelianData(
                  produkId: i.produkId,
                  namaProduk: i.namaProduk,
                  jumlah: i.jumlah,
                  hargaBeliSatuan: i.hargaBeliSatuan,
                  subtotal: i.subtotal,
                  satuanId: i.satuanId,
                  konversi: i.konversi,
                ),
              )
              .toList(),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_items.isEmpty && _selectedSupplier == null) {
      return true;
    }
    if (_pembelianId != null) {
      final act = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Batalkan Perubahan?'),
          content: const Text(
            'Perubahan yang belum disimpan akan hilang. Lanjutkan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'batal'),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, 'hapus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningRed,
              ),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        ),
      );
      return act == 'hapus';
    }
    final act = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Simpan ke Pending?'),
        content: const Text(
          'Anda memiliki transaksi yang belum selesai. Apakah ingin menyimpannya ke daftar pending?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'batal'),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'hapus'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.warningRed),
            child: const Text('Hapus Pembelian'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, 'simpan'),
            child: const Text('Simpan ke Pending'),
          ),
        ],
      ),
    );

    if (act == 'hapus') {
      return true;
    } else if (act == 'simpan') {
      try {
        final pendingRepo = sl<PendingPembelianRepository>();
        final pending = PendingPembelian(
          tokoId: sl<TokoService>().tokoId ?? '',
          supplierId: _selectedSupplier?.id,
          namaSupplier: _selectedSupplier?.nama,
          isPpnEnabled: _isPpnEnabled,
          ppnPercent: _ppnPercent,
        );
        final pendingId = await pendingRepo.addPending(pending);
        for (final item in _items) {
          await pendingRepo.addItem(
            pendingId,
            PendingPembelianItemData(
              produkId: item.produkId,
              namaProduk: item.namaProduk,
              jumlah: item.jumlah,
              hargaBeliSatuan: item.hargaBeliSatuan,
              hargaBeliLama: item.hargaBeliLama,
              diskonTipe: item.diskonTipe,
              diskonValue: item.diskonValue,
            ),
          );
        }
        return true;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan ke pending: $e'),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PembelianBloc, PembelianState>(
      listener: (context, state) async {
        if (!_isSaving) return;
        if (state is PembelianSuccess) {
          _isSaving = false;
          final dao = sl<SupplierProductsDao>();
          final items = _pendingSaveItems ?? [];
          final supplierId = _pendingSaveSupplierId;
          if (supplierId != null) {
            for (final item in items) {
              await dao.upsertSupplierProduct(
                tokoId: sl<TokoService>().tokoId ?? '',
                supplierId: supplierId,
                produkId: item.produkId,
                harga: item.hargaBeliSatuan,
              );
            }
          }
          _pendingSaveItems = null;
          _pendingSaveSupplierId = null;
          if (mounted) {
            setState(() => _forcePop = true);
            Navigator.pop(context);
          }
        } else if (state is PembelianError) {
          _isSaving = false;
          _pendingSaveItems = null;
          _pendingSaveSupplierId = null;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal: ${state.message}'),
                backgroundColor: AppTheme.warningRed,
              ),
            );
          }
        }
      },
      child: PopScope(
        canPop: _forcePop,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _onWillPop();
          if (shouldPop) {
            if (mounted) {
              setState(() => _forcePop = true);
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
        appBar: AppBar(
          title: Text(_pembelianId != null ? 'Edit Pembelian' : 'Pembelian Baru'),
          actions: [
            IconButton(
              icon: const Icon(Icons.pending_actions),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PendingPembelianPage()),
                );
              },
              tooltip: 'Lihat Pending',
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSupplierSection(),
            _buildSearchSection(),
            Expanded(
              child: SingleChildScrollView(child: _buildCartList()),
            ),
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
              color: _selectedSupplier != null
                  ? AppTheme.primary
                  : AppTheme.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.store,
                size: 18,
                color: _selectedSupplier != null
                    ? AppTheme.primary
                    : AppTheme.neutralGrey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUPPLIER',
                      style: TextStyle(
                        color: _selectedSupplier != null
                            ? AppTheme.primary
                            : AppTheme.neutralGrey,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      _selectedSupplier?.nama ?? 'Ketuk untuk memilih supplier',
                      style: TextStyle(
                        color: _selectedSupplier != null
                            ? Colors.white
                            : AppTheme.neutralGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.neutralGrey,
                size: 20,
              ),
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
        onAddToCart: (id, nama, hargaJual, hargaBeli, qty, {String? satuanId, double konversi = 1.0}) {
          setState(() {
            final existing = _items.indexWhere(
              (i) => i.produkId == id && i.satuanId == satuanId,
            );
            if (existing != -1) {
              final existingItem = _items[existing];
              final newJumlah = existingItem.jumlah + qty;
              _items[existing] = existingItem.copyWith(
                jumlah: newJumlah,
                totalHarga: newJumlah * existingItem.hargaBeliSatuan,
              );
            } else {
              _items.add(
                _ItemPembelian(
                  produkId: id,
                  namaProduk: nama,
                  jumlah: qty,
                  hargaBeliSatuan: hargaBeli,
                  hargaBeliLama: hargaBeli,
                  totalHarga: qty * hargaBeli,
                  satuanId: satuanId,
                  konversi: konversi,
                ),
              );
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        readOnly: true,
        onTap: _openCariProduk,
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _openScanner,
          ),
        ),
      ),
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
            Text(
              'Cari produk untuk memulai',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final hasDiskon = item.diskonTipe != 0;
        return Card(
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
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppTheme.warningRed,
                      onPressed: () => setState(() => _items.removeAt(index)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showEditItemDialog(index, item),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                size: 12,
                                color: AppTheme.neutralGrey,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _currency.format(item.hargaBeliSatuan),
                                  style: const TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: () {
                        if (item.jumlah > 1) {
                          final newJumlah = item.jumlah - 1;
                          setState(
                            () => _items[index] = item.copyWith(
                              jumlah: newJumlah,
                              totalHarga: newJumlah * item.hargaBeliSatuan,
                            ),
                          );
                        }
                      },
                    ),
                    InkWell(
                      onTap: () => _showEditItemDialog(index, item),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.jumlah}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: () {
                        final newJumlah = item.jumlah + 1;
                        setState(
                          () => _items[index] = item.copyWith(
                            jumlah: newJumlah,
                            totalHarga: newJumlah * item.hargaBeliSatuan,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _currency.format(item.subtotal),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (hasDiskon)
                          Text(
                            'Diskon ${item.diskonTipe == 1 ? "${item.diskonValue}%" : "Rp${_currency.format(item.diskonValue)}"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.warningRed,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showDiskonDialog(index, item),
                      icon: Icon(
                        Icons.discount,
                        size: 16,
                        color: hasDiskon
                            ? AppTheme.warningRed
                            : AppTheme.neutralGrey,
                      ),
                      label: Text(
                        hasDiskon ? 'Diskon diterapkan' : 'Diskon',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasDiskon
                              ? AppTheme.warningRed
                              : AppTheme.neutralGrey,
                        ),
                      ),
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
          if (_totalDiskon > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal:',
                    style: TextStyle(color: AppTheme.neutralGrey),
                  ),
                  Text(
                    _currency.format(_total),
                    style: const TextStyle(color: AppTheme.neutralGrey),
                  ),
                ],
              ),
            ),
          if (_totalDiskon > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Diskon:',
                    style: TextStyle(color: AppTheme.warningRed),
                  ),
                  Text(
                    '- ${_currency.format(_totalDiskon)}',
                    style: const TextStyle(color: AppTheme.warningRed),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'PPN',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    value: _isPpnEnabled,
                    onChanged: (val) => setState(() => _isPpnEnabled = val),
                    activeThumbColor: AppTheme.primaryGreen,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  if (_isPpnEnabled)
                    Container(
                      width: 45,
                      height: 30,
                      margin: const EdgeInsets.only(left: 4),
                      child: TextField(
                        controller: _ppnController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          suffixText: '%',
                        ),
                        onChanged: (val) {
                          setState(() {
                            _ppnPercent = double.tryParse(val) ?? 0.0;
                          });
                        },
                      ),
                    ),
                ],
              ),
              if (_isPpnEnabled)
                Text(
                  '+ ${_currency.format(_totalPpn)}',
                  style: const TextStyle(color: AppTheme.warningRed),
                ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Final:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _currency.format(_totalFinal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final isKasir =
                    authState is Authenticated &&
                    authState.user.role == 'kasir';
                return ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? AppTheme.primary
                        : Colors.grey.shade600,
                    foregroundColor: _isFormValid
                        ? AppTheme.onPrimary
                        : Colors.white38,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isKasir ? 'Simpan ke Pending (Kasir)' : 'Simpan Pembelian',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemPembelian {
  final String produkId;
  final String namaProduk;
  final int jumlah;
  final double hargaBeliSatuan;
  final double hargaBeliLama; // harga beli sebelum transaksi ini (per satuan yang dipilih)
  final double totalHarga; // total harga yg diinput user — source of truth untuk subtotal
  final int diskonTipe;
  final double diskonValue;
  // null = satuan dasar, non-null = SatuanProduk.id
  final String? satuanId;
  // 1.0 = satuan dasar, >1.0 = satuan konversi
  final double konversi;

  const _ItemPembelian({
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
    required this.hargaBeliSatuan,
    required this.hargaBeliLama,
    required this.totalHarga,
    this.diskonTipe = 0,
    this.diskonValue = 0,
    this.satuanId,
    this.konversi = 1.0,
  });

  double get subtotal => totalHarga;
  double get diskonRp =>
      diskonTipe == 1 ? subtotal * diskonValue / 100 : diskonValue;

  _ItemPembelian copyWith({
    String? produkId,
    String? namaProduk,
    int? jumlah,
    double? hargaBeliSatuan,
    double? hargaBeliLama,
    double? totalHarga,
    int? diskonTipe,
    double? diskonValue,
    String? satuanId,
    double? konversi,
  }) {
    return _ItemPembelian(
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      jumlah: jumlah ?? this.jumlah,
      hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
      hargaBeliLama: hargaBeliLama ?? this.hargaBeliLama,
      totalHarga: totalHarga ?? this.totalHarga,
      diskonTipe: diskonTipe ?? this.diskonTipe,
      diskonValue: diskonValue ?? this.diskonValue,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
    );
  }
}

class _PriceValidationDialog extends StatefulWidget {
  final List<_ItemPembelian> changedItems;
  final Map<String, Produk> produkMap;

  const _PriceValidationDialog({
    required this.changedItems,
    required this.produkMap,
  });

  @override
  State<_PriceValidationDialog> createState() => _PriceValidationDialogState();
}

class _PriceValidationDialogState extends State<_PriceValidationDialog> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final Map<String, TextEditingController> _controllers = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.changedItems) {
      final oldJual = widget.produkMap[item.produkId]!.hargaJual;
      final controller = TextEditingController(
        text: oldJual.toStringAsFixed(0),
      );
      _controllers[item.produkId] = controller;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final updateProduk = sl<UpdateProduk>();
      final addNotifikasi = sl<AddNotifikasi>();
      for (var item in widget.changedItems) {
        final produk = widget.produkMap[item.produkId]!;
        final controller = _controllers[item.produkId]!;
        final newJual = double.tryParse(controller.text) ?? produk.hargaJual;

        if (item.satuanId != null) {
          // Satuan konversi: update SatuanProduk.hargaBeli
          // Harga beli dasar dihitung ulang = harga satuan / konversi
          final hargaBeliDasar = item.hargaBeliSatuan / item.konversi;
          final updatedProduk = produk.copyWith(
            hargaBeli: hargaBeliDasar,
            hargaJual: newJual,
          );
          await updateProduk(updatedProduk);
          // Update hargaBeli pada SatuanProduk yang berubah via ProdukRepository
          final satuanList = produk.satuanList ?? [];
          final satuan = satuanList.where((s) => s.id == item.satuanId).firstOrNull;
          if (satuan != null) {
            await sl<ProdukRepository>().updateSatuan(
              satuan.copyWith(hargaBeli: item.hargaBeliSatuan),
            );
          }
        } else {
          // Satuan dasar: update Produk.hargaBeli langsung
          final updatedProduk = produk.copyWith(
            hargaBeli: item.hargaBeliSatuan,
            hargaJual: newJual,
          );
          await updateProduk(updatedProduk);
        }

        final isNaik = item.hargaBeliSatuan > item.hargaBeliLama;
        await addNotifikasi(
          Notifikasi(
            tokoId: sl<TokoService>().tokoId ?? '',
            judul: 'Harga Beli Berubah - ${produk.nama}',
            pesan:
                'Harga beli dari Rp${item.hargaBeliLama.toStringAsFixed(0)} menjadi Rp${item.hargaBeliSatuan.toStringAsFixed(0)}. Harga jual disesuaikan menjadi Rp${newJual.toStringAsFixed(0)}.',
            tipe: isNaik ? 'WARNING' : 'INFO',
          ),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Validasi Perubahan Harga'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Harga beli barang berikut telah berubah. Silakan sesuaikan harga jualnya jika diperlukan.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.changedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.changedItems[index];
                  final controller = _controllers[item.produkId]!;

                  final isNaik = item.hargaBeliSatuan > item.hargaBeliLama;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.namaProduk,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _currency.format(item.hargaBeliLama),
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 12),
                            const SizedBox(width: 8),
                            Text(
                              _currency.format(item.hargaBeliSatuan),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isNaik
                                    ? AppTheme.warningRed
                                    : AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Harga Jual Baru',
                            prefixText: 'Rp ',
                            isDense: true,
                          ),
                          onTap: () {
                            controller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: controller.text.length,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveChanges,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan & Lanjutkan'),
        ),
      ],
    );
  }
}
