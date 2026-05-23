import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/usecases/transaksi/buat_transaksi.dart';
import '../blocs/cashier/cashier_bloc.dart';
import '../blocs/cashier/cashier_event.dart';
import '../blocs/cashier/cashier_state.dart';

class CashierDesktopView extends StatelessWidget {
  final CashierState state;
  final CashierReady data;
  final TextEditingController bayarController;
  final bool isPrinting;
  final VoidCallback onOpenCariProduk;
  final VoidCallback onOpenScanner;
  final VoidCallback onOpenPendingDialog;
  final void Function(int index, CartItem item) onShowDiskonDialog;
  final void Function(int index, String namaProduk, int currentJumlah) onShowEditJumlahDialog;
  final VoidCallback onShowHutangDialog;
  final VoidCallback onSavePending;
  final void Function(CashierReady data) onShowBayarConfirmation;

  const CashierDesktopView({
    super.key,
    required this.state,
    required this.data,
    required this.bayarController,
    required this.isPrinting,
    required this.onOpenCariProduk,
    required this.onOpenScanner,
    required this.onOpenPendingDialog,
    required this.onShowDiskonDialog,
    required this.onShowEditJumlahDialog,
    required this.onShowHutangDialog,
    required this.onSavePending,
    required this.onShowBayarConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.f3): const _CashierIntent('F3'),
        LogicalKeySet(LogicalKeyboardKey.f5): const _CashierIntent('F5'),
        LogicalKeySet(LogicalKeyboardKey.f6): const _CashierIntent('F6'),
        LogicalKeySet(LogicalKeyboardKey.f7): const _CashierIntent('F7'),
        LogicalKeySet(LogicalKeyboardKey.end): const _CashierIntent('END'),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _CashierIntent: CallbackAction<_CashierIntent>(
            onInvoke: (_CashierIntent intent) {
              switch (intent.keyId) {
                case 'F3':
                  onOpenCariProduk();
                  break;
                case 'F5':
                  onSavePending();
                  break;
                case 'F6':
                  onShowHutangDialog();
                  break;
                case 'F7':
                  onOpenPendingDialog();
                  break;
                case 'END':
                  onShowBayarConfirmation(data);
                  break;
              }
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
        // Top Section: Metadata & Grand Total
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, dd MMM yyyy HH:mm').format(DateTime.now()),
                      style: const TextStyle(fontSize: 16, color: AppTheme.neutralGrey),
                    ),
                    const SizedBox(height: 8),
                    // Add Customer Info or other metadata here later if needed
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: onOpenCariProduk,
                          icon: const Icon(Icons.search),
                          label: const Text('Cari Produk (F3)'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: onOpenScanner,
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Scan Barcode'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currency.format(data.totalSetelahDiskon),
                        style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Middle Section: Data Grid
        Expanded(
          child: Container(
            color: AppTheme.background,
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 40, child: Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 3, child: Text('Nama Item', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 1, child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                        Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                        Expanded(flex: 1, child: Text('Diskon', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                        Expanded(flex: 1, child: Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // List
                  Expanded(
                    child: data.cart.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Belum ada item', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: data.cart.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = data.cart[index];
                              return InkWell(
                                onDoubleTap: () => onShowEditJumlahDialog(index, item.namaProduk, item.jumlah),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 40, child: Text('${index + 1}')),
                                      Expanded(
                                        flex: 3,
                                        child: Text(item.namaProduk, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(currency.format(item.hargaJual), textAlign: TextAlign.right),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline, size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => context.read<CashierBloc>().add(UpdateJumlahCart(index, item.jumlah - 1)),
                                            ),
                                            const SizedBox(width: 8),
                                            Text('${item.jumlah}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline, size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => context.read<CashierBloc>().add(UpdateJumlahCart(index, item.jumlah + 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () => onShowDiskonDialog(index, item),
                                          child: Text(
                                            item.diskonTipe == 0
                                                ? '-'
                                                : item.diskonTipe == 1
                                                    ? '${item.diskonValue}%'
                                                    : currency.format(item.diskonValue),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: item.diskonTipe != 0 ? AppTheme.warningRed : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          currency.format(item.subtotal),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.warningRed),
                                          onPressed: () => context.read<CashierBloc>().add(RemoveFromCart(index)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Section: Summary & Actions
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left: Actions
              Expanded(
                flex: 1,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: data.cart.isEmpty ? null : onSavePending,
                      icon: const Icon(Icons.pause_circle_outline),
                      label: const Text('Pending (F5)'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onOpenPendingDialog,
                      icon: const Icon(Icons.pending_actions),
                      label: const Text('Buka Pending (F6)'),
                    ),
                    OutlinedButton.icon(
                      onPressed: data.cart.isEmpty ? null : onShowHutangDialog,
                      icon: const Icon(Icons.book),
                      label: const Text('Hutang (F7)'),
                    ),
                  ],
                ),
              ),
              // Right: Summary & Payment
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(fontSize: 14)),
                        Text(currency.format(data.total), style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    if (data.totalDiskon > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Diskon Item', style: TextStyle(fontSize: 14, color: AppTheme.warningRed)),
                          Text('-${currency.format(data.totalDiskon)}', style: const TextStyle(fontSize: 14, color: AppTheme.warningRed)),
                        ],
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Akhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          currency.format(data.totalSetelahDiskon),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Bayar:', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: bayarController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              prefixText: 'Rp ',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onChanged: (value) {
                              final amount = double.tryParse(value) ?? 0;
                              context.read<CashierBloc>().add(UpdateJumlahBayar(amount));
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            final amount = data.totalSetelahDiskon;
                            bayarController.text = amount.toStringAsFixed(0);
                            context.read<CashierBloc>().add(UpdateJumlahBayar(amount));
                          },
                          child: const Text('Uang Pas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.jumlahBayar < data.totalSetelahDiskon ? 'Kurang:' : 'Kembali:',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          currency.format(
                            data.jumlahBayar < data.totalSetelahDiskon
                                ? data.totalSetelahDiskon - data.jumlahBayar
                                : data.kembalian,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: data.jumlahBayar < data.totalSetelahDiskon ? AppTheme.warningRed : AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: data.cart.isEmpty
                            ? null
                            : () {
                                if (data.jumlahBayar <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Masukkan nominal bayar terlebih dahulu'), backgroundColor: AppTheme.warningRed),
                                  );
                                  return;
                                }
                                if (data.jumlahBayar < data.totalSetelahDiskon) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Jumlah bayar kurang dari total'), backgroundColor: AppTheme.warningRed),
                                  );
                                  return;
                                }
                                onShowBayarConfirmation(data);
                              },
                        icon: isPrinting
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.payments),
                        label: Text(isPrinting ? 'Printing...' : 'BAYAR (END)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    ),
    ),
    );
  }
}

class _CashierIntent extends Intent {
  final String keyId;
  const _CashierIntent(this.keyId);
}
