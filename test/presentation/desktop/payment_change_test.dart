import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/presentation/pages/desktop/widgets/payment_dialog.dart';

void main() {
  test('kembalian is bayar minus total when sufficient', () {
    expect(hitungKembalian(50000, 32000), 18000);
  });
  test('kembalian is 0 when short', () {
    expect(hitungKembalian(10000, 32000), 0);
  });
}
