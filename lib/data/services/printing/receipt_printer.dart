import '../../models/receipt_data.dart';

/// Platform-agnostic receipt printer. Implementations: Bluetooth (Android),
/// Windows USB spooler. Printing a receipt also opens the cash drawer because
/// the drawer kick is embedded in the receipt bytes; [openDrawer] fires the
/// kick alone (manual "Buka Laci").
abstract class ReceiptPrinter {
  Future<bool> isReady();
  Future<bool> printReceipt(ReceiptData data);
  Future<bool> openDrawer();
}
