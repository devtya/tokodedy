import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/laporan/laporan_bloc.dart';
import '../../blocs/laporan/laporan_event.dart';
import '../../blocs/laporan/laporan_state.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final _todayFormat = DateFormat('EEEE, dd MMMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    context.read<LaporanBloc>().add(LoadLaporan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: BlocBuilder<LaporanBloc, LaporanState>(
        builder: (context, state) {
          if (state is LaporanLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LaporanError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<LaporanBloc>().add(LoadLaporan()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          if (state is LaporanLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<LaporanBloc>().add(LoadLaporan()),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todayFormat.format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.trending_up,
                            label: 'Omset Hari Ini',
                            value: _currency.format(state.omsetHariIni),
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.receipt_long,
                            label: 'Transaksi',
                            value: '${state.totalTransaksi}',
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Transaksi Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (state.transaksiHariIni.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: Text('Belum ada transaksi')),
                        ),
                      )
                    else
                      ...state.transaksiHariIni.map(
                        (t) => Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.lightGreen,
                              child: Icon(
                                t.status == 'lunas'
                                    ? Icons.check_circle
                                    : Icons.book,
                                color: t.status == 'lunas'
                                    ? AppTheme.primaryGreen
                                    : AppTheme.warningOrange,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              'Transaksi #${t.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              _dateFormat.format(t.createdAt!),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.neutralGrey,
                              ),
                            ),
                            trailing: Text(
                              _currency.format(t.totalHarga),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: AppTheme.neutralGrey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
