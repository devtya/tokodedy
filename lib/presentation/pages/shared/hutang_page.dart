import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/hutang/hutang_bloc.dart';
import '../../blocs/hutang/hutang_event.dart';
import '../../blocs/hutang/hutang_state.dart';
import '../../blocs/transaksi/transaksi_bloc.dart';
import 'hutang_form_page.dart';
import 'transaksi_detail_page.dart';

class HutangPage extends StatefulWidget {
  const HutangPage({super.key});

  @override
  State<HutangPage> createState() => _HutangPageState();
}

class _HutangPageState extends State<HutangPage> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    context.read<HutangBloc>().add(LoadHutang());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hutang Piutang')),
      body: BlocConsumer<HutangBloc, HutangState>(
        listener: (context, state) {
          if (state is HutangSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is HutangError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HutangLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HutangLoaded) {
            return Column(
              children: [
                _buildSummary(state),
                _buildFilter(state),
                Expanded(child: _buildList(state)),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HutangBloc>(),
                child: const HutangFormPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummary(HutangLoaded state) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Piutang',
                  style: TextStyle(color: AppTheme.neutralGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  _currency.format(state.totalPiutang),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.warningOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Belum Lunas',
                  style: TextStyle(fontSize: 11, color: AppTheme.warningOrange),
                ),
                Text(
                  _currency.format(state.totalBelumLunas),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warningOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(HutangLoaded state) {
    final filters = ['semua', 'belum_lunas', 'lunas'];
    final labels = ['Semua', 'Belum Lunas', 'Lunas'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(filters.length, (i) {
          final active = state.filterStatus == filters[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(labels[i]),
              selected: active,
              onSelected: (_) =>
                  context.read<HutangBloc>().add(FilterHutang(filters[i])),
              selectedColor: AppTheme.accentGreen.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.primaryGreen,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildList(HutangLoaded state) {
    final list = state.filteredList;
    if (list.isEmpty) {
      return const Center(child: Text('Tidak ada data hutang'));
    }
    return RefreshIndicator(
      onRefresh: () async => context.read<HutangBloc>().add(LoadHutang()),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final h = list[index];
          final isLunas = h.status == 'lunas';
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: h.transaksiId != null
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => sl<TransaksiBloc>(),
                            child: TransaksiDetailPage(
                              transaksiId: h.transaksiId!,
                            ),
                          ),
                        ),
                      )
                  : null,
              leading: CircleAvatar(
                backgroundColor: isLunas
                    ? AppTheme.lightGreen
                    : AppTheme.warningOrange.withValues(alpha: 0.15),
                child: Icon(
                  isLunas ? Icons.check_circle : Icons.pending,
                  color: isLunas
                      ? AppTheme.primaryGreen
                      : AppTheme.warningOrange,
                ),
              ),
              title: Text(
                h.namaPelanggan,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currency.format(h.jumlah)),
                  Row(
                    children: [
                      Text(
                        _dateFormat.format(h.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.neutralGrey,
                        ),
                      ),
                      if (h.tanggalJatuhTempo != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.warning_amber,
                          size: 12,
                          color: AppTheme.warningOrange,
                        ),
                        Text(
                          ' JT: ${_dateFormat.format(h.tanggalJatuhTempo!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.warningOrange,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              trailing: isLunas
                  ? Icon(Icons.check, color: AppTheme.primaryGreen)
                  : TextButton(
                      onPressed: () => _confirmLunas(h.id!),
                      child: const Text('Lunas'),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _confirmLunas(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tandai Lunas'),
        content: const Text('Konfirmasi hutang ini sudah dibayar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<HutangBloc>().add(LunasHutang(id));
            },
            child: const Text('Ya, Lunas'),
          ),
        ],
      ),
    );
  }
}
