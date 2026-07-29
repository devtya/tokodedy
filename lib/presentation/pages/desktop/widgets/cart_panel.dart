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
                    separatorBuilder: (_, _) => const Divider(height: 1),
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
                            InkWell(
                              onTap: () async {
                                final v = await _askQty(context, item.jumlah);
                                if (v != null) onEditQty(i, v);
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                constraints:
                                    const BoxConstraints(minWidth: 32),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: cs.outlineVariant),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('${item.jumlah}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
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

/// Prompt for an exact quantity. Returns the typed value, or null if cancelled.
Future<int?> _askQty(BuildContext context, int current) {
  final ctrl = TextEditingController(text: '$current');
  ctrl.selection =
      TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
  int? parse() {
    final v = int.tryParse(ctrl.text.trim());
    return (v == null || v < 0) ? null : v;
  }

  return showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Jumlah'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Masukkan jumlah',
          helperText: '0 = hapus item',
        ),
        onSubmitted: (_) => Navigator.pop(ctx, parse()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, parse()),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
