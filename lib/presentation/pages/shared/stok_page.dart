import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/produk.dart';
import '../../blocs/stok/stok_bloc.dart';
import '../../blocs/stok/stok_event.dart';
import '../../blocs/stok/stok_state.dart';

class StokPage extends StatefulWidget {
  final Produk produk;
  const StokPage({super.key, required this.produk});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  @override
  void initState() {
    super.initState();
    context.read<StokBloc>().add(LoadRiwayatStok(widget.produk.id!));
  }

  void _showTambahStokDialog() {
    final jumlahController = TextEditingController();
    final keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Stok'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: jumlahController,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keteranganController,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                hintText: 'Opsional',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final jumlah = int.tryParse(jumlahController.text.trim());
              if (jumlah == null || jumlah <= 0) return;
              Navigator.pop(ctx);
              context.read<StokBloc>().add(
                TambahStokEvent(
                  produkId: widget.produk.id!,
                  jumlah: jumlah,
                  keterangan: keteranganController.text.trim().isEmpty
                      ? null
                      : keteranganController.text.trim(),
                ),
              );
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Stok: ${widget.produk.nama}')),
      body: BlocConsumer<StokBloc, StokState>(
        listener: (context, state) {
          if (state is StokOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is StokError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningRed,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Stok Saat Ini',
                      style: TextStyle(color: AppTheme.neutralGrey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.produk.stok} ${widget.produk.satuan ?? ''}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Harga Jual: ${currency.format(widget.produk.hargaJual)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Stok',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showTambahStokDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Stok'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state is StokLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is StokLoaded && state.riwayatList.isEmpty
                    ? const Center(child: Text('Belum ada riwayat stok'))
                    : state is StokLoaded
                    ? RefreshIndicator(
                        onRefresh: () async {
                          context.read<StokBloc>().add(
                            LoadRiwayatStok(widget.produk.id!),
                          );
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.riwayatList.length,
                          itemBuilder: (context, index) {
                            final riwayat = state.riwayatList[index];
                            final dateStr = DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(riwayat.createdAt!);
                            final isMasuk = riwayat.tipe == 'masuk';

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isMasuk
                                    ? AppTheme.lightGreen
                                    : AppTheme.warningRed.withValues(
                                        alpha: 0.15,
                                      ),
                                child: Icon(
                                  isMasuk
                                      ? Icons.add_circle_outline
                                      : Icons.remove_circle_outline,
                                  color: isMasuk
                                      ? AppTheme.primaryGreen
                                      : AppTheme.warningRed,
                                ),
                              ),
                              title: Text(
                                '${isMasuk ? '+' : '-'}${riwayat.jumlah}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isMasuk
                                      ? AppTheme.primaryGreen
                                      : AppTheme.warningRed,
                                ),
                              ),
                              subtitle: Text(riwayat.keterangan ?? dateStr),
                              trailing: Text(
                                dateStr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.neutralGrey,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }
}
