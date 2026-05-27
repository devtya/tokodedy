import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> showBarcodeScannerDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _buildCameraScanner(ctx),
  );
}

AlertDialog _buildCameraScanner(BuildContext context) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: SizedBox(
      width: double.maxFinite,
      height: 300,
      child: MobileScanner(
        controller: MobileScannerController(
          formats: const [
            BarcodeFormat.code128,
            BarcodeFormat.code39,
            BarcodeFormat.code93,
            BarcodeFormat.codabar,
            BarcodeFormat.ean13,
            BarcodeFormat.ean8,
            BarcodeFormat.itf,
            BarcodeFormat.upcA,
            BarcodeFormat.upcE,
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


