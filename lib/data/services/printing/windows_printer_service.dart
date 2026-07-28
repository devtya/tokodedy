import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:printing/printing.dart';
import 'package:win32/win32.dart';

import '../../../core/di/injection.dart';
import '../../models/receipt_data.dart';
import '../printer_settings.dart';
import 'esc_pos_builder.dart';
import 'receipt_printer.dart';

@lazySingleton
class WindowsPrinterService implements ReceiptPrinter {
  static const _builder = EscPosBuilder();

  static List<int> rawBytesForDrawer() => const EscPosBuilder().drawerKick();

  /// Names of installed Windows printers (for the settings dropdown).
  static Future<List<String>> listPrinterNames() async {
    final printers = await Printing.listPrinters();
    return printers.map((p) => p.name).toList();
  }

  @override
  Future<bool> isReady() async {
    final name = sl<PrinterSettings>().windowsPrinterName;
    if (name.isEmpty) return false;
    final names = await listPrinterNames();
    return names.contains(name);
  }

  @override
  Future<bool> printReceipt(ReceiptData data) =>
      _sendRaw(_builder.buildReceipt(data));

  @override
  Future<bool> openDrawer() => _sendRaw(_builder.drawerKick());

  /// Sends raw bytes straight to the Windows print spooler as datatype RAW,
  /// which the thermal printer interprets as ESC/POS.
  Future<bool> _sendRaw(List<int> bytes) async {
    final printerName = sl<PrinterSettings>().windowsPrinterName;
    if (printerName.isEmpty) return false;

    final pName = printerName.toNativeUtf16();
    final phPrinter = calloc<HANDLE>();
    final docName = 'Receipt'.toNativeUtf16();
    final dataType = 'RAW'.toNativeUtf16();
    final docInfo = calloc<DOC_INFO_1>();
    final pBytes = calloc<Uint8>(bytes.length);
    final written = calloc<DWORD>();
    try {
      if (OpenPrinter(pName, phPrinter, nullptr) == 0) return false;
      final hPrinter = phPrinter.value;
      docInfo.ref
        ..pDocName = docName
        ..pOutputFile = nullptr
        ..pDatatype = dataType;
      if (StartDocPrinter(hPrinter, 1, docInfo.cast()) == 0) {
        ClosePrinter(hPrinter);
        return false;
      }
      StartPagePrinter(hPrinter);
      pBytes.asTypedList(bytes.length).setAll(0, bytes);
      final ok =
          WritePrinter(hPrinter, pBytes.cast(), bytes.length, written) != 0;
      EndPagePrinter(hPrinter);
      EndDocPrinter(hPrinter);
      ClosePrinter(hPrinter);
      return ok;
    } catch (_) {
      return false;
    } finally {
      calloc.free(pName);
      calloc.free(phPrinter);
      calloc.free(docName);
      calloc.free(dataType);
      calloc.free(docInfo);
      calloc.free(pBytes);
      calloc.free(written);
    }
  }
}
