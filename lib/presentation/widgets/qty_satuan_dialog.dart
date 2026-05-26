import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/produk.dart';

class QtySatuanDialog extends StatefulWidget {
  final Produk produk;
  final bool isPembelian;
  final Function(
    int qty,
    String produkId,
    String nama,
    double harga,
    String? satuanId,
    double konversi,
  ) onSelected;

  const QtySatuanDialog({
    super.key,
    required this.produk,
    required this.isPembelian,
    required this.onSelected,
  });

  @override
  State<QtySatuanDialog> createState() => _QtySatuanDialogState();
}

class _SatuanOption {
  final String nama;
  final double harga;
  final String? id;
  final double konversi;
  _SatuanOption(this.nama, this.harga, this.id, this.konversi);
}

class _QtySatuanDialogState extends State<QtySatuanDialog> {
  final _qtyCtrl = TextEditingController(text: '1');
  final _qtyFocus = FocusNode();
  final _satuanFocus = FocusNode();

  final List<_SatuanOption> _satuans = [];
  int _selectedSatuanIndex = 0;

  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _initSatuans();
    // Default focus to QTY and select all text
    _qtyFocus.addListener(() {
      if (_qtyFocus.hasFocus) {
        _qtyCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _qtyCtrl.text.length,
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _qtyFocus.requestFocus();
    });
  }

  void _initSatuans() {
    final hargaDasar = widget.isPembelian
        ? widget.produk.hargaBeli
        : widget.produk.hargaJual;

    // Base unit
    _satuans.add(
      _SatuanOption(
        widget.produk.satuan ?? 'pcs',
        hargaDasar,
        null,
        1.0,
      ),
    );

    // Other units
    final otherSatuans = (widget.produk.satuanList ?? [])
        .where((s) => s.nama != widget.produk.satuan)
        .toList();

    for (final s in otherSatuans) {
      final hargaSatuan = widget.isPembelian
          ? (s.hargaBeli > 0 ? s.hargaBeli : widget.produk.hargaBeli * s.konversi)
          : s.hargaJual;
      _satuans.add(
        _SatuanOption(
          s.nama,
          hargaSatuan,
          s.id,
          s.konversi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _qtyFocus.dispose();
    _satuanFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final qty = int.tryParse(_qtyCtrl.text) ?? 1;
    if (qty <= 0) return;

    final selected = _satuans[_selectedSatuanIndex];
    final produkId = widget.produk.id!;
    final nama = '${widget.produk.nama} - ${selected.nama}';

    Navigator.pop(context);
    widget.onSelected(
      qty,
      produkId,
      nama,
      selected.harga,
      selected.id,
      selected.konversi,
    );
  }

  KeyEventResult _handleQtyKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _satuanFocus.requestFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _submit();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.pop(context);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleSatuanKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _qtyFocus.requestFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (_selectedSatuanIndex < _satuans.length - 1) {
            _selectedSatuanIndex++;
          }
        });
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          if (_selectedSatuanIndex > 0) {
            _selectedSatuanIndex--;
          }
        });
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _submit();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.pop(context);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final selectedSatuan = _satuans[_selectedSatuanIndex];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.produk.nama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // QTY Field
                Expanded(
                  flex: 1,
                  child: Focus(
                    onKeyEvent: _handleQtyKeyEvent,
                    child: TextField(
                      controller: _qtyCtrl,
                      focusNode: _qtyFocus,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'QTY',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _qtyFocus.hasFocus
                                ? AppTheme.primaryGreen
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Satuan Field
                Expanded(
                  flex: 2,
                  child: Focus(
                    focusNode: _satuanFocus,
                    onKeyEvent: _handleSatuanKeyEvent,
                    child: Builder(
                      builder: (context) {
                        final isFocused = Focus.of(context).hasFocus;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isFocused
                                  ? AppTheme.primaryGreen
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: isFocused
                                ? AppTheme.primaryGreen.withValues(alpha: 0.05)
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SATUAN',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isFocused
                                      ? AppTheme.primaryGreen
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${selectedSatuan.nama} (${selectedSatuan.konversi.toInt()} ${widget.produk.satuan})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currency.format(selectedSatuan.harga),
                                style: const TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Gunakan panah Kiri/Kanan untuk berpindah antara QTY dan Satuan.\nPanah Atas/Bawah untuk mengubah Satuan.\nEnter untuk Simpan, Esc untuk Batal.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('BATAL'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
