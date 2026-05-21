import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/barcode_scanner_widget.dart';

import '../../core/di/injection.dart';
import '../../core/services/toko_service.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/pending_order.dart';
import '../../domain/repositories/pending_order_repository.dart';
import '../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../domain/usecases/transaksi/buat_transaksi.dart';
import '../../data/services/printer_service.dart';
import '../../data/services/printer_settings.dart';
import '../../data/services/receipt_generator.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/cashier/cashier_bloc.dart';
import '../blocs/cashier/cashier_event.dart';
import '../blocs/cashier/cashier_state.dart';
import '../utils/dialog_utils.dart';
import '../widgets/cari_produk_dialog.dart';
import '../widgets/pending_dialog.dart';

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
  final _bayarController = TextEditingController();

  // Store last transaction data for printing
  List<CartItem>? _lastCartItems;
  double _lastTotalBayar = 0;
  double _lastKembalian = 0;
  bool _isPrinting = false;

  bool get _isKasir {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) return authState.user.isKasir;
    return false;
  }

  @override
  void initState() {
    super.initState();
    context.read<CashierBloc>().add(InitCashier());
  }

  Future<void> _showBayarConfirmation(CashierReady data) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('Total', _currency.format(data.totalSetelahDiskon)),
            const Divider(height: 16),
            _infoRow('Dibayar', _currency.format(data.jumlahBayar)),
            _infoRow('Kembali', _currency.format(data.kembalian)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _lastCartItems = List.from(data.cart);
      _lastTotalBayar = data.jumlahBayar;
      _lastKembalian = data.kembalian;
      if (context.mounted) {
        context.read<CashierBloc>().add(BayarCashier());
      }
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt({
    required String transaksiId,
    required List<CartItem> cartItems,
    required double totalBayar,
    required double kembalian,
    String metode = 'Tunai',
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final settings = sl<PrinterSettings>();
    if (!settings.enabled) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Printer tidak aktif. Aktifkan di Pengaturan Printer.'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
      return;
    }

    setState(() => _isPrinting = true);

    try {
      final generator = sl<ReceiptGenerator>();
      final receipt = generator.fromTransaction(
        transaksiId: transaksiId,
        cartItems: cartItems,
        totalBayar: totalBayar,
        kembalian: kembalian,
        metodePembayaran: metode,
      );

      final printer = sl<PrinterService>();
      final success = await printer.printReceipt(receipt);

      if (mounted) {
        if (success) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Nota berhasil dicetak'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Gagal mencetak nota'),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error print: $e'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isPrinting = false);
    }
  }

  Widget _buildReceiptPreview({
    required String transaksiId,
    required List<CartItem> cartItems,
    required double totalBayar,
    required double kembalian,
  }) {
    final settings = sl<PrinterSettings>();
    final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    final lebar = 40;

    String line() => '─' * lebar;
    String center(String s) {
      final pad = (lebar - s.length) ~/ 2;
      return '${' ' * pad}$s';
    }

    final buffer = StringBuffer();
    buffer.writeln(center(settings.namaToko));
    if (settings.alamatToko.isNotEmpty) {
      buffer.writeln(center(settings.alamatToko));
    }
    buffer.writeln(line());
    buffer.writeln('#$transaksiId');
    buffer.writeln('Tgl: $tanggal');
    buffer.writeln(line());

    for (final item in cartItems) {
      final nama = item.namaProduk.length > lebar - 4
          ? '${item.namaProduk.substring(0, lebar - 4)}..'
          : item.namaProduk;
      final hargaStr = _currency.format(item.hargaJual);
      final subtotalStr = _currency.format(item.subtotal);
      buffer.writeln(nama);
      buffer.writeln('  ${item.jumlah}x $hargaStr  $subtotalStr');
      if (item.totalDiskon > 0) {
        buffer.writeln('  Diskon: -${_currency.format(item.totalDiskon)}');
      }
    }

    buffer.writeln(line());
    buffer.writeln('Subtotal  ${_currency.format(totalBayar + kembalian)}');
    buffer.writeln('TOTAL     ${_currency.format(totalBayar)}');
    buffer.writeln('Dibayar   ${_currency.format(totalBayar)}');
    if (kembalian > 0) {
      buffer.writeln('Kembali   ${_currency.format(kembalian)}');
    }
    buffer.writeln(line());
    buffer.writeln(center('Terima kasih!'));

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Text(
          buffer.toString(),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bayarController.dispose();
    super.dispose();
  }

  void _openCariProduk() {
    final pokok = _isKasir ? 0.0 : null;
    showDialog(
      context: context,
      builder: (ctx) => CariProdukDialog(
        getAllProduk: sl(),
        searchProduk: sl(),
        onAddToCart: (id, nama, harga, hargaBeli, qty, {String? satuanId, double konversi = 1.0}) {
          context.read<CashierBloc>().add(
            AddToCart(
              produkId: id,
              namaProduk: nama,
              hargaJual: harga,
              hargaPokok: pokok ?? hargaBeli,
              jumlah: qty,
            ),
          );
        },
      ),
    );
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
    final pokok = _isKasir ? 0.0 : produk.hargaBeli;
    if (mounted) {
      DialogUtils.showPilihSatuanDialog(
        context: context,
        produk: produk,
        isPembelian: false,
        onSelected: (id, nama, harga, satuanId, konversi) {
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
                ),
              );
            },
          );
        },
      );
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
        },
      ),
    );
  }

  void _showDiskonDialog(int index, CartItem item) {
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
                context.read<CashierBloc>().add(
                  SetDiskonItem(index, tipe, value),
                );
                Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditJumlahDialog(int index, String namaProduk, int currentJumlah) {
    final controller = TextEditingController(text: currentJumlah.toString());
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ubah Jumlah - $namaProduk'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Jumlah',
            hintText: 'Masukkan jumlah barang',
          ),
          onSubmitted: (value) {
            final newJumlah = int.tryParse(value) ?? 1;
            if (newJumlah > 0) {
              context.read<CashierBloc>().add(
                UpdateJumlahCart(index, newJumlah),
              );
            }
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
              final newJumlah = int.tryParse(controller.text) ?? 1;
              if (newJumlah > 0) {
                context.read<CashierBloc>().add(
                  UpdateJumlahCart(index, newJumlah),
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

  void _showHutangDialog() {
    final namaController = TextEditingController();
    // Capture current cart data
    final state = context.read<CashierBloc>().state;
    if (state is CashierReady) {
      _lastCartItems = List.from(state.cart);
      _lastTotalBayar = state.totalSetelahDiskon;
      _lastKembalian = 0;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bayar Hutang'),
        content: TextField(
          controller: namaController,
          decoration: const InputDecoration(
            labelText: 'Nama Pelanggan',
            hintText: 'Masukkan nama pelanggan',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CashierBloc>().add(
                BayarHutangCashier(namaController.text),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Pelanggan *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: catatanController,
              decoration: const InputDecoration(labelText: 'Catatan'),
            ),
          ],
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
                  tokoId: sl<TokoService>().tokoId ?? '',
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
              context.read<CashierBloc>().add(InitCashier());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pending disimpan untuk ${namaController.text.trim()}',
                    ),
                  ),
                );
                if (exitAfterSave) Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashierBloc, CashierState>(
      listener: (context, state) async {
        if (state is CashierSuccess) {
          _bayarController.clear();

          final shouldPrint = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Transaksi Berhasil'),
              content: state.isHutang
                  ? Text('Transaksi #${state.transaksiId} dicatat sebagai hutang')
                  : SizedBox(
                      width: double.maxFinite,
                      child: _buildReceiptPreview(
                        transaksiId: state.transaksiId,
                        cartItems: _lastCartItems ?? [],
                        totalBayar: _lastTotalBayar,
                        kembalian: _lastKembalian,
                      ),
                    ),
              actions: [
                if (!state.isHutang)
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Cetak Nota'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(state.isHutang ? 'Tutup' : 'Tidak'),
                ),
              ],
            ),
          );

          if (shouldPrint == true &&
              _lastCartItems != null &&
              context.mounted) {
            _printReceipt(
              transaksiId: state.transaksiId,
              cartItems: _lastCartItems!,
              totalBayar: _lastTotalBayar,
              kembalian: _lastKembalian,
            );
          }

          _lastCartItems = null;
          if (context.mounted) {
            context.read<CashierBloc>().add(InitCashier());
          }
        }
        if (state is CashierError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (state is CashierReady && state.cart.isNotEmpty) {
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
                  icon: const Icon(Icons.pending_actions),
                  tooltip: 'Pending Orders',
                  onPressed: _openPendingDialog,
                ),
              ],
            ),
            body: () {
              if (state is CashierLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is! CashierReady && state is! CashierError) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = _resolveCashierData(state);

              return Column(
                children: [
                  _buildSearchSection(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildCartList(data),
                    ),
                  ),
                  _buildBottomPanel(data),
                ],
              );
            }(),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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

  CashierReady _resolveCashierData(CashierState state) {
    if (state is CashierReady) return state;
    if (state is CashierError) {
      return CashierReady(cart: state.cart, jumlahBayar: state.jumlahBayar);
    }
    return const CashierReady();
  }

  Widget _buildCartList(CashierReady data) {
    if (data.cart.isEmpty) {
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
      itemCount: data.cart.length,
      itemBuilder: (context, index) {
        final item = data.cart[index];
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
                      onPressed: () => context.read<CashierBloc>().add(
                        RemoveFromCart(index),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _currency.format(item.hargaJual),
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: () => context.read<CashierBloc>().add(
                        UpdateJumlahCart(index, item.jumlah - 1),
                      ),
                    ),
                    InkWell(
                      onTap: () => _showEditJumlahDialog(
                        index,
                        item.namaProduk,
                        item.jumlah,
                      ),
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
                      onPressed: () => context.read<CashierBloc>().add(
                        UpdateJumlahCart(index, item.jumlah + 1),
                      ),
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

  Widget _buildBottomPanel(CashierReady data) {
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
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (data.totalDiskon > 0)
                    Text(
                      _currency.format(data.total),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.neutralGrey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    _currency.format(data.totalSetelahDiskon),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (data.totalDiskon > 0)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diskon: ${_currency.format(data.totalDiskon)}',
                    style: TextStyle(fontSize: 13, color: AppTheme.warningRed),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Bayar:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _bayarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixText: 'Rp ',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0;
                    context.read<CashierBloc>().add(UpdateJumlahBayar(amount));
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  final amount = data.totalSetelahDiskon;
                  _bayarController.text = amount.toStringAsFixed(0);
                  context.read<CashierBloc>().add(UpdateJumlahBayar(amount));
                },
                child: const Text('Uang Pas'),
              ),
            ],
          ),
          if (data.jumlahBayar >= data.totalSetelahDiskon &&
              data.totalSetelahDiskon > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kembali:', style: TextStyle(fontSize: 16)),
                Text(
                  _currency.format(data.kembalian),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGreen,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: data.cart.isEmpty
                      ? null
                      : () {
                          if (data.jumlahBayar <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Masukkan nominal bayar terlebih dahulu',
                                ),
                                backgroundColor: AppTheme.warningRed,
                              ),
                            );
                            return;
                          }
                          if (data.jumlahBayar < data.totalSetelahDiskon) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Jumlah bayar kurang dari total'),
                                backgroundColor: AppTheme.warningRed,
                              ),
                            );
                            return;
                          }
                          _showBayarConfirmation(data);
                        },
                  icon: _isPrinting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.payments),
                  label: Text(_isPrinting ? 'Printing...' : 'Bayar'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: data.cart.isEmpty ? null : _showHutangDialog,
                icon: const Icon(Icons.book),
                label: const Text('Hutang'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: data.cart.isEmpty ? null : _savePending,
              icon: const Icon(Icons.pause_circle_outline, size: 18),
              label: const Text('Pending'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.warningOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
