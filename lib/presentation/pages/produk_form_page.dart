import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/barcode_scanner_widget.dart';

import '../../core/theme/app_theme.dart';
import '../../core/di/injection.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/produk.dart';
import '../../domain/entities/satuan_produk.dart';
import '../blocs/produk/produk_bloc.dart';
import '../blocs/produk/produk_event.dart';
import '../blocs/produk/produk_state.dart';

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
  late TextEditingController _kategoriCtrl;
  late TextEditingController _satuanDasarCtrl;

  // ── State ──
  bool _saved = false;
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
    _kategoriCtrl.dispose();
    _satuanDasarCtrl.dispose();
    super.dispose();
  }

  // ── Computed ──

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
    final result = await showModalBottomSheet<_UnitItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditUnitSheet(unit: unit),
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

  // ── Submit ──
  void _submit() {
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
    final currentTokoId = _currentProduk?.tokoId ?? sl<TokoService>().tokoId ?? '';
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
      kategori: _kategoriCtrl.text.trim().isEmpty
          ? null
          : _kategoriCtrl.text.trim().toUpperCase(),
      satuan: _satuanDasarCtrl.text.trim().isEmpty
          ? 'pcs'
          : _satuanDasarCtrl.text.trim(),
      satuanList: satuanList,
    );

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
      backgroundColor: AppTheme.background,
      body: BlocListener<ProdukBloc, ProdukState>(
        listener: (context, state) {
          if (state is ProdukOperationSuccess && _saved) {
            setState(() => _saved = false);
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
        },
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
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
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A2E17), AppTheme.background],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing
                      ? 'EDIT DATA ITEM • $_displayCode'
                      : 'TAMBAH DATA ITEM',
                  style: const TextStyle(
                    color: AppTheme.grey,
                    fontSize: 9,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
                const Text(
                  'Satuan & Harga Jual',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primary),
            ),
            child: const Text(
              'PUSAT',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
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
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: const InputDecoration(
            labelText: 'NAMA PRODUK *',
            labelStyle: TextStyle(
              color: AppTheme.grey,
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
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: const InputDecoration(
                  labelText: 'BARCODE',
                  labelStyle: TextStyle(
                    color: AppTheme.grey,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                  hintText: 'Opsional',
                  hintStyle: TextStyle(color: AppTheme.grey, fontSize: 13),
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
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: AppTheme.primary,
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
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: const InputDecoration(
                  labelText: 'STOK',
                  labelStyle: TextStyle(
                    color: AppTheme.grey,
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
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: const InputDecoration(
                  labelText: 'KATEGORI',
                  labelStyle: TextStyle(
                    color: AppTheme.grey,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                  hintText: 'Opsional',
                  hintStyle: TextStyle(color: AppTheme.grey, fontSize: 13),
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
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _satuanDasarCtrl,
                  readOnly: false,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
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
                    color: AppTheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppTheme.primary, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Tambah Satuan',
                        style: TextStyle(
                          color: AppTheme.primary,
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
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF444444), width: 1.5),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Menggunakan harga pokok jika tidak memenuhi kriteria',
              style: TextStyle(color: AppTheme.grey, fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ──
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.background.withValues(alpha: 0),
            AppTheme.background,
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.maybePop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppTheme.border, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _saved ? '✓ Tersimpan!' : 'Simpan',
                style: const TextStyle(
                  color: AppTheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.grey,
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
    final ctrl = TextEditingController(
      text: current > 0 ? current.toStringAsFixed(2) : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerLow,
        title: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(color: AppTheme.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(ctrl.text);
              if (val != null) onSave?.call(val);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Simpan',
              style: TextStyle(color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: unit.isBase
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F4C2A), Color(0xFF1A6B3A)],
              )
            : null,
        color: unit.isBase ? null : AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unit.isBase ? AppTheme.primary : AppTheme.border,
          width: 1.5,
        ),
        boxShadow: unit.isBase
            ? [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
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
                    color: unit.isBase
                        ? AppTheme.primary
                        : const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    unit.nama,
                    style: TextStyle(
                      color: unit.isBase ? AppTheme.onPrimary : Colors.grey,
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
                        style: const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 9,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'Konversi: ${unit.konversi.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white70,
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
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary),
                    ),
                    child: const Text(
                      'BASE',
                      style: TextStyle(
                        color: AppTheme.primary,
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
                        color: AppTheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.error,
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
                    accent: unit.isBase
                        ? AppTheme.primary
                        : const Color(0xFFF39C12),
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
                  accent: unit.laba >= 0 ? AppTheme.primary : AppTheme.error,
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
    final color =
        accent ??
        (highlight ? const Color(0xFFF39C12) : const Color(0xFFDDDDDD));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight
              ? (accent ?? const Color(0xFFF39C12)).withValues(alpha: 0.2)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.grey,
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
  const _EditUnitSheet({required this.unit});

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

    for (final c in [_hargaPokokCtrl, _hargaJualCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
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
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppTheme.border),
          left: BorderSide(color: AppTheme.border),
          right: BorderSide(color: AppTheme.border),
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
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Satuan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _namaCtrl.text,
                    style: const TextStyle(
                      color: AppTheme.onPrimary,
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
                    ? AppTheme.primary.withValues(alpha: 0.08)
                    : AppTheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (_laba >= 0 ? AppTheme.primary : AppTheme.error)
                      .withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Laba',
                    style: TextStyle(color: AppTheme.grey, fontSize: 12),
                  ),
                  Text(
                    'Rp ${formatRp(_laba)} (${_labaPct.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: _laba >= 0 ? AppTheme.primary : AppTheme.error,
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
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan Satuan',
                  style: TextStyle(
                    color: AppTheme.onPrimary,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.grey,
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
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
