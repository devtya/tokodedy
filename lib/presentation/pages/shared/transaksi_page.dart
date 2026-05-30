import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/transaksi/transaksi_bloc.dart';
import '../../blocs/transaksi/transaksi_event.dart';
import '../../blocs/transaksi/transaksi_state.dart';
import 'transaksi_detail_page.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(LoadTransaksi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: BlocBuilder<TransaksiBloc, TransaksiState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<TransaksiBloc>().add(LoadTransaksi()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
            loaded: (transaksiList) {
              if (transaksiList.isEmpty) {
                return const Center(child: Text('Belum ada transaksi'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TransaksiBloc>().add(LoadTransaksi());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final t = transaksiList[index];
                    final isHutang = t.status == 'hutang';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isHutang
                              ? AppTheme.warningOrange.withValues(alpha: 0.15)
                              : AppTheme.lightGreen,
                          child: Icon(
                            isHutang ? Icons.book : Icons.check_circle,
                            color: isHutang
                                ? AppTheme.warningOrange
                                : AppTheme.primaryGreen,
                          ),
                        ),
                        title: Text('Transaksi #${t.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currency.format(t.totalHarga)),
                            Text(
                              _dateFormat.format(t.createdAt!),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.neutralGrey,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => sl<TransaksiBloc>(),
                                child: TransaksiDetailPage(transaksiId: t.id!),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
