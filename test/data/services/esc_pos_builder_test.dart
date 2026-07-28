import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/data/models/receipt_data.dart';
import 'package:tokodedy/data/services/printing/esc_pos_builder.dart';

bool _containsSeq(List<int> haystack, List<int> needle) {
  for (var i = 0; i + needle.length <= haystack.length; i++) {
    var ok = true;
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) { ok = false; break; }
    }
    if (ok) return true;
  }
  return false;
}

void main() {
  const builder = EscPosBuilder();
  final sample = ReceiptData(
    namaToko: 'Toko Dedy',
    transaksiId: 'TRX-1',
    tanggal: '01/01/2026 10:00',
    items: const [
      ReceiptItem(nama: 'Indomie - pcs', jumlah: 2, harga: 3000),
    ],
    subtotal: 6000,
    totalBayar: 6000,
    lebarKertas: 58,
  );

  test('drawerKick returns exactly the kick command', () {
    expect(const EscPosBuilder().drawerKick(), [0x1B, 0x70, 0x00, 0x19, 0xFA]);
  });

  test('buildReceipt starts with ESC @ init', () {
    final bytes = builder.buildReceipt(sample);
    expect(bytes.sublist(0, 2), [0x1B, 0x40]);
  });

  test('buildReceipt embeds the drawer kick so printing opens the drawer', () {
    final bytes = builder.buildReceipt(sample);
    expect(_containsSeq(bytes, [0x1B, 0x70, 0x00, 0x19, 0xFA]), isTrue);
  });
}
