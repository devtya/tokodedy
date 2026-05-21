import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/notifikasi.dart';
import '../../domain/entities/pembelian.dart';
import '../../domain/entities/produk.dart';
import '../../domain/entities/transaksi.dart';
import '../../domain/usecases/produk/get_last_harga_change.dart';
import '../../domain/usecases/produk/get_last_pembelian.dart';
import '../../domain/usecases/produk/get_last_penjualan.dart';

class ProdukLogDialog extends StatefulWidget {
  final Produk produk;
  final bool isAdmin;
  final VoidCallback? onEditTap;

  const ProdukLogDialog({
    super.key,
    required this.produk,
    this.isAdmin = false,
    this.onEditTap,
  });

  @override
  State<ProdukLogDialog> createState() => _ProdukLogDialogState();
}

class _ProdukLogDialogState extends State<ProdukLogDialog> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  Pembelian? _lastPembelian;
  Transaksi? _lastPenjualan;
  Notifikasi? _lastHargaChange;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        sl<GetLastPembelianByProduk>().call(widget.produk.id!),
        sl<GetLastPenjualanByProduk>().call(widget.produk.id!),
        sl<GetLastHargaChangeByProduk>().call(widget.produk.nama),
      ]);
      if (mounted) {
        setState(() {
          _lastPembelian = results[0] as Pembelian?;
          _lastPenjualan = results[1] as Transaksi?;
          _lastHargaChange = results[2] as Notifikasi?;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(height: 24),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              _buildSection(
                icon: Icons.shopping_cart_outlined,
                title: 'Pembelian Terakhir',
                child: _lastPembelian != null
                    ? _buildPembelianContent()
                    : _buildEmpty(),
              ),
              const SizedBox(height: 12),
              _buildSection(
                icon: Icons.point_of_sale_outlined,
                title: 'Penjualan Terakhir',
                child: _lastPenjualan != null
                    ? _buildPenjualanContent()
                    : _buildEmpty(),
              ),
              const SizedBox(height: 12),
              _buildSection(
                icon: Icons.trending_up_outlined,
                title: 'Perubahan Harga Terakhir',
                child: _lastHargaChange != null
                    ? _buildHargaChangeContent()
                    : _buildEmpty(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.produk.nama,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _currency.format(widget.produk.hargaJual),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (widget.isAdmin && widget.onEditTap != null)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppTheme.primaryGreen,
            tooltip: 'Edit Produk',
            onPressed: () {
              Navigator.pop(context);
              widget.onEditTap!();
            },
          ),
        IconButton(
          icon: const Icon(Icons.close),
          color: AppTheme.neutralGrey,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.neutralGrey),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Text(
        'Belum ada data',
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.neutralGrey.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildPembelianContent() {
    final p = _lastPembelian!;
    final item = p.items?.isNotEmpty == true ? p.items!.first : null;
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Supplier', p.namaSupplier ?? 'Tidak diketahui'),
          _infoRow('Tanggal', _formatDate(p.createdAt)),
          if (item != null) ...[
            _infoRow('Jumlah', '${item.jumlah} ${widget.produk.satuan ?? "pcs"}'),
            _infoRow('Harga Beli', _currency.format(item.hargaBeliSatuan)),
          ],
        ],
      ),
    );
  }

  Widget _buildPenjualanContent() {
    final t = _lastPenjualan!;
    final item = t.items?.isNotEmpty == true ? t.items!.first : null;
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Tanggal', _formatDate(t.createdAt)),
          if (item != null) ...[
            _infoRow('Jumlah', '${item.jumlah} ${widget.produk.satuan ?? "pcs"}'),
            _infoRow('Harga Jual', _currency.format(item.hargaSatuan)),
          ],
          _infoRow('Status', t.status == 'lunas' ? 'Lunas' : 'Hutang'),
        ],
      ),
    );
  }

  Widget _buildHargaChangeContent() {
    final n = _lastHargaChange!;
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Tanggal', _formatDate(n.createdAt)),
          _infoRow('Keterangan', n.pesan),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.neutralGrey.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
