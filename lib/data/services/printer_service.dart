import '../models/receipt_data.dart';

abstract class PrinterService {
  Future<bool> printReceipt(ReceiptData data);
  Future<bool> printPickingList(ReceiptData data);
  Future<bool> testPrint();
  Future<bool> isConnected();
  String get printerType;
}
