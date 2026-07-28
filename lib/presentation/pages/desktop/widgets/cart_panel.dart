import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../blocs/cashier/cashier_state.dart';

class CartPanel extends StatelessWidget {
  final CashierReady data;
  final VoidCallback onPay;
  final void Function(int index) onRemove;
  final void Function(int index, int newQty) onEditQty;
  const CartPanel({
    super.key,
    required this.data,
    required this.onPay,
    required this.onRemove,
    required this.onEditQty,
  });

  static final _rp =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Keranjang',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          Expanded(
            child: data.cart.isEmpty
                ? Center(
                    child: Text('Belum ada barang',
                        style: TextStyle(color: cs.onSurfaceVariant)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: data.cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = data.cart[i];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        title: Text(item.namaProduk),
                        subtitle: Text(
                            '${_rp.format(item.hargaJual)} x ${item.jumlah}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () =>
                                  onEditQty(i, item.jumlah - 1),
                            ),
                            Text('${item.jumlah}'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () =>
                                  onEditQty(i, item.jumlah + 1),
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(_rp.format(item.subtotal),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ),
                            IconButton(
                              icon: Icon(Icons.close,
                                  size: 18, color: cs.error),
                              onPressed: () => onRemove(i),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text(
                      _rp.format(data.totalSetelahDiskon),
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: cs.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: data.cart.isEmpty ? null : onPay,
                    child: Text(
                        'F9 · BAYAR  (${_rp.format(data.totalSetelahDiskon)})',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
