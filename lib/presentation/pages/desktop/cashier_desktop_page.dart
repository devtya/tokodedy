import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/platform/ui_scale.dart';
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
  Future<bool>? _printerReady;

  bool _gridView = true;
  double _splitFraction = 0.6; // share of width given to the product panel

  bool get _isKasir {
    final s = context.read<AuthBloc>().state;
    return s is Authenticated && s.user.isKasir;
  }

  @override
  void initState() {
    super.initState();
    context.read<CashierBloc>().add(InitCashier());
    _loadProducts();
    _refreshPrinterStatus();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scanFocus.requestFocus());
  }

  void _refreshPrinterStatus() =>
      setState(() => _printerReady = sl<ReceiptPrinter>().isReady());

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

  void _clearSearch() {
    _scanCtrl.clear();
    _filter('');
  }

  String _outcomeMsg(ScanOutcome o, String name) {
    switch (o) {
      case ScanOutcome.archived:
        return 'Produk diarsipkan, tidak bisa dijual';
      case ScanOutcome.outOfStock:
        return 'Stok $name habis';
      case ScanOutcome.notFound:
        return 'Produk tidak ditemukan';
      case ScanOutcome.added:
        return '';
    }
  }

  /// One unified input: a barcode scan (types + Enter) or a manual search.
  /// On Enter we first try a barcode lookup (scanner path); if that misses
  /// and the live filter narrowed to exactly one product, we add that.
  Future<void> _onSubmit(String raw) async {
    final code = raw.trim();
    if (code.isEmpty) return;
    final produk = await sl<GetProdukByBarcode>()(code);
    if (!mounted) return;
    if (produk != null) {
      _addProduct(produk);
      return;
    }
    if (_filtered.length == 1) {
      _addProduct(_filtered.first);
      return;
    }
    if (_filtered.isEmpty) {
      _flash('Tidak ada produk cocok dengan "$code"');
    }
    // Multiple matches: let the cashier tap a card/row.
  }

  void _addProduct(Produk p) {
    final r = resolveScannedProduct(p, isKasir: _isKasir);
    if (r.outcome == ScanOutcome.added) {
      context.read<CashierBloc>().add(r.event!);
      _clearSearch();
    } else {
      _flash(_outcomeMsg(r.outcome, p.nama));
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

  void _refocus() => WidgetsBinding.instance
      .addPostFrameCallback((_) => _scanFocus.requestFocus());

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
    _clearSearch();
    _refocus();
    if (mounted) _refreshPrinterStatus();
  }

  Future<void> _bukaLaci() async {
    bool ok;
    try {
      ok = await sl<ReceiptPrinter>().openDrawer();
    } catch (_) {
      ok = false;
    }
    if (!mounted) return;
    if (!ok) {
      _flash('Gagal buka laci — printer tidak siap');
    }
    _refocus();
    if (mounted) _refreshPrinterStatus();
  }

  @override
  Widget build(BuildContext context) {
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
            const SingleActivator(LogicalKeyboardKey.equal, control: true):
                UiScale.instance.zoomIn,
            const SingleActivator(LogicalKeyboardKey.add, control: true):
                UiScale.instance.zoomIn,
            const SingleActivator(LogicalKeyboardKey.minus, control: true):
                UiScale.instance.zoomOut,
            const SingleActivator(LogicalKeyboardKey.digit0, control: true):
                UiScale.instance.reset,
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Kasir'),
                actions: [
                  _ZoomControls(),
                  const SizedBox(width: 8),
                  FutureBuilder<bool>(
                    future: _printerReady,
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
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final totalW = constraints.maxWidth;
                  final leftW = (totalW * _splitFraction)
                      .clamp(300.0, (totalW - 340.0).clamp(300.0, totalW));
                  return Row(
                    children: [
                      SizedBox(width: leftW, child: _leftPanel(data)),
                      _SplitHandle(
                        onDrag: (dx) {
                          setState(() {
                            _splitFraction =
                                ((leftW + dx) / totalW).clamp(0.35, 0.72);
                          });
                        },
                      ),
                      Expanded(
                        child: CartPanel(
                          data: data,
                          onPay: () => _pay(data),
                          onRemove: (i) => context
                              .read<CashierBloc>()
                              .add(RemoveFromCart(i)),
                          onEditQty: (i, q) {
                            if (q <= 0) {
                              context
                                  .read<CashierBloc>()
                                  .add(RemoveFromCart(i));
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
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _leftPanel(CashierReady data) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _scanCtrl,
                  focusNode: _scanFocus,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.qr_code_scanner),
                    hintText: 'Scan barcode atau ketik nama produk…',
                    filled: true,
                    fillColor: cs.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: _scanCtrl.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _clearSearch();
                              _refocus();
                            },
                          ),
                  ),
                  onChanged: (_) {
                    setState(() {}); // refresh clear button
                    _filter(_scanCtrl.text);
                  },
                  onSubmitted: _onSubmit,
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                      value: true,
                      icon: Icon(Icons.grid_view),
                      tooltip: 'Grid'),
                  ButtonSegment(
                      value: false,
                      icon: Icon(Icons.view_list),
                      tooltip: 'List'),
                ],
                selected: {_gridView},
                onSelectionChanged: (s) =>
                    setState(() => _gridView = s.first),
              ),
            ],
          ),
        ),
        Expanded(child: _gridView ? _buildGrid() : _buildList()),
      ],
    );
  }

  Widget _buildGrid() {
    if (_filtered.isEmpty) {
      return const Center(child: Text('Produk tidak ada'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
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
                        style: const TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return const Center(child: Text('Produk tidak ada'));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _filtered.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final p = _filtered[i];
        final habis = p.stok <= 0;
        return Opacity(
          opacity: habis ? 0.5 : 1,
          child: ListTile(
            title: Text(p.nama,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(habis ? 'Stok habis' : 'Stok ${p.stok}'),
            trailing: Text(_rp.format(p.hargaJual),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700)),
            onTap: habis ? null : () => _addProduct(p),
          ),
        );
      },
    );
  }
}

/// Draggable vertical divider between the product and cart panels.
class _SplitHandle extends StatelessWidget {
  final void Function(double dx) onDrag;
  const _SplitHandle({required this.onDrag});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
        child: SizedBox(
          width: 10,
          child: Center(
            child: Container(width: 2, color: cs.outlineVariant),
          ),
        ),
      ),
    );
  }
}

/// Zoom out / percent / zoom in, bound to the app-wide [UiScale].
class _ZoomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: UiScale.instance.scale,
      builder: (context, s, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.zoom_out),
              tooltip: 'Perkecil (Ctrl -)',
              onPressed: s > UiScale.min ? UiScale.instance.zoomOut : null,
            ),
            InkWell(
              onTap: UiScale.instance.reset,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('${(s * 100).round()}%'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              tooltip: 'Perbesar (Ctrl +)',
              onPressed: s < UiScale.max ? UiScale.instance.zoomIn : null,
            ),
          ],
        );
      },
    );
  }
}
