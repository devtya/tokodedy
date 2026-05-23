import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/receipt_data.dart';
import '../../data/services/printer_service.dart';
import '../../data/services/printer_settings.dart';
import '../blocs/transaksi/transaksi_bloc.dart';
import '../blocs/transaksi/transaksi_event.dart';
import '../blocs/transaksi/transaksi_state.dart';
import 'share_receipt_page.dart';

class TransaksiDetailPage extends StatefulWidget {
  final String transaksiId;
  const TransaksiDetailPage({super.key, required this.transaksiId});

  @override
  State<TransaksiDetailPage> createState() => _TransaksiDetailPageState();
}

class _TransaksiDetailPageState extends State<TransaksiDetailPage> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(LoadTransaksiDetail(widget.transaksiId));
  }

  Future<void> _printReceipt() async {
    final state = context.read<TransaksiBloc>().state;
    if (state is! TransaksiDetailLoaded) return;

    final messenger = ScaffoldMessenger.of(context);
    final settings = sl<PrinterSettings>();
    if (!settings.enabled) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Printer tidak aktif. Aktifkan di Pengaturan Printer.'),
          backgroundColor: AppTheme.warningRed,
        ),
      );
      return;
    }

    setState(() => _isPrinting = true);

    try {
      final t = state.transaksi;
      final items = t.items ?? [];

      final receiptItems = items
          .map((item) => ReceiptItem(
                nama: item.namaProduk ?? 'Produk #${item.produkId}',
                jumlah: item.jumlah,
                harga: item.hargaSatuan,
              ))
          .toList();

      final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(t.createdAt ?? DateTime.now());
      final receipt = ReceiptData(
        namaToko: settings.namaToko,
        alamatToko: settings.alamatToko,
        transaksiId: t.id ?? widget.transaksiId,
        tanggal: tanggal,
        items: receiptItems,
        subtotal: t.totalHarga,
        totalBayar: t.jumlahBayar,
        kembalian: t.kembalian,
        lebarKertas: settings.lebarKertas,
        fontSize: settings.fontSize,
      );

      final printer = sl<PrinterService>();
      final success = await printer.printReceipt(receipt);

      if (mounted) {
        if (success) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Nota berhasil dicetak'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Gagal mencetak nota'),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error print: $e'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }

    if (mounted) setState(() => _isPrinting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi #${widget.transaksiId}'),
        actions: [
          IconButton(
            icon: _isPrinting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.print),
            tooltip: 'Cetak Nota',
            onPressed: _isPrinting ? null : _printReceipt,
          ),
          BlocBuilder<TransaksiBloc, TransaksiState>(
            builder: (context, state) {
              if (state is TransaksiDetailLoaded) {
                return IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Bagikan Nota',
                  onPressed: () {
                    final t = state.transaksi;
                    final items = t.items ?? [];
                    final settings = sl<PrinterSettings>();
                    final receiptItems = items
                        .map((item) => ReceiptItem(
                              nama: item.namaProduk ?? 'Produk #${item.produkId}',
                              jumlah: item.jumlah,
                              harga: item.hargaSatuan,
                            ))
                        .toList();
                    final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(t.createdAt ?? DateTime.now());
                    final receipt = ReceiptData(
                      namaToko: settings.namaToko,
                      alamatToko: settings.alamatToko,
                      transaksiId: t.id ?? widget.transaksiId,
                      tanggal: tanggal,
                      items: receiptItems,
                      subtotal: t.totalHarga,
                      totalBayar: t.jumlahBayar,
                      kembalian: t.kembalian,
                      lebarKertas: settings.lebarKertas,
                      fontSize: settings.fontSize,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShareReceiptPage(receipt: receipt),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<TransaksiBloc, TransaksiState>(
        builder: (context, state) {
          if (state is TransaksiLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransaksiDetailLoaded) {
            final t = state.transaksi;
            final items = t.items ?? [];
            final isHutang = t.status == 'hutang';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Status:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Chip(
                                label: Text(
                                  isHutang ? 'Hutang' : 'Lunas',
                                  style: TextStyle(
                                    color: isHutang
                                        ? AppTheme.warningOrange
                                        : AppTheme.primaryGreen,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: isHutang
                                    ? AppTheme.warningOrange.withValues(
                                        alpha: 0.15,
                                      )
                                    : AppTheme.lightGreen,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tanggal:'),
                              Text(_dateFormat.format(t.createdAt!)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Item',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ...items.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.namaProduk ?? 'Produk #${item.produkId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text('${item.jumlah}x '),
                            Text(
                              _currency.format(item.subtotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: AppTheme.lightGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _row('Total', _currency.format(t.totalHarga)),
                          const SizedBox(height: 4),
                          _row('Bayar', _currency.format(t.jumlahBayar)),
                          const SizedBox(height: 4),
                          _row('Kembali', _currency.format(t.kembalian)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is TransaksiError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
