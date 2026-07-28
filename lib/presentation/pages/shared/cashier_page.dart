import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/barcode_scanner_widget.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/entities/satuan_produk.dart';
import '../../../domain/entities/pending_order.dart';
import '../../../domain/repositories/pending_order_repository.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../../domain/usecases/transaksi/buat_transaksi.dart' show CartItem;
import '../../../data/services/bluetooth_printer_service.dart';
import '../../../data/services/printer_settings.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cashier/cashier_bloc.dart';
import '../../blocs/cashier/cashier_event.dart';
import '../../blocs/cashier/cashier_state.dart';
import '../../blocs/transaksi/transaksi_bloc.dart';
import '../../utils/dialog_utils.dart';
import '../../widgets/pending_dialog.dart';
import 'cart_page.dart';
import 'transaksi_page.dart';
import '../../../features/kasir/voice/voice_input_dialog.dart';
import '../../../features/kasir/voice/models/matched_cart_item.dart' as v_models;

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<Produk> _allProducts = [];
  List<Produk> _filtered = [];
  bool _loading = true;

  // Per-card temp state (keyed by produk.id).
  final Map<String, int> _tempQty = {};
  final Map<String, SatuanProduk?> _tempSatuan = {};

  bool _printerConnected = false;
  int _pendingCount = 0;

  bool get _isKasir {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) return authState.user.isKasir;
    return false;
  }

  @override
  void initState() {
    super.initState();
    context.read<CashierBloc>().add(InitCashier());
    _loadProducts();
    _checkPrinterConnection();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    try {
      final list = await sl<PendingOrderRepository>().getAllPending();
      if (mounted) setState(() => _pendingCount = list.length);
    } catch (_) {
      /* ignore */
    }
  }

  void _openPendingDialog() {
    showDialog(
      context: context,
      builder: (_) => PendingDialog(
        repository: sl(),
        onLoadPending: (id) async {
          final repo = sl<PendingOrderRepository>();
          final items = await repo.getItemsByPendingId(id);
          if (!mounted) return;
          context.read<CashierBloc>().add(
                LoadCartFromPending(
                  items
                      .map(
                        (i) => CartItem(
                          produkId: i.produkId,
                          namaProduk: i.namaProduk,
                          hargaJual: i.hargaJual,
                          jumlah: i.jumlah,
                          diskonTipe: i.diskonTipe,
                          diskonValue: i.diskonValue,
                        ),
                      )
                      .toList(),
                ),
              );
          await repo.deletePending(id);
          await _loadPendingCount();
        },
      ),
    ).then((_) => _loadPendingCount());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
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
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _allProducts
          : _allProducts.where((p) => p.nama.toLowerCase().contains(q)).toList();
    });
  }

  // --- Per-card qty / satuan helpers ---
  // + / − and the manual dialog ONLY mutate _tempQty (local state).
  // Cart addition happens exclusively in _addToCart (cart icon tap).
  int _getQty(Produk p) => _tempQty[p.id] ?? 1;
  void _incQty(Produk p) {
    final q = _getQty(p);
    if (q < p.stok) setState(() => _tempQty[p.id!] = q + 1);
  }

  void _decQty(Produk p) {
    final q = _getQty(p);
    if (q > 1) setState(() => _tempQty[p.id!] = q - 1);
  }

  void _showQtyInputDialog(Produk p) {
    final controller = TextEditingController(text: '${_getQty(p)}');
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    void submit(String value) {
      final parsed = int.tryParse(value) ?? 1;
      final clamped = parsed.clamp(1, p.stok < 1 ? 1 : p.stok);
      setState(() => _tempQty[p.id!] = clamped);
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Jumlah - ${p.nama}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Jumlah',
            helperText: 'Maks. stok: ${p.stok}',
          ),
          onSubmitted: (v) {
            submit(v);
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              submit(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  double _hargaFor(Produk p) {
    final s = _tempSatuan[p.id];
    if (s == null) return p.hargaJual;
    return s.hargaJual > 0 ? s.hargaJual : p.hargaJual * s.konversi;
  }

  String _satuanName(Produk p) => _tempSatuan[p.id]?.nama ?? (p.satuan ?? 'pcs');

  void _showSatuanPicker(Produk p) {
    DialogUtils.showPilihSatuanDialog(
      context: context,
      produk: p,
      isPembelian: false,
      onSelected: (id, nama, satuanName, harga, satuanId, konversi) {
        SatuanProduk? sel;
        for (final s in p.satuanList ?? const <SatuanProduk>[]) {
          if (s.id == satuanId) {
            sel = s;
            break;
          }
        }
        setState(() => _tempSatuan[p.id!] = sel);
      },
    );
  }

  void _addToCart(Produk p) {
    final s = _tempSatuan[p.id];
    final satuanName = s?.nama ?? (p.satuan ?? 'pcs');
    final harga = _hargaFor(p);
    final pokok = _isKasir
        ? 0.0
        : (s != null
            ? (s.hargaBeli > 0 ? s.hargaBeli : p.hargaBeli * s.konversi)
            : p.hargaBeli);
    context.read<CashierBloc>().add(
          AddToCart(
            produkId: p.id!,
            namaProduk: '${p.nama} - $satuanName',
            hargaJual: harga,
            hargaPokok: pokok,
            jumlah: _getQty(p),
            satuan: s?.id,
            konversi: s?.konversi ?? 1.0,
          ),
        );
    setState(() => _tempQty[p.id!] = 1);
  }

  Future<void> _checkPrinterConnection() async {
    try {
      final settings = sl<PrinterSettings>();
      if (settings.enabled) {
        _printerConnected = await sl<BluetoothPrinterService>().isConnected();
      } else {
        _printerConnected = false;
      }
    } catch (_) {
      _printerConnected = false;
    }
    if (mounted) setState(() {});
  }

  Future<bool> _requestBluetoothPermissions() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        final statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();
        return statuses.values.every((s) => s.isGranted);
      } else {
        final status = await Permission.location.request();
        return status.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  void _openCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CashierBloc>(),
          child: const CartPage(),
        ),
      ),
    );
  }

  void _openVoiceInput() async {
    final results = await showDialog<List<v_models.MatchedCartItem>>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const VoiceInputDialog(),
    );

    if (results != null && results.isNotEmpty) {
      for (final item in results) {
        if (item.status == v_models.MatchStatus.matched &&
            item.selectedProduk != null) {
          final p = item.selectedProduk!;
          final pokok = _isKasir ? 0.0 : p.hargaBeli;

          if (!mounted) return;
          context.read<CashierBloc>().add(
                AddToCart(
                  produkId: p.id!,
                  namaProduk: '${p.nama} - ${item.satuanName}',
                  hargaJual: item.finalPrice,
                  hargaPokok: pokok,
                  jumlah: item.editedQty,
                  satuan: item.selectedSatuan?.id,
                  konversi: item.konversi,
                ),
              );
        }
      }
    }
  }

  Future<void> _openScanner() async {
    final barcode = await showBarcodeScannerDialog(context);
    if (barcode == null) return;
    final produk = await sl<GetProdukByBarcode>()(barcode);
    if (produk == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk tidak ditemukan')),
        );
      }
      return;
    }
    if (produk.isArchived) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk diarsipkan dan tidak bisa dijual di Kasir'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
      return;
    }

    if (produk.stok <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok ${produk.nama} sudah habis'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    final pokok = _isKasir ? 0.0 : produk.hargaBeli;
    if (mounted) {
      DialogUtils.showPilihSatuanDialog(
        context: context,
        produk: produk,
        isPembelian: false,
        onSelected: (id, namaProduk, satuanName, harga, satuanId, konversi) {
          final nama = '$namaProduk - $satuanName';
          DialogUtils.showQuantityDialog(
            context: context,
            namaProduk: nama,
            onSubmitted: (qty) {
              context.read<CashierBloc>().add(
                    AddToCart(
                      produkId: id,
                      namaProduk: nama,
                      hargaJual: harga,
                      hargaPokok: pokok,
                      jumlah: qty,
                      satuan: satuanId,
                      konversi: konversi,
                    ),
                  );
            },
          );
        },
      );
    }
  }

  void _showPrinterBottomSheet() {
    _checkPrinterConnection();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        var localScanning = false;
        var localDevices = <_PrinterDevice>[];

        Future<void> doScan() async {
          localScanning = true;
          localDevices = [];
          final granted = await _requestBluetoothPermissions();
          if (!granted) return;
          try {
            final bt = sl<BluetoothPrinterService>();
            final results = await Future.wait([
              bt.scanPrinters(),
              BluetoothPrinterService.getBondedDevices(),
            ]);
            final scanned = (results[0] as List<BluetoothDevice>)
                .map((d) => _PrinterDevice(
                      name: d.platformName.isNotEmpty
                          ? d.platformName
                          : d.remoteId.toString(),
                      address: d.remoteId.toString(),
                      device: d,
                    ));
            final bonded = (results[1] as List<Map<String, String>>)
                .map((d) => _PrinterDevice(
                      name: (d['name']?.isNotEmpty == true)
                          ? d['name']!
                          : d['address']!,
                      address: d['address'] ?? '',
                    ));
            localDevices = [...scanned, ...bonded];
          } catch (_) {}
        }

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (localScanning) const LinearProgressIndicator(),
                  if (localScanning) const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Printer Bluetooth',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.bluetooth,
                        color: _printerConnected
                            ? AppTheme.primaryGreen
                            : AppTheme.warningRed,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _printerConnected
                            ? AppTheme.primaryGreen
                            : AppTheme.warningRed,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _printerConnected ? 'Terhubung' : 'Tidak terhubung',
                        style: TextStyle(
                          color: _printerConnected
                              ? AppTheme.primaryGreen
                              : AppTheme.warningRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: localScanning
                          ? null
                          : () async {
                              localScanning = true;
                              setSheetState(() {});
                              await doScan();
                              setSheetState(() {});
                            },
                      icon: localScanning
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label:
                          Text(localScanning ? 'Memindai...' : 'Cari Printer'),
                    ),
                  ),
                  if (localDevices.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 320),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final d in localDevices)
                              ListTile(
                                dense: true,
                                leading: const Icon(Icons.bluetooth),
                                title: Text(
                                  d.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  d.address,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                trailing: const Icon(Icons.link, size: 18),
                                onTap: () async {
                                  final bt = sl<BluetoothPrinterService>();
                                  final success = d.device != null
                                      ? await bt.connect(d.device!)
                                      : await bt.connect(BluetoothDevice(
                                          remoteId:
                                              DeviceIdentifier(d.address),
                                        ));
                                  if (success) {
                                    final settings = sl<PrinterSettings>();
                                    settings.enabled = true;
                                    _printerConnected = true;
                                    if (ctx.mounted && mounted) {
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Terhubung ke ${d.name}'),
                                        ),
                                      );
                                    }
                                  } else {
                                    if (ctx.mounted && mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Gagal connect ke ${d.name}'),
                                          backgroundColor: AppTheme.warningRed,
                                        ),
                                      );
                                    }
                                  }
                                  if (mounted) setState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _showExitConfirmationDialog() {
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transaksi Berjalan'),
        content: const Text(
          'Ada transaksi yang belum selesai. Apa yang ingin Anda lakukan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'batal'),
            child: const Text('Batal Keluar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'hapus'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.warningRed),
            child: const Text('Hapus Transaksi'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'pending'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primaryGreen),
            child: const Text('Simpan Pending'),
          ),
        ],
      ),
    );
  }

  void _savePending({bool exitAfterSave = false}) {
    final namaController = TextEditingController();
    final catatanController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Simpan Pending'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration:
                    const InputDecoration(labelText: 'Nama Pelanggan *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: catatanController,
                decoration: const InputDecoration(labelText: 'Catatan'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (namaController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              final cashierState = context.read<CashierBloc>().state;
              if (cashierState is! CashierReady) return;
              if (cashierState.cart.isEmpty) return;
              final repo = sl<PendingOrderRepository>();
              final pendingId = await repo.addPending(
                PendingOrder(
                  namaPelanggan: namaController.text.trim(),
                  catatan: catatanController.text.trim().isEmpty
                      ? null
                      : catatanController.text.trim(),
                ),
              );
              for (final item in cashierState.cart) {
                await repo.addItem(
                  pendingId,
                  CartItemData(
                    produkId: item.produkId,
                    namaProduk: item.namaProduk,
                    hargaJual: item.hargaJual,
                    jumlah: item.jumlah,
                    diskonTipe: item.diskonTipe,
                    diskonValue: item.diskonValue,
                    subtotal: item.subtotal,
                  ),
                );
              }
              if (!mounted) return;
              context.read<CashierBloc>().add(InitCashier());
              await _loadPendingCount();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Pending disimpan untuk ${namaController.text.trim()}',
                  ),
                ),
              );
              if (exitAfterSave) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  CashierReady _resolveCashierData(CashierState state) {
    if (state is CashierReady) return state;
    if (state is CashierError) {
      return CashierReady(cart: state.cart, jumlahBayar: state.jumlahBayar);
    }
    return const CashierReady();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierBloc, CashierState>(
      builder: (context, state) {
        final data = _resolveCashierData(state);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (data.cart.isNotEmpty) {
              final action = await _showExitConfirmationDialog();
              if (action == 'hapus') {
                if (context.mounted) {
                  context.read<CashierBloc>().add(InitCashier());
                  Navigator.pop(context);
                }
              } else if (action == 'pending') {
                _savePending(exitAfterSave: true);
              }
            } else {
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Kasir'),
              actions: [
                IconButton(
                  icon: Badge(
                    isLabelVisible: _pendingCount > 0,
                    label: Text('$_pendingCount'),
                    child: const Icon(Icons.pause_circle_outline),
                  ),
                  tooltip: data.cart.isEmpty
                      ? 'Buka Pending'
                      : 'Simpan Pending',
                  // Cart kosong -> buka daftar pending untuk dilanjutkan.
                  // Cart ada isi -> simpan cart sekarang sebagai pending.
                  onPressed: data.cart.isEmpty
                      ? _openPendingDialog
                      : () => _savePending(),
                ),
                IconButton(
                  icon: const Icon(Icons.bluetooth),
                  tooltip: 'Printer Bluetooth',
                  onPressed: _showPrinterBottomSheet,
                ),
              ],
            ),
            body: Column(
              children: [
                _buildSearchSection(),
                Expanded(child: _buildProductList()),
                _buildBottomBar(data),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: _openScanner,
              tooltip: 'Scan Barcode',
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                  setState(() {}); // refresh clear button
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    _filterProducts(query);
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic_none, color: Colors.deepPurple),
              onPressed: _openVoiceInput,
              tooltip: 'Asisten AI',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_filtered.isEmpty) {
      return const Center(
        child: Text('Produk tidak ditemukan',
            style: TextStyle(color: AppTheme.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _filtered.length,
      itemBuilder: (context, index) => _buildProductCard(_filtered[index]),
    );
  }

  Widget _buildProductCard(Produk produk) {
    final stokHabis = produk.stok == 0;
    final cardColor = Theme.of(context).cardColor;

    return Opacity(
      opacity: stokHabis ? 0.55 : 1.0,
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                produk.nama,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
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
                  if (stokHabis)
                    const Text(
                      'Stok Habis',
                      style: TextStyle(
                        color: AppTheme.warningRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      'Stok: ${produk.stok}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _SatuanBadge(
                    satuan: _satuanName(produk),
                    onTap: () => _showSatuanPicker(produk),
                  ),
                  const Spacer(),
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: stokHabis ? null : () => _decQty(produk),
                  ),
                  GestureDetector(
                    onTap: stokHabis ? null : () => _showQtyInputDialog(produk),
                    child: SizedBox(
                      width: 40,
                      child: Text(
                        '${_getQty(produk)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: stokHabis ? null : () => _incQty(produk),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: stokHabis
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Stok ${produk.nama} sudah habis'),
                                backgroundColor: AppTheme.warningRed,
                              ),
                            );
                          }
                        : () => _addToCart(produk),
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(CashierReady data) {
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
                  Text(
                    '${data.cart.length} item',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _currency.format(data.totalSetelahDiskon),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => sl<TransaksiBloc>(),
                      child: const TransaksiPage(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long, size: 18),
              label: const Text('Riwayat'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.neutralGrey),
            ),
            const SizedBox(width: 4),
            ElevatedButton.icon(
              onPressed: data.cart.isEmpty ? null : _openCartPage,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Keranjang'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SatuanBadge extends StatelessWidget {
  final String satuan;
  final VoidCallback onTap;
  const _SatuanBadge({required this.satuan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              satuan,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}

class _PrinterDevice {
  final String name;
  final String address;
  final BluetoothDevice? device;

  _PrinterDevice({
    required this.name,
    required this.address,
    this.device,
  });
}
