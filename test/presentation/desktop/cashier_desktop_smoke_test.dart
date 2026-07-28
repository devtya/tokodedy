import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/presentation/blocs/cashier/cashier_state.dart';
import 'package:tokodedy/presentation/pages/desktop/widgets/cart_panel.dart';

void main() {
  testWidgets('CartPanel shows total and disables pay when empty',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CartPanel(
          data: const CashierReady(),
          onPay: () {},
          onRemove: (_) {},
          onEditQty: (_, __) {},
        ),
      ),
    ));
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Belum ada barang'), findsOneWidget);
    final payBtn = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(payBtn.onPressed, isNull);
  });
}
