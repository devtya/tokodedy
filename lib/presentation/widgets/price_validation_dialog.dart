import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/usecases/produk/update_produk.dart';
import '../../../domain/repositories/produk_repository.dart';

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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.changedItems) {
      if (_valData.containsKey(item.produkId)) continue;

      final produk = widget.produkMap[item.produkId]!;
      // Harga modal (dasar) baru = harga beli form / konversi
      final baseCost = item.hargaBeliSatuan / item.konversi;
      
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
      final satuanList = produk.satuanList ?? [];
      for (var s in satuanList) {
        units.add(_UnitValData(
          satuanId: s.id,
          namaSatuan: s.nama,
          konversi: s.konversi,
          hargaBeliBaru: baseCost * s.konversi,
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

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final updateProduk = sl<UpdateProduk>();
      final repo = sl<ProdukRepository>();
      
      for (var pData in _valData.values) {
        final produk = pData.produk;
        
        // Update Base Product
        final baseUnit = pData.units.firstWhere((u) => u.satuanId == null);
        final newBaseJual = double.tryParse(baseUnit.jualController.text) ?? baseUnit.hargaJualLama;
        
        final updatedProduk = produk.copyWith(
          hargaBeli: pData.baseCostBaru,
          hargaJual: newBaseJual,
        );
        await updateProduk(updatedProduk);
        
        // Update Satuan Konversi
        final satuanList = produk.satuanList ?? [];
        for (var s in satuanList) {
          final uData = pData.units.firstWhere((u) => u.satuanId == s.id);
          final newJual = double.tryParse(uData.jualController.text) ?? uData.hargaJualLama;
          
          await repo.updateSatuan(
            s.copyWith(
              hargaBeli: uData.hargaBeliBaru,
              hargaJual: newJual,
            ),
          );
        }
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Validasi Perubahan Harga'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Harga modal berubah! Berikut harga modal baru (dikonversi otomatis). Silakan sesuaikan harga jual untuk tiap satuan:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ...pData.units.map((uData) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(color: Colors.grey.shade300),
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
                                    const Text('Harga Jual:', style: TextStyle(fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Text(
                                      _currency.format(uData.hargaJualLama),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 12),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: uData.jualController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                          prefixText: 'Rp ',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveChanges,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan & Lanjutkan'),
        ),
      ],
    );
  }
}
