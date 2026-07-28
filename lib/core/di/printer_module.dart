import 'dart:io' show Platform;
import '../../data/services/bluetooth_printer_service.dart';
import '../../data/services/printing/receipt_printer.dart';
import '../../data/services/printing/windows_printer_service.dart';
import 'injection.dart';

void registerReceiptPrinter() {
  if (sl.isRegistered<ReceiptPrinter>()) return;
  sl.registerLazySingleton<ReceiptPrinter>(
    () => Platform.isWindows
        ? sl<WindowsPrinterService>()
        : sl<BluetoothPrinterService>(),
  );
}
