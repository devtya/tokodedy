import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/backup_result.dart';
import '../../domain/entities/produk.dart' as domain;
import '../../domain/entities/satuan_produk.dart' as domain;
import '../../domain/repositories/backup_repository.dart';
import '../../domain/repositories/produk_repository.dart';

// ---------------------------------------------------------------------------
// Data class returned from isolate (only primitives — safe to cross isolates)
// ---------------------------------------------------------------------------

class _ParsedExcelData {
  final List<Map<String, dynamic>> produkRows;
  final Map<String, List<Map<String, dynamic>>> satuanByNama;
  final String errorMessage;

  const _ParsedExcelData({
    required this.produkRows,
    required this.satuanByNama,
    this.errorMessage = '',
  });
}

// ---------------------------------------------------------------------------
// Top-level isolate function (must be top-level to work with compute)
// ---------------------------------------------------------------------------

Future<_ParsedExcelData> _parseExcelInIsolate(String filePath) async {
  try {
    final bytes = await File(filePath).readAsBytes();
    final excel = Excel.decodeBytes(bytes);

    final sheet1 = excel['Produk'];
    final sheet2 = excel['SatuanProduk'];

    if (sheet1.rows.length < 2) {
      return const _ParsedExcelData(
        produkRows: [],
        satuanByNama: {},
        errorMessage: 'File Excel kosong atau tidak memiliki data produk',
      );
    }

    // Parse satuan sheet
    final Map<String, List<Map<String, dynamic>>> satuanByNama = {};
    if (sheet2.rows.length >= 2) {
      final satuanHeaders = _excelParseHeader(sheet2.rows[0]);
      for (int i = 1; i < sheet2.rows.length; i++) {
        final rowData = _excelParseRow(satuanHeaders, sheet2.rows[i]);
        if (rowData == null) continue;
        final namaProduk = (rowData['nama_produk'] ?? '').toString().trim();
        if (namaProduk.isEmpty) continue;
        satuanByNama.putIfAbsent(namaProduk, () => []).add({
          'nama': (rowData['nama_satuan'] ?? '').toString().trim(),
          'konversi': _excelParseDouble(rowData['konversi']) ?? 1.0,
          'hargaBeli': _excelParseDouble(rowData['hargaBeli']) ?? 0.0,
          'hargaJual': _excelParseDouble(rowData['hargaJual']) ?? 0.0,
        });
      }
    }

    // Parse produk sheet
    final headers = _excelParseHeader(sheet1.rows[0]);
    final List<Map<String, dynamic>> produkRows = [];
    for (int i = 1; i < sheet1.rows.length; i++) {
      final rowData = _excelParseRow(headers, sheet1.rows[i]);
      if (rowData == null) continue;
      final nama = (rowData['nama'] ?? '').toString().trim();
      if (nama.isEmpty) continue;
      produkRows.add({
        'nama': nama,
        'barcode': (rowData['barcode'] ?? '').toString().trim(),
        'hargaBeli': _excelParseDouble(rowData['hargaBeli']) ?? 0.0,
        'hargaJual': _excelParseDouble(rowData['hargaJual']) ?? 0.0,
        'stok': _excelParseInt(rowData['stok']) ?? 0,
        'kategori': (rowData['kategori'] ?? '').toString().trim(),
        'satuan': (rowData['satuan'] ?? 'pcs').toString().trim(),
      });
    }

    return _ParsedExcelData(produkRows: produkRows, satuanByNama: satuanByNama);
  } catch (e) {
    return _ParsedExcelData(
      produkRows: [],
      satuanByNama: {},
      errorMessage: 'Gagal membaca file Excel: $e',
    );
  }
}

// Top-level pure helpers (no Flutter/DB deps)
List<String> _excelParseHeader(List<Data?> row) {
  return row.map((cell) {
    final val = cell?.value;
    return val?.toString().trim().toLowerCase() ?? '';
  }).toList();
}

Map<String, dynamic>? _excelParseRow(List<String> headers, List<Data?> row) {
  if (row.isEmpty) return null;
  final data = <String, dynamic>{};
  for (int i = 0; i < headers.length; i++) {
    final cell = i < row.length ? row[i] : null;
    data[headers[i]] = cell?.value;
  }
  return data;
}

double? _excelParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '.').trim());
  return null;
}

int? _excelParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class BackupRepositoryImpl implements BackupRepository {
  final ProdukRepository _produkRepository;

  BackupRepositoryImpl(this._produkRepository);

  @override
  Future<String> exportToExcel() async {
    final produkList = await _produkRepository.getAllProduk();

    final excel = Excel.createExcel();
    final sheet1 = excel['Produk'];
    final sheet2 = excel['SatuanProduk'];

    sheet1.appendRow([
      TextCellValue('nama'),
      TextCellValue('barcode'),
      TextCellValue('hargaBeli'),
      TextCellValue('hargaJual'),
      TextCellValue('stok'),
      TextCellValue('kategori'),
      TextCellValue('satuan'),
    ]);

    sheet2.appendRow([
      TextCellValue('nama_produk'),
      TextCellValue('nama_satuan'),
      TextCellValue('konversi'),
      TextCellValue('hargaBeli'),
      TextCellValue('hargaJual'),
    ]);

    for (final produk in produkList) {
      sheet1.appendRow([
        TextCellValue(produk.nama),
        TextCellValue(produk.barcode ?? ''),
        DoubleCellValue(produk.hargaBeli),
        DoubleCellValue(produk.hargaJual),
        IntCellValue(produk.stok),
        TextCellValue(produk.kategori ?? ''),
        TextCellValue(produk.satuan ?? 'pcs'),
      ]);

      final satuanList = await _produkRepository.getSatuanByProdukId(produk.id!);
      for (final satuan in satuanList) {
        sheet2.appendRow([
          TextCellValue(produk.nama),
          TextCellValue(satuan.nama),
          DoubleCellValue(satuan.konversi),
          DoubleCellValue(satuan.hargaBeli),
          DoubleCellValue(satuan.hargaJual),
        ]);
      }
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'backup_produk_$timestamp.xlsx';
    final fileBytes = excel.encode();
    if (fileBytes == null) throw Exception('Gagal mengenkripsi file Excel');

    final dir = await getTemporaryDirectory();
    if (!await dir.exists()) await dir.create(recursive: true);
    final filePath = '${dir.path}/$fileName';
    await File(filePath).writeAsBytes(fileBytes);

    await Share.shareXFiles([XFile(filePath)], text: 'Backup Produk');

    return filePath;
  }

  @override
  Future<BackupResult> restoreFromExcel(String filePath) async {
    // Step 1: Parse Excel di background isolate (heavy CPU — tidak freeze UI)
    final parsed = await compute<String, _ParsedExcelData>(
      _parseExcelInIsolate,
      filePath,
    );

    if (parsed.errorMessage.isNotEmpty) {
      return BackupResult(
        imported: 0,
        skipped: 0,
        message: parsed.errorMessage,
      );
    }

    if (parsed.produkRows.isEmpty) {
      return const BackupResult(
        imported: 0,
        skipped: 0,
        message: 'File Excel kosong atau tidak memiliki data produk',
      );
    }

    // Step 2: Konversi Map → domain entity (di main isolate)
    final List<domain.Produk> produkList = parsed.produkRows.map((m) {
      final barcode = (m['barcode'] as String).isNotEmpty
          ? m['barcode'] as String
          : null;
      return domain.Produk(
        tokoId: '',
        nama: m['nama'] as String,
        barcode: barcode,
        hargaBeli: (m['hargaBeli'] as num).toDouble(),
        hargaJual: (m['hargaJual'] as num).toDouble(),
        stok: m['stok'] as int,
        kategori: m['kategori'] as String,
        satuan: m['satuan'] as String,
      );
    }).toList();

    final Map<String, List<domain.SatuanProduk>> satuanByNama = {};
    parsed.satuanByNama.forEach((namaProduk, list) {
      satuanByNama[namaProduk] = list
          .map((m) => domain.SatuanProduk(
                tokoId: '',
                produkId: '',
                nama: m['nama'] as String,
                konversi: (m['konversi'] as num).toDouble(),
                hargaBeli: (m['hargaBeli'] as num).toDouble(),
                hargaJual: (m['hargaJual'] as num).toDouble(),
              ))
          .toList();
    });

    // Step 3: Import ke DB dalam satu transaction (cepat, tidak freeze UI)
    final existingBarcodes = await _produkRepository.getAllBarcodes();
    final result = await _produkRepository.importAll(
      produkList: produkList,
      satuanByNama: satuanByNama,
      existingBarcodes: existingBarcodes,
    );

    return BackupResult(
      imported: result.imported,
      skipped: result.skipped,
      message: 'Berhasil import ${result.imported} produk'
          '${result.skipped > 0 ? ", ${result.skipped} produk dilewati (duplikat)" : ""}',
    );
  }
}
