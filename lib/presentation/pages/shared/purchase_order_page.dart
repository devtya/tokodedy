import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/receipt_data.dart';
import '../../../data/services/printer_service.dart';
import '../../../data/services/printer_settings.dart';
import '../../../domain/entities/purchase_order.dart';
import '../../../domain/entities/purchase_order_item.dart';
import '../../blocs/pembelian/pembelian_bloc.dart';
import '../../blocs/produk/produk_bloc.dart';
import '../../blocs/purchase_order/purchase_order_bloc.dart';
import '../../blocs/purchase_order/purchase_order_event.dart';
import '../../blocs/purchase_order/purchase_order_state.dart';
import 'purchase_order_form_page.dart';
import 'purchase_order_receive_page.dart';
import 'share_receipt_page.dart';

class PurchaseOrderPage extends StatefulWidget {
  const PurchaseOrderPage({super.key});

  @override
  State<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends State<PurchaseOrderPage> {
  final _currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    context.read<PurchaseOrderBloc>().add(LoadPurchaseOrders());
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'partial':
        return Colors.blue;
      case 'received':
        return AppTheme.primaryGreen;
      case 'cancelled':
        return AppTheme.warningRed;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open':
        return 'Dipesan';
      case 'partial':
        return 'Sebagian';
      case 'received':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  void _showDetailDialog(PurchaseOrder po) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FutureBuilder<List<PurchaseOrderItem>>(
          future: context
              .read<PurchaseOrderBloc>()
              .repository
              .getItemsByPoId(po.id!),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final items = snapshot.data ?? [];
            return Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxHeight: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Detail PO #${po.id!.substring(0, 8)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supplier: ${po.namaSupplier}',
                    style: const TextStyle(color: AppTheme.primaryGreen),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor(po.status).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _statusLabel(po.status),
                          style: TextStyle(
                            fontSize: 11,
                            color: _statusColor(po.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (po.createdAt != null)
                        Text(
                          _dateFormat.format(po.createdAt!),
                          style: const TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
                        ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Tidak ada item.'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (ctx, idx) {
                          final item = items[idx];
                          final sisa = item.qtyPesan - item.qtyTerima;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.namaProduk ?? 'Produk #${item.produkId}',
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        _currency.format(item.subtotal),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Pesan: ${item.qtyPesan}x ',
                                        style: const TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
                                      ),
                                      if (item.qtyTerima > 0)
                                        Text(
                                          'Terima: ${item.qtyTerima}x ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primaryGreen,
                                          ),
                                        ),
                                      if (sisa > 0)
                                        Text(
                                          'Sisa: ${sisa}x',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.warningRed,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pesanan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _currency.format(po.totalHarga),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (po.status == 'open' || po.status == 'partial')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openReceiveForm(po);
                        },
                        icon: const Icon(Icons.inventory_2, size: 18),
                        label: const Text('Terima Barang'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (po.status == 'open') ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _openEditForm(po, items);
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit PO'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _confirmCancel(po);
                            },
                            icon: const Icon(Icons.cancel, size: 18),
                            label: const Text('Batalkan PO'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.warningRed,
                              side: const BorderSide(color: AppTheme.warningRed),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _sharePO(po, items);
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _printPO(po, items);
                          },
                          icon: const Icon(Icons.print, size: 18),
                          label: const Text('Cetak'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openReceiveForm(PurchaseOrder po) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PurchaseOrderBloc>()),
            BlocProvider.value(value: sl<PembelianBloc>()),
            BlocProvider.value(value: sl<ProdukBloc>()),
          ],
          child: PurchaseOrderReceivePage(poId: po.id!),
        ),
      ),
    ).then((_) {
      if (mounted) {
        context.read<PurchaseOrderBloc>().add(LoadPurchaseOrders());
      }
    });
  }

  Future<void> _sharePO(PurchaseOrder po, List<PurchaseOrderItem> items) async {
    final receiptItems = items
        .map(
          (item) {
            final namaFull = item.namaProduk ?? 'Produk #${item.produkId}';
            final parts = namaFull.split(' - ');
            final unitName = parts.length > 1 ? parts.sublist(1).join(' - ') : null;
            return ReceiptItem(
              nama: parts[0],
              jumlah: item.qtyPesan,
              harga: item.hargaSatuan,
              satuan: unitName,
              konversi: item.konversi,
            );
          },
        )
        .toList();
    final now = po.createdAt ?? DateTime.now();
    final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(now);
    final settings = sl<PrinterSettings>();
    final receipt = ReceiptData(
      namaToko: po.namaSupplier ?? settings.namaToko,
      alamatToko: settings.alamatToko,
      transaksiId: po.id!,
      tanggal: tanggal,
      items: receiptItems,
      subtotal: po.totalHarga,
      totalBayar: po.totalHarga,
      metodePembayaran: '',
      lebarKertas: settings.lebarKertas,
      fontSize: settings.fontSize,
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShareReceiptPage(
            receipt: receipt,
            showCompactItems: true,
          ),
        ),
      );
    }
  }

  Future<void> _printPO(PurchaseOrder po, List<PurchaseOrderItem> items) async {
    final messenger = ScaffoldMessenger.of(context);
    final settings = sl<PrinterSettings>();
    if (!settings.enabled) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Printer tidak aktif. Aktifkan di Pengaturan Printer.'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
      return;
    }
    try {
      final receiptItems = items
          .map(
            (item) {
              final namaFull = item.namaProduk ?? 'Produk #${item.produkId}';
              final parts = namaFull.split(' - ');
              final unitName = parts.length > 1 ? parts.sublist(1).join(' - ') : null;
              return ReceiptItem(
                nama: parts[0],
                jumlah: item.qtyPesan,
                harga: item.hargaSatuan,
                satuan: unitName,
                konversi: item.konversi,
              );
            },
          )
          .toList();
      final now = DateTime.now();
      final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(now);
      final receipt = ReceiptData(
        namaToko: po.namaSupplier ?? settings.namaToko,
        alamatToko: settings.alamatToko,
        transaksiId: po.id!,
        tanggal: tanggal,
        items: receiptItems,
        subtotal: po.totalHarga,
        totalBayar: po.totalHarga,
        metodePembayaran: '',
        lebarKertas: settings.lebarKertas,
        fontSize: settings.fontSize,
      );
      final printer = sl<PrinterService>();
      final success = await printer.printReceipt(receipt);
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Nota PO berhasil dicetak' : 'Gagal mencetak nota',
            ),
            backgroundColor:
                success ? AppTheme.primaryGreen : AppTheme.warningRed,
          ),
        );
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
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PurchaseOrderBloc>()),
            BlocProvider.value(value: sl<ProdukBloc>()),
          ],
          child: const PurchaseOrderFormPage(),
        ),
      ),
    ).then((_) {
      if (mounted) {
        context.read<PurchaseOrderBloc>().add(LoadPurchaseOrders());
      }
    });
  }

  void _openEditForm(PurchaseOrder po, List<PurchaseOrderItem> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PurchaseOrderBloc>()),
            BlocProvider.value(value: sl<ProdukBloc>()),
          ],
          child: PurchaseOrderFormPage(initialPo: po, initialItems: items),
        ),
      ),
    ).then((_) {
      if (mounted) {
        context.read<PurchaseOrderBloc>().add(LoadPurchaseOrders());
      }
    });
  }

  void _confirmCancel(PurchaseOrder po) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Purchase Order?'),
        content: Text('Apakah Anda yakin ingin membatalkan PO dari ${po.namaSupplier}? PO yang dibatalkan tidak dapat diubah kembali.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PurchaseOrderBloc>().add(CancelPurchaseOrderEvent(po.id!));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warningRed, foregroundColor: Colors.white),
            child: const Text('Ya, Batalkan PO'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openCreateForm,
            tooltip: 'Buat PO Baru',
          ),
        ],
      ),
      body: BlocBuilder<PurchaseOrderBloc, PurchaseOrderState>(
        builder: (context, state) {
          if (state is PurchaseOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PurchaseOrderError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PurchaseOrderBloc>().add(LoadPurchaseOrders()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          if (state is PurchaseOrdersLoaded) {
            if (state.list.isEmpty) {
              return const Center(child: Text('Belum ada Purchase Order'));
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<PurchaseOrderBloc>().add(LoadPurchaseOrders()),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  final po = state.list[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _statusColor(po.status).withValues(alpha: 0.2),
                        child: Icon(
                          Icons.receipt_long,
                          color: _statusColor(po.status),
                        ),
                      ),
                      title: Text(po.namaSupplier ?? 'Supplier Tidak Diketahui'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_currency.format(po.totalHarga)),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _statusColor(po.status).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  _statusLabel(po.status),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _statusColor(po.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _dateFormat.format(po.createdAt!),
                                style: const TextStyle(fontSize: 11, color: AppTheme.neutralGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDetailDialog(po),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
