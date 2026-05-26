import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/item_pembelian.dart';
import '../../../domain/entities/pembelian.dart';
import '../../../core/di/injection.dart';
import '../../blocs/pembelian/pembelian_bloc.dart';
import '../../blocs/pembelian/pembelian_event.dart';
import '../../blocs/pembelian/pembelian_state.dart';
import '../../blocs/produk/produk_bloc.dart';
import 'pembelian_form_page.dart';
import 'pending_pembelian_page.dart';
import '../../../domain/repositories/pending_pembelian_repository.dart';
import '../../../data/models/receipt_data.dart';
import '../../../data/services/printer_service.dart';
import '../../../data/services/printer_settings.dart';

class PembelianPage extends StatefulWidget {
  const PembelianPage({super.key});

  @override
  State<PembelianPage> createState() => _PembelianPageState();
}

class _PembelianPageState extends State<PembelianPage> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<PembelianBloc>().add(LoadPembelian());
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final pendingRepo = sl<PendingPembelianRepository>();
    final pendingList = await pendingRepo.getAllPending();
    if (mounted) {
      setState(() => _pendingCount = pendingList.length);
    }
  }

  void _showDetailDialog(Pembelian p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FutureBuilder<List<ItemPembelian>>(
          future: context
              .read<PembelianBloc>()
              .repository
              .getItemsByPembelianId(p.id!),
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Detail Pembelian #${p.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supplier: ${p.namaSupplier}',
                    style: const TextStyle(color: AppTheme.primaryGreen),
                  ),
                  if (p.createdAt != null)
                    Text(
                      'Tanggal: ${_dateFormat.format(p.createdAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.neutralGrey,
                      ),
                    ),
                  const Divider(height: 24),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Tidak ada item.'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (ctx, idx) {
                          final item = items[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.namaProduk ??
                                          'Produk #${item.produkId}',
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
                          );
                        },
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembelian',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currency.format(p.totalHarga),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _openEditForm(p);
                              },
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Edit'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _sharePembelian(p, items),
                              icon: const Icon(Icons.share, size: 18),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _printPembelian(p, items),
                              icon: const Icon(Icons.print, size: 18),
                              label: const Text('Cetak'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Tutup'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _printPembelian(Pembelian p, List<ItemPembelian> items) async {
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
              final nama = item.namaProduk ?? 'Produk #${item.produkId}';
              final parts = nama.split(' - ');
              final unitName = parts.length > 1 ? parts.sublist(1).join(' - ') : null;
              return ReceiptItem(
                nama: nama,
                jumlah: item.jumlah,
                harga: item.hargaBeliSatuan,
                satuan: unitName,
                konversi: item.konversi,
              );
            },
          )
          .toList();
      final now = DateTime.now();
      final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(now);
      final receipt = ReceiptData(
        namaToko: settings.namaToko,
        alamatToko: settings.alamatToko,
        transaksiId: p.id!,
        tanggal: tanggal,
        items: receiptItems,
        subtotal: p.totalHarga,
        totalBayar: p.totalHarga,
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
              success ? 'Nota pembelian berhasil dicetak' : 'Gagal mencetak nota',
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

  Future<void> _sharePembelian(Pembelian p, List<ItemPembelian> items) async {
    final buffer = StringBuffer();
    buffer.writeln('📦 *PEMBELIAN BARANG*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('No: #${p.id}');
    buffer.writeln('Supplier: ${p.namaSupplier}');
    if (p.createdAt != null) {
      buffer.writeln('Tanggal: ${_dateFormat.format(p.createdAt!)}');
    }
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('');

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final nama = item.namaProduk ?? 'Produk #${item.produkId}';
      buffer.writeln('${i + 1}. $nama');
      buffer.writeln('   ${item.jumlah} x ${_currency.format(item.hargaBeliSatuan)} = ${_currency.format(item.subtotal)}');
    }

    buffer.writeln('');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('*TOTAL: ${_currency.format(p.totalHarga)}*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');

    await Share.share(buffer.toString());
  }

  void _openEditForm(Pembelian p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PembelianBloc>()),
            BlocProvider.value(value: sl<ProdukBloc>()),
          ],
          child: PembelianFormPage(existingPembelianId: p.id),
        ),
      ),
    ).then((_) {
      if (mounted) {
        context.read<PembelianBloc>().add(LoadPembelian());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembelian Barang'),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.pending_actions),
                if (_pendingCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.warningRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _pendingCount > 9 ? '9+' : '$_pendingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PendingPembelianPage()),
              ).then((_) {
                if (!context.mounted) return;
                context.read<PembelianBloc>().add(LoadPembelian());
                _loadPendingCount();
              });
            },
            tooltip: 'Pending Pembelian',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<PembelianBloc>()),
                      BlocProvider.value(value: sl<ProdukBloc>()),
                    ],
                    child: const PembelianFormPage(),
                  ),
                ),
              ).then((_) => _loadPendingCount());
            },
            tooltip: 'Tambah Pembelian',
          ),
        ],
      ),
      body: BlocBuilder<PembelianBloc, PembelianState>(
        builder: (context, state) {
          if (state is PembelianLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PembelianError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PembelianBloc>().add(LoadPembelian()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          if (state is PembelianLoaded) {
            if (state.list.isEmpty) {
              return const Center(child: Text('Belum ada pembelian'));
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<PembelianBloc>().add(LoadPembelian()),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  final p = state.list[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.lightGreen,
                        child: const Icon(
                          Icons.shopping_bag,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      title: Text(p.namaSupplier ?? 'Supplier Tidak Diketahui'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_currency.format(p.totalHarga)),
                          Text(
                            _dateFormat.format(p.createdAt!),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.neutralGrey,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDetailDialog(p),
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
