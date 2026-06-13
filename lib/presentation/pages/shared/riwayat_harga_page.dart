import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/di/injection.dart';
import '../../../domain/repositories/produk_repository.dart';
import '../../blocs/riwayat_harga/riwayat_harga_bloc.dart';
import '../../blocs/riwayat_harga/riwayat_harga_event.dart';
import '../../blocs/riwayat_harga/riwayat_harga_state.dart';
import '../../blocs/produk/produk_bloc.dart';
import 'produk_form_page.dart';

class RiwayatHargaPage extends StatefulWidget {
  const RiwayatHargaPage({super.key});

  @override
  State<RiwayatHargaPage> createState() => _RiwayatHargaPageState();
}

class _RiwayatHargaPageState extends State<RiwayatHargaPage> {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    context.read<RiwayatHargaBloc>().add(const LoadRiwayatHarga());
  }

  void _onItemTapped(String produkId) async {
    final repo = sl<ProdukRepository>();
    final produk = await repo.getProdukById(produkId);
    
    if (produk == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk tidak ditemukan atau sudah dihapus')),
        );
      }
      return;
    }

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProdukBloc>(),
            child: ProdukFormPage(produk: produk),
          ),
        ),
      );
      
      // Reload history after returning
      if (mounted) {
        context.read<RiwayatHargaBloc>().add(const LoadRiwayatHarga());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Update Harga'),
      ),
      body: BlocBuilder<RiwayatHargaBloc, RiwayatHargaState>(
        builder: (context, state) {
          if (state is RiwayatHargaLoading || state is RiwayatHargaInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RiwayatHargaError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppTheme.warningRed),
              ),
            );
          } else if (state is RiwayatHargaLoaded) {
            if (state.riwayat.isEmpty) {
              return const Center(child: Text('Belum ada riwayat update harga'));
            }

            final isDark = Theme.of(context).brightness == Brightness.dark;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RiwayatHargaBloc>().add(const LoadRiwayatHarga());
              },
              child: ListView.separated(
                itemCount: state.riwayat.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: isDark ? 1 : 1.5,
                  color: isDark
                      ? Theme.of(context).colorScheme.surfaceContainerLow
                      : const Color(0xFFEEEEEE),
                ),
                itemBuilder: (context, index) {
                  final riwayat = state.riwayat[index];
                  final time = DateFormat('dd MMM yyyy HH:mm').format(riwayat.createdAt);

                  bool isNaik = riwayat.isHargaJualNaik ||
                      (!riwayat.isHargaJualTurun && riwayat.isHargaBeliNaik);
                  bool isTurun = riwayat.isHargaJualTurun ||
                      (!riwayat.isHargaJualNaik && riwayat.isHargaBeliTurun);

                  Color iconColor = Colors.blue;
                  IconData iconData = Icons.price_change;
                  if (isNaik) {
                    iconColor = AppTheme.error;
                    iconData = Icons.trending_up;
                  } else if (isTurun) {
                    iconColor = AppTheme.primaryGreen;
                    iconData = Icons.trending_down;
                  }

                  return InkWell(
                    onTap: () => _onItemTapped(riwayat.produkId),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(iconData, color: iconColor, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  riwayat.produkNama ?? 'Produk Dihapus',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency.format(riwayat.hargaJualBaru),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              if (riwayat.hargaJualLama != riwayat.hargaJualBaru)
                                Text(
                                  formatCurrency.format(riwayat.hargaJualLama),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
