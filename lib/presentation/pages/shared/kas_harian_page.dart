import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';

import '../../blocs/kas_harian/kas_harian_bloc.dart';
import '../../blocs/kas_harian/kas_harian_event.dart';
import '../../blocs/kas_harian/kas_harian_state.dart';

class KasHarianPage extends StatelessWidget {
  const KasHarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KasHarianBloc>()..add(LoadKasHarian(DateTime.now())),
      child: const _KasHarianView(),
    );
  }
}

final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

class _KasHarianView extends StatelessWidget {
  const _KasHarianView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kas Harian'),
        actions: [
          BlocBuilder<KasHarianBloc, KasHarianState>(
            builder: (context, state) {
              DateTime selectedDate = DateTime.now();
              if (state is KasHarianLoaded) {
                selectedDate = state.selectedDate;
              }
              return IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null && context.mounted) {
                    context.read<KasHarianBloc>().add(ChangeDateEvent(date));
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<KasHarianBloc, KasHarianState>(
        builder: (context, state) {
          if (state is KasHarianLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KasHarianError) {
            return Center(child: Text(state.message));
          } else if (state is KasHarianLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<KasHarianBloc>().add(LoadKasHarian(state.selectedDate));
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Text(
                      DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(state.selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildModalAwalCard(context, state),
                  const SizedBox(height: 16),
                  _buildSummaryGrid(context, state),
                  const SizedBox(height: 24),
                  _buildPengeluaranHeader(context),
                  const SizedBox(height: 8),
                  _buildPengeluaranList(context, state),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildModalAwalCard(BuildContext context, KasHarianLoaded state) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modal Kas Awal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currency.format(state.summary.modalAwal),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => _showSetModalAwalDialog(context, state.summary.modalAwal),
              icon: const Icon(Icons.edit, size: 18),
              label: Text(state.summary.modalAwal > 0 ? 'Edit' : 'Set Modal'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context, KasHarianLoaded state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildMetricCard(context, 'Omzet', state.summary.totalOmzet, AppTheme.primaryGreen),
        _buildMetricCard(context, 'Pembelian', state.summary.totalPembelian, AppTheme.error),
        _buildMetricCard(context, 'Pengeluaran', state.summary.totalPengeluaran, AppTheme.warningOrange),
        _buildMetricCard(
          context, 
          'Saldo Akhir', 
          state.summary.saldoAkhir, 
          state.summary.saldoAkhir >= 0 ? AppTheme.primaryGreen : AppTheme.error,
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, double amount, Color color, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currency.format(amount),
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPengeluaranHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Pengeluaran Operasional',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FilledButton.icon(
          onPressed: () => _showAddPengeluaranDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Tambah'),
          style: FilledButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
        )
      ],
    );
  }

  Widget _buildPengeluaranList(BuildContext context, KasHarianLoaded state) {
    if (state.summary.pengeluaranList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Belum ada pengeluaran hari ini',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.summary.pengeluaranList.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final p = state.summary.pengeluaranList[index];
        return Dismissible(
          key: Key(p.id ?? p.createdAt?.toIso8601String() ?? index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: AppTheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) => _confirmDelete(context),
          onDismissed: (_) {
            context.read<KasHarianBloc>().add(DeletePengeluaranEvent(p.id!));
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.receipt_long, size: 20),
            ),
            title: Text(p.kategori, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: p.keterangan != null && p.keterangan!.isNotEmpty 
                ? Text(p.keterangan!) 
                : null,
            trailing: Text(
              _currency.format(p.jumlah),
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.error),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pengeluaran?'),
        content: const Text('Data yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  void _showSetModalAwalDialog(BuildContext context, double currentModal) {
    final bloc = context.read<KasHarianBloc>();
    final controller = TextEditingController(
      text: currentModal > 0 ? currentModal.toInt().toString() : '',
    );
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Modal Awal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Jumlah Modal (Rp)',
            prefixText: 'Rp ',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 0.0;
              if (val > 0) {
                bloc.add(SetModalAwalEvent(jumlah: val));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAddPengeluaranDialog(BuildContext context) {
    final bloc = context.read<KasHarianBloc>();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategory = 'Lain-lain';

    final categories = ['Listrik', 'Air', 'Plastik', 'Gaji', 'Transport', 'Lain-lain'];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Pengeluaran'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah (Rp)',
                        prefixText: 'Rp ',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      )).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan (Opsional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final val = double.tryParse(amountController.text) ?? 0.0;
                    if (val > 0) {
                      bloc.add(AddPengeluaranEvent(
                        jumlah: val,
                        kategori: selectedCategory,
                        keterangan: noteController.text,
                      ));
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
