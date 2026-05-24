import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cashier/cashier_bloc.dart';
import '../../blocs/cashier/cashier_event.dart';
import '../../blocs/cashier/cashier_state.dart';
import '../../utils/dialog_utils.dart';
import '../../../domain/usecases/transaksi/buat_transaksi.dart';

class CashierDesktopView extends StatefulWidget {
  final CashierState state;
  final CashierReady data;
  final TextEditingController bayarController;
  final bool isPrinting;
  final VoidCallback onOpenCariProduk;
  final VoidCallback onOpenScanner;
  final VoidCallback onOpenPendingDialog;
  final void Function(int index, CartItem item) onShowDiskonDialog;
  final void Function(int index, String namaProduk, int currentJumlah)
  onShowEditJumlahDialog;
  final VoidCallback onShowHutangDialog;
  final VoidCallback onSavePending;
  final void Function(CashierReady data) onShowBayarConfirmation;

  const CashierDesktopView({
    super.key,
    required this.state,
    required this.data,
    required this.bayarController,
    required this.isPrinting,
    required this.onOpenCariProduk,
    required this.onOpenScanner,
    required this.onOpenPendingDialog,
    required this.onShowDiskonDialog,
    required this.onShowEditJumlahDialog,
    required this.onShowHutangDialog,
    required this.onSavePending,
    required this.onShowBayarConfirmation,
  });

  @override
  State<CashierDesktopView> createState() => _CashierDesktopViewState();
}

class _CashierDesktopViewState extends State<CashierDesktopView> {
  final _barcodeCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');

  final _barcodeFocus = FocusNode();
  final _qtyFocus = FocusNode();
  final ScrollController _cartScrollCtrl = ScrollController();

  List<Produk> _allProducts = [];
  List<Produk> _filteredProducts = [];
  int _selectedIndex = 0;
  bool _loading = true;
  String _selectedKategori = 'Semua';

  List<String> get _kategoriList {
    final list = _allProducts
        .map((e) => e.kategori?.trim() ?? '')
        .where((k) => k.isNotEmpty)
        .toSet()
        .toList();
    list.sort();
    return ['Semua', ...list, 'Lainnya'];
  }

  final currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  bool get _isKasir {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) return authState.user.isKasir;
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(covariant CashierDesktopView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.cart != oldWidget.data.cart && widget.data.cart.isNotEmpty) {
      final oldFirst = oldWidget.data.cart.isNotEmpty ? oldWidget.data.cart.first : null;
      final newFirst = widget.data.cart.first;
      if (oldFirst?.produkId != newFirst.produkId || oldFirst?.jumlah != newFirst.jumlah) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_cartScrollCtrl.hasClients) {
            _cartScrollCtrl.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _qtyCtrl.dispose();
    _barcodeFocus.dispose();
    _qtyFocus.dispose();
    _cartScrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await sl<GetAllProduk>().call();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _filteredProducts = List.from(products);
          _loading = false;
        });
        _filterProducts();
        _barcodeFocus.requestFocus();
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filterProducts([String? val]) {
    final query = (val ?? _barcodeCtrl.text).toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final cat = p.kategori?.trim() ?? '';
        final matchCat = _selectedKategori == 'Semua' ||
            (_selectedKategori == 'Lainnya' && cat.isEmpty) ||
            cat == _selectedKategori;
        
        if (!matchCat) return false;
        if (query.isEmpty) return true;
        
        return p.nama.toLowerCase().contains(query) ||
            (p.barcode != null && p.barcode!.toLowerCase().contains(query));
      }).toList();
      _selectedIndex = 0;
    });
  }

  void _handleBarcodeSubmit(String value) {
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 1;

    if (value.trim().isEmpty) {
      // Pindah ke QTY
      _qtyFocus.requestFocus();
      return;
    }

    // Coba exact barcode match
    final exactMatch = _allProducts
        .where((p) => p.barcode == value.trim())
        .toList();
    if (exactMatch.isNotEmpty) {
      _addToCart(exactMatch.first, qty);
      _resetInput();
      return;
    }

    // Jika tidak ada exact barcode, tapi ada _filteredProducts, pakai yg disorot
    if (_filteredProducts.isNotEmpty &&
        _selectedIndex >= 0 &&
        _selectedIndex < _filteredProducts.length) {
      _addToCart(_filteredProducts[_selectedIndex], qty);
      _resetInput();
      return;
    }

    // Gagal ketemu
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Produk tidak ditemukan')));
  }

  void _handleQtySubmit(String value) {
    // Pindah kembali ke barcode
    _barcodeFocus.requestFocus();
  }

  void _resetInput() {
    _barcodeCtrl.clear();
    _qtyCtrl.text = '1';
    _filterProducts('');

    // Memberikan sedikit jeda sebelum request focus agar tidak di-override oleh event dialog
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _barcodeFocus.requestFocus();
      }
    });
  }

  void _addToCart(Produk produk, int qty) {
    final pokok = _isKasir ? 0.0 : produk.hargaBeli;

    DialogUtils.showPilihSatuanDialog(
      context: context,
      produk: produk,
      isPembelian: false,
      onSelected: (id, nama, harga, satuanId, konversi) {
        context.read<CashierBloc>().add(
          AddToCart(
            produkId: id,
            namaProduk: nama,
            hargaJual: harga,
            hargaPokok: pokok,
            jumlah: qty, // dari kolom QTY
          ),
        );
        _resetInput();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.f3): const _CashierIntent('F3'),
        LogicalKeySet(LogicalKeyboardKey.f5): const _CashierIntent('F5'),
        LogicalKeySet(LogicalKeyboardKey.f6): const _CashierIntent('F6'),
        LogicalKeySet(LogicalKeyboardKey.f7): const _CashierIntent('F7'),
        LogicalKeySet(LogicalKeyboardKey.end): const _CashierIntent('END'),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _CashierIntent: CallbackAction<_CashierIntent>(
            onInvoke: (_CashierIntent intent) {
              switch (intent.keyId) {
                case 'F3':
                  widget.onOpenCariProduk();
                  break;
                case 'F5':
                  if (widget.data.cart.isNotEmpty) widget.onSavePending();
                  break;
                case 'F6':
                  widget.onOpenPendingDialog();
                  break;
                case 'F7':
                  if (widget.data.cart.isNotEmpty) widget.onShowHutangDialog();
                  break;
                case 'END':
                  if (widget.data.cart.isNotEmpty)
                    widget.onShowBayarConfirmation(widget.data);
                  break;
              }
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Row(
            children: [
              // KIRI: Pencarian & Daftar Barang (40%)
              Expanded(
                flex: 2,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      // Header & Input
                      Container(
                        height: 160,
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: KeyboardListener(
                                    focusNode:
                                        FocusNode(), // Dummy focus to catch keys
                                    onKeyEvent: (event) {
                                      if (event is KeyDownEvent) {
                                        if (event.logicalKey ==
                                            LogicalKeyboardKey.arrowDown) {
                                          if (_selectedIndex <
                                              _filteredProducts.length - 1) {
                                            setState(() => _selectedIndex++);
                                          }
                                        } else if (event.logicalKey ==
                                            LogicalKeyboardKey.arrowUp) {
                                          if (_selectedIndex > 0) {
                                            setState(() => _selectedIndex--);
                                          }
                                        }
                                      }
                                    },
                                    child: TextField(
                                      controller: _barcodeCtrl,
                                      focusNode: _barcodeFocus,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Scan barcode atau cari nama produk...',
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            Icons.qr_code_scanner,
                                          ),
                                          onPressed: widget.onOpenScanner,
                                        ),
                                      ),
                                      onChanged: _filterProducts,
                                      onSubmitted: _handleBarcodeSubmit,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: _qtyCtrl,
                                    focusNode: _qtyFocus,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      labelText: 'QTY',
                                    ),
                                    onSubmitted: _handleQtySubmit,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kosongkan lalu Enter untuk pindah ke QTY. Panah Atas/Bawah untuk memilih dari daftar.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _kategoriList.map((kat) {
                                    final isSel = kat == _selectedKategori;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(kat),
                                        selected: isSel,
                                        onSelected: (val) {
                                          if (val) {
                                            setState(() => _selectedKategori = kat);
                                            _filterProducts();
                                          }
                                        },
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        labelStyle: TextStyle(
                                          color: isSel
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer
                                              : null,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Grid Produk
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : _filteredProducts.isEmpty
                            ? Center(
                                child: Text(
                                  'Barang tidak ditemukan',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final p = _filteredProducts[index];
                                  final isSelected = index == _selectedIndex;
                                  return InkWell(
                                    onTap: () {
                                      setState(() => _selectedIndex = index);
                                      final qty =
                                          int.tryParse(_qtyCtrl.text.trim()) ??
                                          1;
                                      _addToCart(p, qty);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.primaryGreen
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.03,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p.nama,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (p.barcode != null) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    p.barcode!,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                currency.format(p.hargaJual),
                                                style: const TextStyle(
                                                  color: AppTheme.primaryGreen,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: p.stok > 0
                                                      ? AppTheme.primary
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                      : AppTheme.warningRed
                                                            .withValues(
                                                              alpha: 0.1,
                                                            ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Stok: ${p.stok}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: p.stok > 0
                                                        ? AppTheme.primary
                                                        : AppTheme.warningRed,
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
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              VerticalDivider(
                width: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),

              // KANAN: Keranjang & Pembayaran (60%)
              Expanded(
                flex: 3,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      // Header Total Pembayaran (menggantikan tombol pending)
                      Container(
                        height: 160,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        color: Theme.of(context).cardColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL PEMBAYARAN',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currency.format(widget.data.totalSetelahDiskon),
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List Keranjang
                      Expanded(
                        child: widget.data.cart.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Keranjang Kosong',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                controller: _cartScrollCtrl,
                                itemCount: widget.data.cart.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final item = widget.data.cart[index];
                                  return _CartItemRow(
                                    index: index,
                                    item: item,
                                    currency: currency,
                                    onShowDiskonDialog:
                                        widget.onShowDiskonDialog,
                                    onDelete: () => context
                                        .read<CashierBloc>()
                                        .add(RemoveFromCart(index)),
                                    onQtyChanged: (newQty) {
                                      // Only update if value changed and is valid
                                      if (newQty > 0 && newQty != item.jumlah) {
                                        context.read<CashierBloc>().add(
                                          UpdateJumlahCart(index, newQty),
                                        );
                                      }
                                    },
                                    onQtySubmit: () {
                                      _barcodeFocus.requestFocus();
                                    },
                                  );
                                },
                              ),
                      ),

                      // Summary & Payment
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
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
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: widget.data.cart.isEmpty
                                        ? null
                                        : () => context.read<CashierBloc>().add(const ClearCart()),
                                    icon: const Icon(Icons.delete_sweep),
                                    label: const Text(
                                      'BATAL',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.warningRed,
                                      side: widget.data.cart.isEmpty ? null : const BorderSide(color: AppTheme.warningRed),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: widget.data.cart.isEmpty
                                        ? null
                                        : widget.onShowHutangDialog,
                                    icon: const Icon(Icons.book),
                                    label: const Text(
                                      'HUTANG (F7)',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: widget.data.cart.isEmpty
                                        ? null
                                        : () => widget.onShowBayarConfirmation(
                                            widget.data,
                                          ),
                                    icon: widget.isPrinting
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.payments),
                                    label: Text(
                                      widget.isPrinting
                                          ? 'Printing...'
                                          : 'BAYAR (END)',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryGreen,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CashierIntent extends Intent {
  final String keyId;
  const _CashierIntent(this.keyId);
}

class _CartItemRow extends StatefulWidget {
  final int index;
  final CartItem item;
  final NumberFormat currency;
  final void Function(int index, CartItem item) onShowDiskonDialog;
  final VoidCallback onDelete;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onQtySubmit;

  const _CartItemRow({
    required this.index,
    required this.item,
    required this.currency,
    required this.onShowDiskonDialog,
    required this.onDelete,
    required this.onQtyChanged,
    required this.onQtySubmit,
  });

  @override
  State<_CartItemRow> createState() => _CartItemRowState();
}

class _CartItemRowState extends State<_CartItemRow> {
  late TextEditingController _qtyCtrl;
  late FocusNode _qtyFocus;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(text: widget.item.jumlah.toString());
    _qtyFocus = FocusNode();
    _qtyFocus.addListener(() {
      if (_qtyFocus.hasFocus) {
        _qtyCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _qtyCtrl.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant _CartItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.jumlah != widget.item.jumlah) {
      if (_qtyCtrl.text != widget.item.jumlah.toString()) {
        _qtyCtrl.text = widget.item.jumlah.toString();
      }
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _qtyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.index.isEven
        ? Colors.transparent
        : (isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200);

    return Container(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                widget.item.namaProduk,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: Text(
                widget.currency.format(widget.item.hargaJual),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 8),
            const Text('x', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              height: 36,
              child: TextField(
                controller: _qtyCtrl,
                focusNode: _qtyFocus,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onChanged: (val) {
                  final newQty = int.tryParse(val);
                  if (newQty != null) {
                    widget.onQtyChanged(newQty);
                  }
                },
                onSubmitted: (_) => widget.onQtySubmit(),
              ),
            ),
            const SizedBox(width: 8),
            const Text('=', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                widget.currency.format(widget.item.subtotal),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: InkWell(
                onTap: () =>
                    widget.onShowDiskonDialog(widget.index, widget.item),
                child: Text(
                  widget.item.diskonTipe == 0
                      ? '-'
                      : widget.item.diskonTipe == 1
                      ? '${widget.item.diskonValue}%'
                      : widget.currency.format(widget.item.diskonValue),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.item.diskonTipe != 0
                        ? AppTheme.warningRed
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppTheme.warningRed,
                ),
                onPressed: widget.onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
