import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../data/services/printing/receipt_printer.dart';
import '../../../data/services/receipt_generator.dart';
import '../../../data/services/printer_settings.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../../domain/usecases/transaksi/buat_transaksi.dart' show CartItem;
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cashier/cashier_bloc.dart';
import '../../blocs/cashier/cashier_event.dart';
import '../../blocs/cashier/cashier_state.dart';
import 'scan_resolver.dart';
import 'widgets/cart_panel.dart';
import 'widgets/payment_dialog.dart';

class CashierDesktopPage extends StatefulWidget {
  const CashierDesktopPage({super.key});
  @override
  State<CashierDesktopPage> createState() => _CashierDesktopPageState();
}

class _CashierDesktopPageState extends State<CashierDesktopPage> {
  final _scanCtrl = TextEditingController();
  final _scanFocus = FocusNode();
  final _rp =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  List<Produk> _all = [];
  List<Produk> _filtered = [];

  List<CartItem>? _lastCart;
  double _lastBayar = 0;
  double _lastKembali = 0;

  bool get _isKasir {
    final s = context.read<AuthBloc>().state;
    return s is Authenticated && s.user.isKasir;
  }

  @override
  void initState() {
    super.initState();
    context.read<CashierBloc>().add(InitCashier());
    _loadProducts();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scanFocus.requestFocus());
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    _scanFocus.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final products = await sl<GetAllProduk>()();
    final active = products.where((p) => !p.isArchived).toList()
      ..sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    if (!mounted) return;
    setState(() {
      _all = active;
      _filtered = active;
    });
  }

  void _filter(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _all
          : _all
              .where((p) => p.nama.toLowerCase().contains(query))
              .toList();
    });
  }

  Future<void> _onSubmitScan(String raw) async {
    final code = raw.trim();
    _scanCtrl.clear();
    _refocus();
    if (code.isEmpty) return;
    final produk = await sl<GetProdukByBarcode>()(code);
    final result = resolveScannedProduct(produk, isKasir: _isKasir);
    if (!mounted) return;
    switch (result.outcome) {
      case ScanOutcome.added:
        context.read<CashierBloc>().add(result.event!);
        break;
      case ScanOutcome.notFound:
        _flash('Barcode "$code" tidak ditemukan');
        break;
      case ScanOutcome.archived:
        _flash('Produk diarsipkan, tidak bisa dijual');
        break;
      case ScanOutcome.outOfStock:
        _flash('Stok habis');
        break;
    }
  }

  void _addProduct(Produk p) {
    final r = resolveScannedProduct(p, isKasir: _isKasir);
    if (r.outcome == ScanOutcome.added) {
      context.read<CashierBloc>().add(r.event!);
    } else {
      _flash('Stok habis');
    }
    _refocus();
  }

  void _flash(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _refocus() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _scanFocus.requestFocus());

  CashierReady _data(CashierState s) {
    if (s is CashierReady) return s;
    if (s is CashierError) {
      return CashierReady(cart: s.cart, jumlahBayar: s.jumlahBayar);
    }
    return const CashierReady();
  }

  Future<void> _pay(CashierReady data) async {
    if (data.cart.isEmpty) return;
    final bayar =
        await showPaymentDialog(context, total: data.totalSetelahDiskon);
    if (bayar == null || !mounted) return;
    _lastCart = List.from(data.cart);
    _lastBayar = bayar;
    _lastKembali = bayar - data.totalSetelahDiskon;
    context.read<CashierBloc>().add(UpdateJumlahBayar(bayar));
    context.read<CashierBloc>().add(const BayarCashier());
  }

  Future<void> _onSuccess(String transaksiId) async {
    final settings = sl<PrinterSettings>();
    final receipt = ReceiptGenerator(
      namaToko: settings.namaToko,
      alamatToko: settings.alamatToko,
      lebarKertas: settings.lebarKertas,
      fontSize: settings.fontSize,
    ).fromTransaction(
      transaksiId: transaksiId,
      cartItems: _lastCart ?? [],
      totalBayar: _lastBayar,
      kembalian: _lastKembali,
    );
    bool printed = false;
    try {
      printed = await sl<ReceiptPrinter>().printReceipt(receipt);
    } catch (_) {
      printed = false;
    }
    if (!mounted) return;
    if (printed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text('Lunas — kembali ${_rp.format(_lastKembali)}'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: const Text(
            'Transaksi tersimpan, tapi struk gagal cetak & laci tidak terbuka'),
      ));
    }
    _lastCart = null;
    context.read<CashierBloc>().add(InitCashier());
    _refocus();
  }

  Future<void> _bukaLaci() async {
    final ok = await sl<ReceiptPrinter>().openDrawer();
    if (!mounted) return;
    if (!ok) {
      _flash('Gagal buka laci — printer tidak siap');
    }
    _refocus();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocConsumer<CashierBloc, CashierState>(
      listener: (context, state) {
        if (state is CashierSuccess) _onSuccess(state.transaksiId);
        if (state is CashierError) _flash(state.message);
      },
      builder: (context, state) {
        final data = _data(state);
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.f9): () {
              if (data.cart.isNotEmpty) _pay(data);
            },
            const SingleActivator(LogicalKeyboardKey.f2): () =>
                _scanFocus.requestFocus(),
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
          appBar: AppBar(
            title: const Text('Kasir'),
            actions: [
              FutureBuilder<bool>(
                future: sl<ReceiptPrinter>().isReady(),
                builder: (context, snap) {
                  final ready = snap.data ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      avatar: Icon(Icons.print,
                          size: 16,
                          color: ready
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error),
                      label: Text(ready ? 'Printer siap' : 'Printer putus'),
                    ),
                  );
                },
              ),
              TextButton.icon(
                onPressed: _bukaLaci,
                icon: const Icon(Icons.point_of_sale),
                label: const Text('Buka Laci'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _scanCtrl,
                        focusNode: _scanFocus,
                        autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.qr_code_scanner),
                          hintText: 'Scan / ketik barcode, lalu Enter…',
                          filled: true,
                          fillColor: cs.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onSubmitted: _onSubmitScan,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: const InputDecoration(
                          isDense: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari produk (F2)…',
                        ),
                        onChanged: _filter,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _buildGrid()),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 4,
                child: CartPanel(
                  data: data,
                  onPay: () => _pay(data),
                  onRemove: (i) =>
                      context.read<CashierBloc>().add(RemoveFromCart(i)),
                  onEditQty: (i, q) {
                    if (q <= 0) {
                      context.read<CashierBloc>().add(RemoveFromCart(i));
                    } else {
                      context
                          .read<CashierBloc>()
                          .add(UpdateJumlahCart(i, q));
                    }
                    _refocus();
                  },
                ),
              ),
            ],
          ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    if (_filtered.isEmpty) {
      return const Center(child: Text('Produk tidak ada'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, i) {
        final p = _filtered[i];
        final habis = p.stok <= 0;
        return InkWell(
          onTap: habis ? null : () => _addProduct(p),
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: habis ? 0.5 : 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontWeight: FontWeight.w700)),
                    Text(_rp.format(p.hargaJual),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700)),
                    Text(habis ? 'Stok habis' : 'Stok ${p.stok}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
