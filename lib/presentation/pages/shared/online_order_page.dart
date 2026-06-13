import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../blocs/online_order/online_order_bloc.dart';
import '../../../domain/entities/online_order.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/barcode_scanner_widget.dart';
import '../../../data/models/receipt_data.dart';
import '../../../data/services/printer_service.dart';
import '../../../data/services/printer_settings.dart';
import '../../../core/di/injection.dart';

class OnlineOrderPage extends StatefulWidget {
  const OnlineOrderPage({super.key});

  @override
  State<OnlineOrderPage> createState() => _OnlineOrderPageState();
}

class _OnlineOrderPageState extends State<OnlineOrderPage> {
  @override
  void initState() {
    super.initState();
    // Load data setiap kali halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OnlineOrderBloc>().add(LoadPendingOnlineOrders());
      }
    });
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<OnlineOrderBloc>().add(RefreshOnlineOrders(completer));
    return completer.future;
  }

  Future<void> _scanOrderQr(BuildContext context) async {
    final scannedCode = await showBarcodeScannerDialog(context, isOnlineOrder: true);
    if (scannedCode == null || !mounted || !context.mounted) return;

    final state = context.read<OnlineOrderBloc>().state;
    if (state is OnlineOrderLoaded) {
      final match = state.orders.firstWhere(
        (o) => o.id.toLowerCase() == scannedCode.toLowerCase(),
        orElse: () => state.historyOrders.firstWhere(
          (o) => o.id.toLowerCase() == scannedCode.toLowerCase(),
          orElse: () => OnlineOrder(
            id: '',
            customerId: '',
            namaCustomer: '',
            status: '',
            totalHarga: 0,
            metodePengiriman: '',
            createdAt: DateTime.now(),
          ),
        ),
      );

      if (match.id.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan tidak ditemukan di database lokal!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!context.mounted) return;
      if (match.status == 'shipped') {
        showConfirmSelesaikanDialog(context, match);
      } else {
        showOrderInfoDialog(context, match);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Online'),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'Scan QR Pengambilan',
              onPressed: () => _scanOrderQr(context),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: _onRefresh,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pesanan Baru'),
              Tab(text: 'Diproses'),
              Tab(text: 'Siap'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: BlocBuilder<OnlineOrderBloc, OnlineOrderState>(
          builder: (context, state) {
            if (state is OnlineOrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnlineOrderLoaded) {
              final pendingOrders = state.orders.where((o) => o.status == 'pending').toList();
              final processingOrders = state.orders.where((o) => o.status == 'processing').toList();
              final readyOrders = state.orders.where((o) => o.status == 'shipped').toList();

              return TabBarView(
                children: [
                  _OrderListView(orders: pendingOrders, emptyMessage: 'Tidak ada pesanan baru', onRefresh: _onRefresh),
                  _OrderListView(orders: processingOrders, emptyMessage: 'Tidak ada pesanan yang sedang diproses', onRefresh: _onRefresh),
                  _OrderListView(orders: readyOrders, emptyMessage: 'Tidak ada pesanan yang siap', onRefresh: _onRefresh),
                  _HistoryListView(orders: state.historyOrders, onRefresh: _onRefresh),
                ],
              );
            } else if (state is OnlineOrderError) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(state.message, textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<OnlineOrderBloc>().add(LoadPendingOnlineOrders());
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            // Initial / loading state — tampilkan RefreshIndicator agar bisa ditarik
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderListView extends StatelessWidget {
  final List<OnlineOrder> orders;
  final String emptyMessage;
  final Future<void> Function() onRefresh;

  const _OrderListView({
    required this.orders,
    required this.emptyMessage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Theme.of(context).disabledColor),
                    const SizedBox(height: 16),
                    Text(emptyMessage, style: TextStyle(color: Theme.of(context).disabledColor)),
                    const SizedBox(height: 8),
                    Text(
                      'Tarik ke bawah untuk refresh',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(order: order);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab Riwayat: pesanan completed / cancelled dalam 14 hari terakhir
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryListView extends StatelessWidget {
  final List<OnlineOrder> orders;
  final Future<void> Function() onRefresh;

  const _HistoryListView({required this.orders, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Theme.of(context).disabledColor),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada riwayat pesanan\n(14 hari terakhir)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tarik ke bawah untuk refresh',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          final isCompleted = order.status == 'completed';
          final statusColor = isCompleted ? Colors.green : Colors.red;
          final statusLabel = isCompleted ? '✅ Selesai' : '❌ Dibatalkan';

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: statusColor.withValues(alpha: 0.2)),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              leading: CircleAvatar(
                backgroundColor: statusColor.withValues(alpha: 0.1),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.cancel,
                  color: statusColor,
                  size: 20,
                ),
              ),
              title: Text(
                order.namaCustomer,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatCurrency.format(order.totalHarga),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              // Detail items (expand untuk lihat)
              children: [
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Detail Pesanan:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 8),
                if (order.items.isEmpty)
                  const Text(
                    'Detail item tidak tersedia.',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
                  )
                else
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          '${item.jumlah}× ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.isUnavailable ? Colors.grey : null,
                            decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.namaProduk,
                            style: TextStyle(
                              color: item.isUnavailable ? Colors.grey : null,
                              decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        Text(
                          formatCurrency.format(item.subtotal),
                          style: TextStyle(
                            fontSize: 13,
                            color: item.isUnavailable ? Colors.grey : null,
                            decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                  )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      formatCurrency.format(order.totalHarga),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (order.catatan != null && order.catatan!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            order.catatan!,
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OnlineOrder order;

  const _OrderCard({required this.order});


  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.namaCustomer,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(order.status).withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Info Row
            Row(
              children: [
                Icon(Icons.local_shipping, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  order.metodePengiriman.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12),
                ),
              ],
            ),
            if (order.alamatPengiriman != null && order.alamatPengiriman!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.alamatPengiriman!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
            if (order.catatan != null && order.catatan!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.catatan!,
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),

            // Items List
            const Text('Daftar Pesanan:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (order.items.isEmpty)
              const Text('Tidak ada detail item.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
            else
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  decoration: item.isUnavailable
                      ? BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                        )
                      : null,
                  padding: item.isUnavailable
                      ? const EdgeInsets.all(6)
                      : EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tombol tandai habis (hanya untuk order aktif)
                      if (order.status == 'pending' || order.status == 'processing')
                        InkWell(
                          onTap: () => context.read<OnlineOrderBloc>().add(
                                ToggleItemUnavailable(
                                  orderId: order.id,
                                  itemId: item.id,
                                  isUnavailable: !item.isUnavailable,
                                ),
                              ),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              item.isUnavailable
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              size: 18,
                              color: item.isUnavailable ? Colors.green : Colors.red.withValues(alpha: 0.6),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 4),
                      const SizedBox(width: 6),
                      Text(
                        '${item.jumlah}x ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item.isUnavailable ? Colors.grey : null,
                          decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.namaProduk,
                                    style: TextStyle(
                                      color: item.isUnavailable ? Colors.grey : null,
                                      decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                                if (item.isUnavailable)
                                  Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'HABIS',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              formatCurrency.format(item.hargaSatuan),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatCurrency.format(item.subtotal),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: item.isUnavailable ? Colors.grey : null,
                          decoration: item.isUnavailable ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),
              )),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),

            // Total — recalculate jika ada item habis
            Builder(builder: (context) {
              final itemHabis = order.items.where((i) => i.isUnavailable).toList();
              final totalDikurangi = itemHabis.fold(0.0, (s, i) => s + i.subtotal);
              final totalEfektif = order.totalHarga - totalDikurangi;
              return Column(
                children: [
                  if (itemHabis.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Pesanan', style: TextStyle(color: Colors.grey[600])),
                        Text(
                          formatCurrency.format(order.totalHarga),
                          style: TextStyle(color: Colors.grey[600], decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dikurangi (${itemHabis.length} barang habis)', style: const TextStyle(color: Colors.red, fontSize: 12)),
                        Text(
                          '-${formatCurrency.format(totalDikurangi)}',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bayar', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        formatCurrency.format(totalEfektif),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (order.status) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _confirmAction(context, 'Tolak Pesanan', 'cancelled'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Tolak'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _confirmProsesAction(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Proses & Cetak List'),
              ),
            ),
          ],
        );
      case 'processing':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _confirmSiapAction(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Siap & Cetak Nota'),
          ),
        );
      case 'shipped':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => showConfirmSelesaikanDialog(context, order),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Selesaikan & Kurangi Stok'),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _confirmAction(BuildContext context, String title, String newStatus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text('Apakah Anda yakin ingin mengubah status pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<OnlineOrderBloc>().add(ProcessOnlineOrder(order.id, newStatus));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Status pesanan berhasil diperbarui')),
              );
            },
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );
  }

  void _confirmProsesAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Proses Pesanan'),
        content: const Text('Pesanan akan diproses dan Daftar Pengambilan akan dicetak. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final settings = sl<PrinterSettings>();
              if (settings.enabled) {
                try {
                  final receiptItems = order.items.map((i) => ReceiptItem(
                    nama: i.namaProduk,
                    jumlah: i.jumlah,
                    harga: i.hargaSatuan,
                    satuan: 'Pcs', // Placeholder jika konversi satuan butuh
                    konversi: 1,
                  )).toList();

                  final receipt = ReceiptData(
                    namaToko: settings.namaToko,
                    alamatToko: settings.alamatToko,
                    transaksiId: order.id,
                    tanggal: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                    items: receiptItems,
                    subtotal: order.totalHarga,
                    totalBayar: order.totalHarga,
                    kembalian: 0,
                    lebarKertas: settings.lebarKertas,
                    fontSize: settings.fontSize,
                    kasir: 'Admin Online',
                    metodePembayaran: 'Online Order',
                  );
                  await sl<PrinterService>().printPickingList(receipt);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mencetak daftar pengambilan...')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal mencetak: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              }
              if (context.mounted) {
                context.read<OnlineOrderBloc>().add(ProcessOnlineOrder(order.id, 'processing'));
              }
            },
            child: const Text('Ya, Proses & Cetak'),
          ),
        ],
      ),
    );
  }

  void _confirmSiapAction(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final itemHabis = order.items.where((i) => i.isUnavailable).toList();
    final itemTersedia = order.items.where((i) => !i.isUnavailable).toList();
    final totalEfektif = itemTersedia.fold(0.0, (s, i) => s + i.subtotal);
    final isTotalChanged = order.totalHarga != totalEfektif;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tandai Siap & Cetak Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTotalChanged) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.warning, color: Colors.orange, size: 16), SizedBox(width: 4), Text('Perhatian', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))]),
                    const SizedBox(height: 4),
                    Text('Total belanja pelanggan berubah dari ${formatCurrency.format(order.totalHarga)} menjadi ${formatCurrency.format(totalEfektif)} karena ada ${itemHabis.length} barang kosong.'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            const Text('Pesanan ini akan ditandai Siap dan nota penjualannya akan dicetak. Lanjutkan?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final settings = sl<PrinterSettings>();
              if (settings.enabled) {
                try {
                  final receiptItems = itemTersedia.map((i) => ReceiptItem(
                    nama: i.namaProduk,
                    jumlah: i.jumlah,
                    harga: i.hargaSatuan,
                    satuan: 'Pcs',
                    konversi: 1,
                  )).toList();

                  final receipt = ReceiptData(
                    namaToko: settings.namaToko,
                    alamatToko: settings.alamatToko,
                    transaksiId: order.id,
                    tanggal: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                    items: receiptItems,
                    subtotal: totalEfektif,
                    totalBayar: totalEfektif,
                    kembalian: 0,
                    lebarKertas: settings.lebarKertas,
                    fontSize: settings.fontSize,
                    kasir: 'Admin Online',
                    metodePembayaran: 'Online Order',
                  );
                  await sl<PrinterService>().printReceipt(receipt);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mencetak nota penjualan...')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal mencetak: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              }
              if (context.mounted) {
                context.read<OnlineOrderBloc>().add(ProcessOnlineOrder(order.id, 'shipped', newTotal: totalEfektif));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen, foregroundColor: Colors.white),
            child: const Text('Ya, Cetak Nota'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return AppTheme.primaryGreen;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pesanan Baru';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Siap';
      default:
        return status.toUpperCase();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG HELPER FUNCTIONS FOR SCANNER & CARD ACTIONS
// ─────────────────────────────────────────────────────────────────────────────

void showConfirmSelesaikanDialog(BuildContext context, OnlineOrder order) {
  final itemHabis = order.items.where((i) => i.isUnavailable).toList();
  final itemTersedia = order.items.where((i) => !i.isUnavailable).toList();
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final totalEfektif = itemTersedia.fold(0.0, (s, i) => s + i.subtotal);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Selesaikan Pesanan'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pesanan ini akan diselesaikan:'),
          const SizedBox(height: 8),
          Text('✅ ${itemTersedia.length} item akan diproses dan stok dikurangi.'),
          if (itemHabis.isNotEmpty)
            Text('🚫 ${itemHabis.length} item ditandai HABIS (diabaikan).',
                style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          Text(
            'Total: ${formatCurrency.format(totalEfektif)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (itemTersedia.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '⚠️ Semua item ditandai habis. Batalkan pesanan ini daripada diselesaikan.',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: itemTersedia.isEmpty
              ? null
              : () {
                  Navigator.pop(ctx);
                  context.read<OnlineOrderBloc>().add(SelesaikanOnlineOrder(order.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesanan diselesaikan, stok dikurangi otomatis! ✅'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen, foregroundColor: Colors.white),
          child: const Text('Ya, Selesaikan'),
        ),
      ],
    ),
  );
}

void showOrderInfoDialog(BuildContext context, OnlineOrder order) {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final isCompleted = order.status == 'completed';
  final isCancelled = order.status == 'cancelled';
  
  String statusLabel = 'Diproses';
  Color statusColor = Colors.blue;
  if (order.status == 'pending') {
    statusLabel = 'Baru';
    statusColor = Colors.orange;
  } else if (isCompleted) {
    statusLabel = 'Selesai';
    statusColor = Colors.green;
  } else if (isCancelled) {
    statusLabel = 'Dibatalkan';
    statusColor = Colors.red;
  }

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.info_outline, color: statusColor),
          const SizedBox(width: 8),
          Expanded(child: Text(order.namaCustomer)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${order.id.substring(0, 8).toUpperCase()}'),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Status: '),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Total: ${formatCurrency.format(order.totalHarga)}'),
          const SizedBox(height: 8),
          Text('Jumlah Barang: ${order.items.length} item'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}
