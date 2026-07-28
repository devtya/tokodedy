import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double hitungKembalian(double bayar, double total) =>
    bayar >= total ? bayar - total : 0;

final _rp = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

Future<double?> showPaymentDialog(BuildContext context,
    {required double total}) {
  return showDialog<double>(
    context: context,
    builder: (ctx) {
      double bayar = 0;
      final ctrl = TextEditingController();
      void setBayar(StateSetter s, double v) {
        s(() {
          bayar = v;
          ctrl.text = v.toStringAsFixed(0);
          ctrl.selection =
              TextSelection.collapsed(offset: ctrl.text.length);
        });
      }

      return StatefulBuilder(
        builder: (ctx, setS) {
          final kembali = hitungKembalian(bayar, total);
          final cukup = bayar >= total;
          void confirm() {
            if (cukup) Navigator.pop(ctx, bayar);
          }

          return AlertDialog(
            title: const Text('Pembayaran'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text(_rp.format(total),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ctrl,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        prefixText: 'Rp ', labelText: 'Jumlah bayar'),
                    onChanged: (v) =>
                        setS(() => bayar = double.tryParse(v) ?? 0),
                    onSubmitted: (_) => confirm(),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => setBayar(setS, total),
                        child: const Text('Uang Pas'),
                      ),
                      for (final a in [20000.0, 50000.0, 100000.0])
                        OutlinedButton(
                          onPressed: () => setBayar(setS, a),
                          child: Text(_rp.format(a)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cukup ? 'Kembalian' : 'Kurang'),
                      Text(
                        _rp.format(cukup ? kembali : total - bayar),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: cukup
                              ? Theme.of(ctx).colorScheme.primary
                              : Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal (Esc)')),
              FilledButton(
                  onPressed: cukup ? confirm : null,
                  child: const Text('Bayar (Enter)')),
            ],
          );
        },
      );
    },
  );
}
