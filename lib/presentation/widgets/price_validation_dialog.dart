import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/usecases/stok/buat_pembelian.dart';

sealed class PriceValidationResult {}

class UpdateHargaJualResult extends PriceValidationResult {
  final List<PriceChange> priceChanges;
  UpdateHargaJualResult(this.priceChanges);
}

class KeepHargaJualResult extends PriceValidationResult {
  final List<PriceChange> priceChanges;
  KeepHargaJualResult(this.priceChanges);
}

class CancelPriceValidationResult extends PriceValidationResult {}

class PriceValidationItem {
  final String produkId;
  final double konversi;
  final double hargaBeliSatuan;

  const PriceValidationItem({
    required this.produkId,
    required this.konversi,
    required this.hargaBeliSatuan,
  });
}

class _UnitValData {
  final String? satuanId; // null if base
  final String namaSatuan;
  final double konversi;
  final double hargaBeliBaru;
  final double hargaJualLama;
  final TextEditingController jualController;
  
  _UnitValData({
    required this.satuanId,
    required this.namaSatuan,
    required this.konversi,
    required this.hargaBeliBaru,
    required this.hargaJualLama,
    required this.jualController,
  });
}

class _ProductValData {
  final Produk produk;
  final double baseCostBaru;
  final List<_UnitValData> units;
  
  _ProductValData({
    required this.produk,
    required this.baseCostBaru,
    required this.units,
  });
}

class PriceValidationDialog extends StatefulWidget {
  final List<PriceValidationItem> changedItems;
  final Map<String, Produk> produkMap;

  const PriceValidationDialog({
    super.key,
    required this.changedItems,
    required this.produkMap,
  });

  @override
  State<PriceValidationDialog> createState() => _PriceValidationDialogState();
}

class _PriceValidationDialogState extends State<PriceValidationDialog> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  
  final Map<String, _ProductValData> _valData = {};
  bool _hasPopped = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.changedItems) {
      if (_valData.containsKey(item.produkId)) continue;

      final produk = widget.produkMap[item.produkId];
      if (produk == null) continue;

      // Guard: konversi 0 atau negatif (data lama/korup) akan menghasilkan
      // Infinity/NaN kalau dipakai sebagai pembagi. Fallback ke harga beli
      // form apa adanya supaya dialog tidak menampilkan "Rp ∞".
      final baseCost = item.konversi > 0
          ? item.hargaBeliSatuan / item.konversi
          : item.hargaBeliSatuan;
      
      final units = <_UnitValData>[];
      
      // Base unit
      units.add(_UnitValData(
        satuanId: null,
        namaSatuan: produk.satuan ?? 'pcs',
        konversi: 1.0,
        hargaBeliBaru: baseCost,
        hargaJualLama: produk.hargaJual,
        jualController: TextEditingController(text: produk.hargaJual.toStringAsFixed(0)),
      ));
      
      // Konversi units
      // PENTING: dedup berdasarkan id (identitas row di database), bukan
      // nama (string bebas). Dedup by nama bikin unit ke-skip diam-diam
      // kalau ada dua row satuan_produk dengan nama sama untuk produk yang
      // sama (typo/duplikat input) — unit itu lalu tidak ikut ter-update
      // saat _saveChanges(), tapi tetap ada di database dengan harga lama.
      final satuanList = produk.satuanList ?? [];
      final addedUnitIds = <String>{};
      final baseUnitNama = (produk.satuan ?? 'pcs').toUpperCase();
      
      for (var s in satuanList) {
        if (s.id == null) continue; // row tanpa id tidak bisa diidentifikasi unik, skip aman
        if (addedUnitIds.contains(s.id)) continue;
        // Skip kalau unit ini representasi base unit (nama sama dengan produk.satuan)
        // -- dicek terpisah dari dedup id supaya tidak bias false-positive
        if (s.nama.toUpperCase() == baseUnitNama && s.konversi == 1.0) continue;
        addedUnitIds.add(s.id!);
        
        // Guard yang sama untuk konversi per-unit: konversi <= 0 dianggap rusak,
        // jangan ikut dikalikan supaya tidak merembet jadi Infinity/NaN di UI.
        final konversiAman = s.konversi > 0 ? s.konversi : 1.0;
        
        units.add(_UnitValData(
          satuanId: s.id,
          namaSatuan: s.nama,
          konversi: konversiAman,
          hargaBeliBaru: baseCost * konversiAman,
          hargaJualLama: s.hargaJual,
          jualController: TextEditingController(text: s.hargaJual.toStringAsFixed(0)),
        ));
      }
      
      _valData[item.produkId] = _ProductValData(
        produk: produk,
        baseCostBaru: baseCost,
        units: units,
      );
    }
  }

  @override
  void dispose() {
    for (var p in _valData.values) {
      for (var u in p.units) {
        u.jualController.dispose();
      }
    }
    super.dispose();
  }

  void _submit(bool updateHargaJual) {
    if (_hasPopped) return;
    _hasPopped = true;
    try {
      final List<PriceChange> priceChanges = [];
      
      for (var pData in _valData.values) {
        final produk = pData.produk;
        
        // Update Base Product
        final baseUnit = pData.units.where((u) => u.satuanId == null).firstOrNull;
        if (baseUnit == null) continue;
        final newBaseJual = updateHargaJual 
            ? (double.tryParse(baseUnit.jualController.text) ?? baseUnit.hargaJualLama)
            : baseUnit.hargaJualLama;
        
        // Update Satuan Konversi
        final satuanChanges = <SatuanPriceChange>[];
        for (var uData in pData.units) {
          if (uData.satuanId == null) continue; // base unit sudah diupdate di atas
          final newJual = updateHargaJual
              ? (double.tryParse(uData.jualController.text) ?? uData.hargaJualLama)
              : uData.hargaJualLama;
          satuanChanges.add(SatuanPriceChange(
            satuanId: uData.satuanId!,
            hargaBeli: uData.hargaBeliBaru,
            hargaJual: newJual,
          ));
        }

        priceChanges.add(PriceChange(
          produkId: produk.id!,
          hargaBeliBaru: pData.baseCostBaru,
          hargaJualBaru: newBaseJual,
          satuanChanges: satuanChanges,
        ));
      }
      
      final result = updateHargaJual 
          ? UpdateHargaJualResult(priceChanges)
          : KeepHargaJualResult(priceChanges);
          
      Navigator.pop(context, result);
    } catch (e) {
      _hasPopped = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: const Text('Validasi Perubahan Harga'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Harga modal berubah! Berikut harga modal baru (dikonversi otomatis). Silakan sesuaikan harga jual untuk tiap satuan:',
              style: TextStyle(fontSize: 13, color: isDark ? AppTheme.neutralGrey : AppTheme.lightTextSecondary),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _valData.length,
                itemBuilder: (context, index) {
                  final pData = _valData.values.elementAt(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pData.produk.nama,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : AppTheme.lightText),
                        ),
                        const SizedBox(height: 8),
                        ...pData.units.map((uData) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.surfaceContainerLow : AppTheme.lightBackground,
                              border: Border.all(color: isDark ? AppTheme.border : AppTheme.lightBorder),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: uData.satuanId == null ? AppTheme.primary : Colors.orange,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        uData.namaSatuan.toUpperCase(),
                                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Modal Baru: ${_currency.format(uData.hargaBeliBaru)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.warningRed),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Harga Jual:', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : AppTheme.lightTextSecondary)),
                                    const SizedBox(width: 8),
                                    Text(
                                      _currency.format(uData.hargaJualLama),
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                        color: isDark ? AppTheme.neutralGrey : AppTheme.lightGrey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 12),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: uData.jualController,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.lightText),
                                        decoration: InputDecoration(
                                          prefixText: 'Rp ',
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          filled: true,
                                          fillColor: isDark ? AppTheme.surfaceInput : AppTheme.lightBackground,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            borderSide: BorderSide(color: isDark ? AppTheme.border : AppTheme.lightBorder),
                                          ),
                                        ),
                                        onTap: () {
                                          uData.jualController.selection = TextSelection(
                                            baseOffset: 0,
                                            extentOffset: uData.jualController.text.length,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _hasPopped ? null : () => _submit(true),
                child: const Text('Simpan & Update Harga Jual'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _hasPopped ? null : () => _submit(false),
                child: const Text('Simpan, Harga Jual Tetap'),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _hasPopped ? null : () {
                  _hasPopped = true;
                  Navigator.pop(context, CancelPriceValidationResult());
                },
                child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightText)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
