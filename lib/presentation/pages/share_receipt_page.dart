import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/receipt_data.dart';
import '../../data/services/printer_service.dart';
import '../../data/services/printer_settings.dart';
import '../widgets/digital_receipt_widget.dart';

class ShareReceiptPage extends StatefulWidget {
  final ReceiptData receipt;

  const ShareReceiptPage({super.key, required this.receipt});

  @override
  State<ShareReceiptPage> createState() => _ShareReceiptPageState();
}

class _ShareReceiptPageState extends State<ShareReceiptPage> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSharing = false;
  bool _isPrintingPhysical = false;

  Future<void> _printPhysicalReceipt() async {
    final settings = sl<PrinterSettings>();
    if (!settings.enabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Printer tidak aktif. Aktifkan di Pengaturan Printer.',
            ),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
      return;
    }

    setState(() => _isPrintingPhysical = true);
    try {
      final printer = sl<PrinterService>();
      final success = await printer.printReceipt(widget.receipt);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nota berhasil dicetak ke thermal printer'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mencetak nota'),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error print: $e'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPrintingPhysical = false);
      }
    }
  }

  Future<void> _shareReceipt() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      // Small delay to ensure rendering is complete
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Gagal memproses gambar nota');

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) throw Exception('Gagal mengkonversi gambar');

      final pngBytes = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/nota_${widget.receipt.transaksiId}.png',
      );
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Nota Transaksi #${widget.receipt.transaksiId} dari ${widget.receipt.namaToko}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membagikan nota: ${e.toString()}'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Preview Nota'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 80.0,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // The RepaintBoundary should wrap only the widget we want to convert to image
              child: RepaintBoundary(
                key: _globalKey,
                child: DigitalReceiptWidget(receipt: widget.receipt),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isPrintingPhysical ? null : _printPhysicalReceipt,
                  icon: _isPrintingPhysical
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.print),
                  label: const Text('Cetak Thermal'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSharing ? null : _shareReceipt,
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.share),
                  label: const Text('Bagikan via WA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
