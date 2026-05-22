import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/barcode_scanner_widget.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/produk.dart';
import '../../domain/usecases/produk/get_all_produk.dart';
import '../blocs/produk/produk_bloc.dart';
import '../blocs/produk/produk_event.dart';
import '../blocs/produk/produk_state.dart';
import '../../core/di/injection.dart';
import '../blocs/stok/stok_bloc.dart';
import '../widgets/produk_card.dart';
import '../widgets/produk_log_dialog.dart';
import '../widgets/sync_indicator.dart';
import 'produk_form_page.dart';
import 'stok_page.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final _searchController = TextEditingController();
  List<Produk> _allProducts = [];
  List<Produk> _filteredProducts = [];
  String? _selectedKategori;
  bool _loadingProducts = true;

  @override
  void initState() {
    super.initState();
    context.read<ProdukBloc>().add(LoadProduk());
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await sl<GetAllProduk>().call();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _searchProducts(_searchController.text);
          _loadingProducts = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final q = query.toLowerCase();
        final matchQuery = q.isEmpty ||
            p.nama.toLowerCase().contains(q) ||
            (p.barcode?.toLowerCase().contains(q) ?? false);
        final matchKategori = _selectedKategori == null ||
            _selectedKategori == 'Semua' ||
            p.kategori == _selectedKategori;
        return matchQuery && matchKategori;
      }).toList();
    });
  }

  List<String> get _kategoriList {
    final set = <String>{};
    for (final p in _allProducts) {
      if (p.kategori != null && p.kategori!.isNotEmpty) {
        set.add(p.kategori!);
      }
    }
    final sorted = set.toList()..sort();
    return ['Semua', ...sorted];
  }

  Future<void> _openScanner() async {
    final barcode = await showBarcodeScannerDialog(context);
    if (barcode != null) {
      _searchController.text = barcode;
      _searchProducts(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isAdmin = (authState is Authenticated && authState.user.isOwner) ||
            (authState is StoreRegistered && authState.user.isOwner);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daftar Produk'),
            actions: [
              const SyncIndicator(),
              if (isAdmin) ...[
                IconButton(
                  icon: const Icon(Icons.add_business),
                  tooltip: 'Tambah Produk',
                  onPressed: () => _openForm(),
                ),
              ],
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchProducts('');
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: _openScanner,
                        ),
                      ],
                    ),
                  ),
                  onChanged: _searchProducts,
                ),
              ),
              _buildCategoryFilter(),
              Expanded(
                child: BlocListener<ProdukBloc, ProdukState>(
                  listener: (context, state) {
                    if (state is ProdukOperationSuccess) {
                      _loadProducts();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                    if (state is ProdukError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppTheme.warningRed,
                        ),
                      );
                    }
                  },
                  child: _buildProductList(isAdmin),
                ),
              ),
            ],
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  onPressed: () => _openForm(),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    final kategoriList = _kategoriList;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: kategoriList.map((k) {
            final selected = _selectedKategori == k ||
                (k == 'Semua' && _selectedKategori == null);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(k, style: const TextStyle(fontSize: 12)),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    _selectedKategori = val ? (k == 'Semua' ? null : k) : null;
                    _searchProducts(_searchController.text);
                  });
                },
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductList(bool isAdmin) {
    if (_loadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty
              ? 'Produk "${_searchController.text}" tidak ditemukan'
              : 'Belum ada produk',
          style: TextStyle(color: AppTheme.neutralGrey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final produk = _filteredProducts[index];
          return ProdukCard(
            produk: produk,
            onTap: isAdmin ? () => _openForm(produk: produk) : null,
            onStockTap: isAdmin ? () => _openStok(produk) : null,
            onDelete: isAdmin ? () => _confirmDelete(produk.id!) : null,
            onLogTap: () => _showProdukLog(produk, isAdmin),
          );
        },
      ),
    );
  }

  void _openForm({Produk? produk}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProdukBloc>(),
          child: ProdukFormPage(produk: produk),
        ),
      ),
    );
  }

  void _openStok(Produk produk) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: sl<StokBloc>(),
          child: StokPage(produk: produk),
        ),
      ),
    );
  }

  void _showProdukLog(Produk produk, bool isAdmin) {
    showDialog(
      context: context,
      builder: (ctx) => ProdukLogDialog(
        produk: produk,
        isAdmin: isAdmin,
        onEditTap: isAdmin ? () => _openForm(produk: produk) : null,
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProdukBloc>().add(DeleteProdukEvent(id));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
