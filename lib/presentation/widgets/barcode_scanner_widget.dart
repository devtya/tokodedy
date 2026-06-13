import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> showBarcodeScannerDialog(BuildContext context, {bool isOnlineOrder = false}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _buildCameraScanner(ctx, isOnlineOrder),
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


