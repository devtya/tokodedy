import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/data/services/printing/windows_printer_service.dart';

void main() {
  test('rawBytesForDrawer is exactly the kick command', () {
    expect(WindowsPrinterService.rawBytesForDrawer(),
        [0x1B, 0x70, 0x00, 0x19, 0xFA]);
  });
}
