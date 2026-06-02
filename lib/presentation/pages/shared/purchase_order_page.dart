import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/purchase_order.dart';
import '../../../domain/entities/purchase_order_item.dart';
import '../../blocs/pembelian/pembelian_bloc.dart';
import '../../blocs/produk/produk_bloc.dart';
import '../../blocs/purchase_order/purchase_order_bloc.dart';
import '../../blocs/purchase_order/purchase_order_event.dart';
import '../../blocs/purchase_order/purchase_order_state.dart';
import 'purchase_order_form_page.dart';
import 'purchase_order_receive_page.dart';

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
