import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/platform/app_platform.dart';

Future<String?> showBarcodeScannerDialog(BuildContext context, {bool isOnlineOrder = false}) {
  // Desktop has no camera scanner; a USB keyboard-wedge scanner types the
  // barcode + Enter into a text field instead. Same return contract.
  if (AppPlatform.isDesktop) {
    return _showManualBarcodeDialog(context);
  }
  return showDialog<String>(
    context: context,
    builder: (ctx) => _buildCameraScanner(ctx, isOnlineOrder),
  );
}

Future<String?> _showManualBarcodeDialog(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Scan / Ketik Barcode'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.qr_code_scanner),
          hintText: 'Arahkan scanner atau ketik, lalu Enter',
        ),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim().isEmpty ? null : v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final v = controller.text.trim();
            Navigator.pop(ctx, v.isEmpty ? null : v);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

AlertDialog _buildCameraScanner(BuildContext context, bool isOnlineOrder) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: SizedBox(
      width: double.maxFinite,
      height: 300,
      child: MobileScanner(
        controller: MobileScannerController(
          formats: [
            BarcodeFormat.code128,
            BarcodeFormat.code39,
            BarcodeFormat.code93,
            BarcodeFormat.codabar,
            BarcodeFormat.ean13,
            BarcodeFormat.ean8,
            BarcodeFormat.itf,
            BarcodeFormat.upcA,
            BarcodeFormat.upcE,
            if (isOnlineOrder) BarcodeFormat.qrCode,
          ],
        ),
        onDetect: (capture) {
          final barcode = capture.barcodes.firstOrNull?.rawValue;
          if (barcode != null) {
            Navigator.pop(context, barcode);
          }
        },
      ),
    ),
  );
}


