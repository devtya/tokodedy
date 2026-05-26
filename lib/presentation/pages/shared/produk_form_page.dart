import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/barcode_scanner_widget.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/toko_service.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/entities/satuan_produk.dart';
import '../../../domain/repositories/produk_repository.dart';
import '../../blocs/produk/produk_bloc.dart';
import '../../blocs/produk/produk_event.dart';
import '../../blocs/produk/produk_state.dart';

// ─── HELPERS ─────────────────────────────────────────────────────────────────

String formatRp(double val) {
  final parts = val.toStringAsFixed(2).split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => '.',
  );
  return '$intPart,${parts[1]}';
}

// ─── MAIN PAGE ────────────────────────────────────────────────────────────────

class ProdukFormPage extends StatefulWidget {
  final Produk? produk;
  final String? initialName;
  final String? initialBarcode;

  const ProdukFormPage({
    super.key,
    this.produk,
    this.initialName,
    this.initialBarcode,
  });

  @override
  State<ProdukFormPage> createState() => _ProdukFormPageState();
}

class _ProdukFormPageState extends State<ProdukFormPage> {
  bool get _isEditing => _currentProduk != null;

  Produk? _currentProduk;

  // ── Product Info controllers ──
  late TextEditingController _namaCtrl;
  late TextEditingController _barcodeCtrl;
  late TextEditingController _stokCtrl;
  late TextEditingController _stokMinimumCtrl;
  late TextEditingController _kategoriCtrl;
  late TextEditingController _satuanDasarCtrl;

  // ── State ──
  bool _saved = false;
  bool _isSaving = false;
  final List<String> _addedIds = [];

  // ── Unit list (multi-satuan) ──
  final List<_UnitItem> _units = [];
  int _nextUnitId = 1;

  @override
  void initState() {
    super.initState();
    _currentProduk = widget.produk;

    final p = _currentProduk;

    _namaCtrl = TextEditingController(
      text: p?.nama ?? widget.initialName ?? '',
    );
    _barcodeCtrl = TextEditingController(
      text: p?.barcode ?? widget.initialBarcode ?? '',
    );
    _stokCtrl = TextEditingController(text: p?.stok.toString() ?? '');
    _stokMinimumCtrl = TextEditingController(
      text: p?.stokMinimum?.toString() ?? '',
    );
    _kategoriCtrl = TextEditingController(text: p?.kategori ?? '');
    _satuanDasarCtrl = TextEditingController(text: p?.satuan ?? 'pcs');

    // Auto-sync Base Unit name with Satuan Dasar input when adding new product
    _satuanDasarCtrl.addListener(() {
      final idx = _units.indexWhere((u) => u.isBase);
      if (idx != -1) {
        final newName = _satuanDasarCtrl.text.trim().isEmpty
            ? 'pcs'
            : _satuanDasarCtrl.text.trim();
        if (_units[idx].nama != newName) {
          setState(() {
            _units[idx] = _units[idx].copyWith(nama: newName);
          });
        }
      }
    });

    // Load existing satuan
    final existing = p?.satuanList;
    if (existing != null && existing.isNotEmpty) {
      for (int i = 0; i < existing.length; i++) {
        _units.add(
          _UnitItem(
            id: _nextUnitId++,
            dbId: existing[i].id,
            nama: existing[i].nama,
            isBase: i == 0,
            konversi: existing[i].konversi,
            hargaBeli: existing[i].hargaBeli,
            hargaJual: existing[i].hargaJual,
          ),
        );
      }
    } else if (_isEditing) {
      // Existing product without satuanList — pre-populate one base unit
      _units.add(
        _UnitItem(
          id: _nextUnitId++,
          nama: p!.satuan ?? 'pcs',
          isBase: true,
          konversi: 1.0,
          hargaBeli: p.hargaBeli,
          hargaJual: p.hargaJual,
        ),
      );
    } else {
      // NEW product — pre-populate one base unit with 0 price
      _units.add(
        _UnitItem(
          id: _nextUnitId++,
          nama: _satuanDasarCtrl.text.trim().isEmpty
              ? 'pcs'
              : _satuanDasarCtrl.text.trim(),
          isBase: true,
          konversi: 1.0,
          hargaBeli: 0,
          hargaJual: 0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _barcodeCtrl.dispose();
    _stokCtrl.dispose();
    _stokMinimumCtrl.dispose();
    _kategoriCtrl.dispose();
    _satuanDasarCtrl.dispose();
    super.dispose();
  }

  // ── Computed ──

  ThemeData get _theme => Theme.of(context);
  ColorScheme get _colors => _theme.colorScheme;

  String get _displayCode =>
      _isEditing ? (_currentProduk!.barcode ?? _currentProduk!.nama) : 'BARU';

  void _resetForm({required bool copyName}) {
    setState(() {
      _currentProduk = null;
      _saved = false;
      if (!copyName) {
        _namaCtrl.clear();
        _kategoriCtrl.clear();
        _satuanDasarCtrl.text = 'pcs';
      }
      _barcodeCtrl.clear();
      _stokCtrl.text = '0';
      _stokMinimumCtrl.clear();
      _units.clear();
      _nextUnitId = 1;
      _units.add(
        _UnitItem(
          id: _nextUnitId++,
          nama: _satuanDasarCtrl.text.trim().isEmpty
              ? 'pcs'
              : _satuanDasarCtrl.text.trim(),
          isBase: true,
          konversi: 1.0,
          hargaBeli: 0,
          hargaJual: 0,
        ),
      );
    });
  }

  // ── Unit actions ──
  void _editUnit(_UnitItem unit) async {
    final base = _units.firstWhere((u) => u.isBase, orElse: () => _units.first);
    final result = await showModalBottomSheet<_UnitItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditUnitSheet(unit: unit, baseHargaBeli: base.hargaBeli),
    );
    if (result != null) {
      setState(() {
        final idx = _units.indexWhere((u) => u.id == result.id);
        if (idx != -1) _units[idx] = result;
      });
      _recalculateBaseHargaBeli();
    }
  }

  void _deleteUnit(int id) {
    setState(() => _units.removeWhere((u) => u.id == id));
  }

  void _addUnit() {
    final newUnit = _UnitItem(
      id: _nextUnitId++,
      nama: 'BARU',
      isBase: false,
      konversi: 1.0,
      hargaBeli: 0,
      hargaJual: 0,
    );
    setState(() => _units.add(newUnit));
    _editUnit(newUnit);
  }

  void _recalculateBaseHargaBeli() {
    final nonBase = _units
        .where((u) => !u.isBase && u.konversi > 0 && u.hargaBeli > 0)
        .toList();
    if (nonBase.isEmpty) return;
    double? lowest;
    for (final u in nonBase) {
      final base = u.hargaBeli / u.konversi;
      if (lowest == null || base < lowest) lowest = base;
    }
    if (lowest != null) {
      final idx = _units.indexWhere((u) => u.isBase);
      if (idx != -1) {
        _units[idx] = _units[idx].copyWith(hargaBeli: lowest);
      }
      setState(() {});
    }
  }

  Future<void> _openBarcodeScanner() async {
    final barcode = await showBarcodeScannerDialog(context);
    if (barcode != null) {
      _barcodeCtrl.text = barcode;
    }
  }

  Future<void> _showSearchPickerDialog({
    required String title,
    required List<String> items,
    required TextEditingController controller,
  }) async {
    final result = await showDialog<String>(
      context: context,
      useSafeArea: false,
      builder: (_) => _SearchPickerDialog(
        title: title,
        items: items,
        initialValue: controller.text,
      ),
    );
    if (result != null) {
      controller.text = result;
    }
  }

  // ── Submit ──
  void _submit() {
    if (_isSaving) return;
    if (_namaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama produk wajib diisi')));
      return;
    }

    List<SatuanProduk>? satuanList;
    double hargaBeli;
    double hargaJual;

    if (_units.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal satu satuan')),
      );
      return;
    }
    final currentTokoId =
        _currentProduk?.tokoId ?? sl<TokoService>().tokoId ?? '';
    satuanList = _units
        .where((u) => u.nama.trim().isNotEmpty)
        .map(
          (u) => SatuanProduk(
            id: u.dbId,
            tokoId: currentTokoId,
            produkId: _currentProduk?.id ?? '',
            nama: u.nama.trim(),
            konversi: u.konversi,
            hargaBeli: u.hargaBeli,
            hargaJual: u.hargaJual,
          ),
        )
        .toList();

    // Base unit's prices become the product-level prices
    final base = _units.firstWhere((u) => u.isBase, orElse: () => _units.first);
    hargaBeli = base.hargaBeli;
    hargaJual = base.hargaJual;

    final produk = Produk(
      id: _currentProduk?.id,
      tokoId: currentTokoId,
      nama: _namaCtrl.text.trim().toUpperCase(),
      barcode: _barcodeCtrl.text.trim().isEmpty
          ? null
          : _barcodeCtrl.text.trim(),
      hargaBeli: hargaBeli,
      hargaJual: hargaJual,
      stok: int.tryParse(_stokCtrl.text.trim()) ?? 0,
      stokMinimum: int.tryParse(_stokMinimumCtrl.text.trim()),
      kategori: _kategoriCtrl.text.trim().isEmpty
          ? null
          : _kategoriCtrl.text.trim().toUpperCase(),
      satuan: _satuanDasarCtrl.text.trim().isEmpty
          ? 'pcs'
          : _satuanDasarCtrl.text.trim(),
      satuanList: satuanList,
    );

    setState(() => _isSaving = true);
    if (_isEditing) {
      context.read<ProdukBloc>().add(UpdateProdukEvent(produk));
    } else {
      context.read<ProdukBloc>().add(AddProdukEvent(produk));
    }
    setState(() => _saved = true);
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.surface,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomBar(),
      body: BlocListener<ProdukBloc, ProdukState>(
        listener: (context, state) {
          if (state is ProdukOperationSuccess && _saved) {
            setState(() {
              _saved = false;
              _isSaving = false;
            });
            if (state.newId != null) {
              _addedIds.add(state.newId!);
            }

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text('Produk Berhasil Disimpan'),
                content: const Text('Apa yang ingin Anda lakukan selanjutnya?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.maybePop(
                        context,
                        _addedIds.isNotEmpty ? _addedIds : null,
                      );
                    },
                    child: const Text('Selesai'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _resetForm(copyName: false);
                    },
                    child: const Text('Input Barang Baru'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _resetForm(copyName: true);
                    },
                    child: const Text('Copy & Input Baru'),
                  ),
                ],
              ),
            );
          }
          if (state is ProdukError) {
            setState(() => _isSaving = false);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductInfo(),
              const SizedBox(height: 16),
              _buildSatDasarSection(),
              const SizedBox(height: 20),
              _buildUnitList(),
              const SizedBox(height: 12),
              _buildHitungButton(),
              const SizedBox(height: 10),
              _buildDefaultCheckbox(),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _colors.primaryContainer,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(Icons.arrow_back, color: _colors.onSurface, size: 20),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditing ? 'EDIT DATA ITEM • $_displayCode' : 'TAMBAH DATA ITEM',
            style: TextStyle(
              color: _colors.onSurface.withValues(alpha: 0.55),
              fontSize: 9,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
          const Text(
            'Satuan & Harga Jual',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _colors.primary),
          ),
          child: Text(
            'PUSAT',
            style: TextStyle(
              color: _colors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  // ── Product Info ──
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('INFORMASI PRODUK'),
        const SizedBox(height: 8),
        TextField(
          controller: _namaCtrl,
          textCapitalization: TextCapitalization.characters,
          style: TextStyle(color: _colors.onSurface, fontSize: 15),
          decoration: InputDecoration(
            labelText: 'NAMA PRODUK *',
            labelStyle: TextStyle(
              color: _colors.onSurface.withValues(alpha: 0.45),
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _barcodeCtrl,
                style: TextStyle(color: _colors.onSurface, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'BARCODE',
                  labelStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                  hintText: 'Opsional',
                  hintStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _openBarcodeScanner,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _colors.primary),
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  color: _colors.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _stokCtrl,
                keyboardType: TextInputType.number,
                style: TextStyle(color: _colors.onSurface, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'STOK',
                  labelStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _kategoriCtrl,
                readOnly: true,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(color: _colors.onSurface, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'KATEGORI',
                  labelStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                  hintText: 'Tap untuk pilih / ketik baru',
                  hintStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  final repo = sl<ProdukRepository>();
                  repo.getAllKategori().then((items) {
                    _showSearchPickerDialog(
                      title: 'Kategori',
                      items: items,
                      controller: _kategoriCtrl,
                    );
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _stokMinimumCtrl,
                keyboardType: TextInputType.number,
                style: TextStyle(color: _colors.onSurface, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'STOK MINIMUM',
                  labelStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                  hintText: 'Ikut pengaturan toko jika kosong',
                  hintStyle: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Satuan Dasar ──
  Widget _buildSatDasarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('SATUAN DASAR'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _colors.outline, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _satuanDasarCtrl,
                  readOnly: true,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTap: () {
                    final repo = sl<ProdukRepository>();
                    repo.getAllSatuan().then((items) {
                      _showSearchPickerDialog(
                        title: 'Satuan',
                        items: items,
                        controller: _satuanDasarCtrl,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Unit List (multi-satuan mode) ──
  Widget _buildUnitList() {
    final children = <Widget>[
      _sectionLabel('DAFTAR SATUAN (${_units.length})'),
      const SizedBox(height: 12),
    ];

    for (int i = 0; i < _units.length; i++) {
      final unit = _units[i];
      children.add(
        _UnitCard(
          unit: unit,
          onHargaPokokChanged: (v) {
            setState(() => _units[i] = unit.copyWith(hargaBeli: v));
            _recalculateBaseHargaBeli();
          },
          onHargaJualChanged: (v) {
            setState(() => _units[i] = unit.copyWith(hargaJual: v));
          },
          onDelete: unit.isBase ? null : () => _deleteUnit(unit.id),
        ),
      );

      if (i == 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _addUnit,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _colors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _colors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: _colors.primary, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Tambah Satuan',
                        style: TextStyle(
                          color: _colors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  // ── Hitung Button ──
  Widget _buildHitungButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _recalculateBaseHargaBeli,
        icon: const Icon(
          Icons.calculate_outlined,
          color: AppTheme.info,
          size: 16,
        ),
        label: const Text(
          'Hitung Harga Pokok Dasar',
          style: TextStyle(color: AppTheme.info, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          side: const BorderSide(color: AppTheme.info, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ── Default Checkbox ──
  Widget _buildDefaultCheckbox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _colors.onSurface.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _colors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: _colors.outlineVariant,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _colors.outline, width: 1.5),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Menggunakan harga pokok jika tidak memenuhi kriteria',
              style: TextStyle(
                color: _colors.onSurface.withValues(alpha: 0.45),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ──
  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_colors.surface.withValues(alpha: 0), _colors.surface],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: _colors.outline, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: _colors.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _colors.onPrimary,
                        ),
                      )
                    : Text(
                        _saved ? '✓ Tersimpan!' : 'Simpan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _colors.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _colors.onSurface.withValues(alpha: 0.45),
        fontSize: 10,
        letterSpacing: 1.5,
        fontFamily: 'monospace',
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _UnitItem — lightweight UI model for satuan entries
// ═══════════════════════════════════════════════════════════════════════════════

class _UnitItem {
  final int id;
  final String? dbId;
  String nama;
  bool isBase;
  double konversi;
  double hargaBeli;
  double hargaJual;

  _UnitItem({
    required this.id,
    this.dbId,
    required this.nama,
    this.isBase = false,
    required this.konversi,
    required this.hargaBeli,
    required this.hargaJual,
  });

  double get laba => hargaJual - hargaBeli;
  double get labaPct => hargaBeli > 0 ? (laba / hargaBeli) * 100 : 0;

  String get jnsSatuan => isBase ? 'Satuan Dasar' : 'Konversi';

  _UnitItem copyWith({
    String? nama,
    double? konversi,
    double? hargaBeli,
    double? hargaJual,
    bool? isBase,
  }) {
    return _UnitItem(
      id: id,
      dbId: dbId,
      nama: nama ?? this.nama,
      isBase: isBase ?? this.isBase,
      konversi: konversi ?? this.konversi,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _UnitCard
// ═══════════════════════════════════════════════════════════════════════════════

class _UnitCard extends StatelessWidget {
  final _UnitItem unit;
  final ValueChanged<double>? onHargaPokokChanged;
  final ValueChanged<double>? onHargaJualChanged;
  final VoidCallback? onDelete;

  const _UnitCard({
    required this.unit,
    this.onHargaPokokChanged,
    this.onHargaJualChanged,
    this.onDelete,
  });

  void _editPrice(
    BuildContext context,
    String label,
    double current,
    ValueChanged<double>? onSave,
  ) {
    final colors = Theme.of(context).colorScheme;
    final ctrl = TextEditingController(
      text: current > 0 ? current.toStringAsFixed(2) : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          label,
          style: TextStyle(color: colors.onSurface, fontSize: 16),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: TextStyle(color: colors.onSurface, fontSize: 18),
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: TextStyle(color: colors.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(ctrl.text);
              if (val != null) onSave?.call(val);
              Navigator.pop(ctx);
            },
            child: Text('Simpan', style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: unit.isBase
            ? colors.primary.withValues(alpha: 0.08)
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unit.isBase
              ? colors.primary.withValues(alpha: 0.5)
              : colors.outline,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: unit.isBase ? colors.primary : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    unit.nama,
                    style: TextStyle(
                      color: unit.isBase
                          ? colors.onPrimary
                          : colors.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.jnsSatuan.toUpperCase(),
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.45),
                          fontSize: 9,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'Konversi: ${unit.konversi.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unit.isBase)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.primary),
                    ),
                    child: Text(
                      'BASE',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                if (!unit.isBase && onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: colors.error,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Info grid — harga cells are tappable
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: [
                GestureDetector(
                  onTap: () => _editPrice(
                    context,
                    'Harga Pokok',
                    unit.hargaBeli,
                    onHargaPokokChanged,
                  ),
                  child: _InfoCell(
                    label: 'HARGA POKOK',
                    value: 'Rp ${formatRp(unit.hargaBeli)}',
                    highlight: true,
                  ),
                ),
                GestureDetector(
                  onTap: () => _editPrice(
                    context,
                    'Harga Jual',
                    unit.hargaJual,
                    onHargaJualChanged,
                  ),
                  child: _InfoCell(
                    label: 'HARGA JUAL',
                    value: 'Rp ${formatRp(unit.hargaJual)}',
                    highlight: true,
                    accent: unit.isBase ? colors.primary : colors.primary,
                  ),
                ),
                _InfoCell(
                  label: 'KONVERSI',
                  value: unit.konversi.toStringAsFixed(2),
                ),
                _InfoCell(
                  label: 'LABA',
                  value:
                      'Rp ${formatRp(unit.laba)} (${unit.labaPct.toStringAsFixed(1)}%)',
                  accent: unit.laba >= 0 ? colors.primary : colors.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _InfoCell
// ═══════════════════════════════════════════════════════════════════════════════

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color? accent;

  const _InfoCell({
    required this.label,
    required this.value,
    this.highlight = false,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final defaultAccent = highlight
        ? colors.primary
        : colors.onSurface.withValues(alpha: 0.87);
    final color = accent ?? defaultAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight
              ? (accent ?? colors.primary).withValues(alpha: 0.2)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.45),
              fontSize: 8,
              letterSpacing: 1,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
              fontFamily: 'monospace',
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  EditUnitSheet — Bottom sheet for editing a single satuan entry
// ═══════════════════════════════════════════════════════════════════════════════

class _EditUnitSheet extends StatefulWidget {
  final _UnitItem unit;
  final double baseHargaBeli;
  const _EditUnitSheet({required this.unit, this.baseHargaBeli = 0});

  @override
  State<_EditUnitSheet> createState() => _EditUnitSheetState();
}

class _EditUnitSheetState extends State<_EditUnitSheet> {
  late TextEditingController _namaCtrl;
  late TextEditingController _konversiCtrl;
  late TextEditingController _hargaPokokCtrl;
  late TextEditingController _hargaJualCtrl;

  double get _laba =>
      (double.tryParse(_hargaJualCtrl.text) ?? 0) -
      (double.tryParse(_hargaPokokCtrl.text) ?? 0);

  double get _labaPct {
    final pokok = double.tryParse(_hargaPokokCtrl.text) ?? 0;
    return pokok > 0 ? (_laba / pokok) * 100 : 0;
  }

  void _onKonversiChanged() {
    final konversi = double.tryParse(_konversiCtrl.text) ?? 0;
    if (konversi > 0 && widget.baseHargaBeli > 0) {
      final auto = widget.baseHargaBeli * konversi;
      _hargaPokokCtrl.text = auto.toStringAsFixed(2);
    }
  }

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.unit.nama);
    _konversiCtrl = TextEditingController(
      text: widget.unit.konversi.toStringAsFixed(2),
    );
    _hargaPokokCtrl = TextEditingController(
      text: widget.unit.hargaBeli > 0
          ? widget.unit.hargaBeli.toStringAsFixed(2)
          : '',
    );
    _hargaJualCtrl = TextEditingController(
      text: widget.unit.hargaJual > 0
          ? widget.unit.hargaJual.toStringAsFixed(2)
          : '',
    );

    if (widget.unit.hargaBeli <= 0 &&
        widget.baseHargaBeli > 0 &&
        widget.unit.konversi > 0) {
      final auto = widget.baseHargaBeli * widget.unit.konversi;
      _hargaPokokCtrl.text = auto.toStringAsFixed(2);
    }

    _konversiCtrl.addListener(_onKonversiChanged);
    for (final c in [_hargaPokokCtrl, _hargaJualCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _konversiCtrl.removeListener(_onKonversiChanged);
    _namaCtrl.dispose();
    _konversiCtrl.dispose();
    _hargaPokokCtrl.dispose();
    _hargaJualCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.unit.copyWith(
      nama: _namaCtrl.text,
      konversi: double.tryParse(_konversiCtrl.text) ?? widget.unit.konversi,
      hargaBeli: double.tryParse(_hargaPokokCtrl.text) ?? widget.unit.hargaBeli,
      hargaJual: double.tryParse(_hargaJualCtrl.text) ?? widget.unit.hargaJual,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: colors.outline),
          left: BorderSide(color: colors.outline),
          right: BorderSide(color: colors.outline),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Satuan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _namaCtrl.text,
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _field('Nama Satuan', _namaCtrl, uppercase: true),
            _field('Konversi', _konversiCtrl, numeric: true),
            _field('Harga Pokok (Rp)', _hargaPokokCtrl, numeric: true),
            _field('Harga Jual (Rp)', _hargaJualCtrl, numeric: true),
            const SizedBox(height: 4),

            // Laba preview
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _laba >= 0
                    ? colors.primary.withValues(alpha: 0.08)
                    : colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (_laba >= 0 ? colors.primary : colors.error)
                      .withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Laba',
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.45),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Rp ${formatRp(_laba)} (${_labaPct.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: _laba >= 0 ? colors.primary : colors.error,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan Satuan',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool numeric = false,
    bool uppercase = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.45),
              fontSize: 9,
              letterSpacing: 1.5,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            keyboardType: numeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            textCapitalization: uppercase
                ? TextCapitalization.characters
                : TextCapitalization.none,
            style: TextStyle(color: colors.onSurface, fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.outline, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.outline, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SEARCH PICKER DIALOG ──────────────────────────────────────────────────────

class _SearchPickerDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final String initialValue;

  const _SearchPickerDialog({
    required this.title,
    required this.items,
    required this.initialValue,
  });

  @override
  State<_SearchPickerDialog> createState() => _SearchPickerDialogState();
}

class _SearchPickerDialogState extends State<_SearchPickerDialog> {
  late final TextEditingController _ctrl;
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[SearchPicker] initState title=${widget.title} items=${widget.items.length}',
    );
    _ctrl = TextEditingController(text: widget.initialValue);
    final q = widget.initialValue.toUpperCase();
    _filtered = q.isEmpty
        ? widget.items
        : widget.items.where((s) => s.toUpperCase().contains(q)).toList();
  }

  @override
  void dispose() {
    debugPrint('[SearchPicker] dispose');
    _ctrl.dispose();
    super.dispose();
  }

  void _filter(String v) {
    debugPrint('[SearchPicker] filter input="$v"');
    final q = v.toUpperCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items.where((s) => s.toUpperCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[SearchPicker] build filtered=${_filtered.length}');
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Cari...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: _filter,
                    ),
                  ),
                  if (_ctrl.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _ctrl.clear();
                        _filter('');
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length + 1,
                itemBuilder: (ctx, i) {
                  if (i < _filtered.length) {
                    final item = _filtered[i];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        debugPrint('[SearchPicker] select existing="$item"');
                        Navigator.pop(context, item);
                      },
                    );
                  }
                  final typed = _ctrl.text.trim().toUpperCase();
                  if (typed.isEmpty) return const SizedBox();
                  return ListTile(
                    leading: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text("Gunakan '$typed'"),
                    onTap: () {
                      debugPrint('[SearchPicker] select new="$typed"');
                      Navigator.pop(context, typed);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () {
                  debugPrint('[SearchPicker] tap Tutup');
                  Navigator.pop(context);
                },
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
