import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/toko_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/laporan/laporan_bloc.dart';
import '../../blocs/laporan/laporan_event.dart';
import '../../blocs/laporan/laporan_state.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage>
    with SingleTickerProviderStateMixin {
  final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final _dayFormat = DateFormat('EEEE, dd MMMM yyyy', 'id');

  late TabController _tabController;
  DateTime _filterStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _filterEnd = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<LaporanBloc>().add(LoadLaporan(
              tabIndex: _tabController.index,
              startDate: _filterStart,
              endDate: _filterEnd,
            ));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _filterStart, end: _filterEnd),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && mounted) {
      setState(() {
        _filterStart = picked.start;
        _filterEnd = picked.end;
      });
      context.read<LaporanBloc>().add(LoadLaporan(
            tabIndex: _tabController.index,
            startDate: _filterStart,
            endDate: _filterEnd,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(fontSize: 12),
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Laba Rugi'),
            Tab(text: 'Terlaris'),
            Tab(text: 'Hutang'),
            Tab(text: 'Arus Kas'),
            Tab(text: 'Stok'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
            tooltip: 'Filter Tanggal',
          ),
        ],
      ),
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
                    onPressed: () => context.read<LaporanBloc>().add(
                          LoadLaporan(tabIndex: _tabController.index),
                        ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<LaporanBloc>().add(
                  LoadLaporan(
                    tabIndex: _tabController.index,
                    startDate: _filterStart,
                    endDate: _filterEnd,
                  ),
                ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRingkasan(state),
                _buildLabaRugi(state),
                _buildTerlaris(state),
                _buildHutang(state),
                _buildArusKas(state),
                _buildStok(state),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── TAB 0: RINGKASAN ───

  Widget _buildRingkasan(LaporanState state) {
    if (state is! LaporanLoaded) {
      return _emptyState();
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dayFormat.format(DateTime.now()),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    'Transaksi #${t.id?.substring(0, 8)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _dateFormat.format(t.createdAt!),
                    style: TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
                  ),
                  trailing: Text(
                    _currency.format(t.totalHarga),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── TAB 1: LABA RUGI ───

  Widget _buildLabaRugi(LaporanState state) {
    if (state is! LaporanLabaRugiLoaded) {
      return _emptyState();
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_cart,
                label: 'Omzet',
                value: _currency.format(state.totalOmzet),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up,
                label: 'Laba Kotor',
                value: _currency.format(state.totalLabaKotor),
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.percent,
                label: 'Margin Rata-rata',
                value: state.totalOmzet > 0
                    ? '${(state.totalLabaKotor / state.totalOmzet * 100).toStringAsFixed(1)}%'
                    : '0%',
                color: AppTheme.warningOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.inventory_2,
                label: 'Total Produk',
                value: '${state.items.length}',
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (state.items.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Tidak ada data')),
          ))
        else
          ...state.items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.namaProduk,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              '${item.qtyTerjual} terjual',
                              style: TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_currency.format(item.labaKotor),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: item.labaKotor >= 0
                                      ? AppTheme.primaryGreen
                                      : AppTheme.warningRed)),
                          Text(
                            '${item.marginPersen.toStringAsFixed(1)}%',
                            style: TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  // ─── TAB 2: PRODUK TERLARIS ───

  Widget _buildTerlaris(LaporanState state) {
    if (state is! LaporanTerlarisLoaded) return _emptyState();
    final items = state.items;
    if (items.isEmpty) return _centerText('Belum ada data penjualan');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star,
                    label: 'Terlaris',
                    value: items.first.namaProduk.length > 15
                        ? '${items.first.namaProduk.substring(0, 15)}...'
                        : items.first.namaProduk,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.shopping_bag,
                    label: 'Total Terjual',
                    value: '${items.fold(0, (s, i) => s + i.qtyTerjual)}',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          );
        }
        final i = index - 1;
        final item = items[i];
        final medal = i == 0
            ? '🥇'
            : i == 1
                ? '🥈'
                : i == 2
                    ? '🥉'
                    : '${i + 1}.';
        return Card(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: i < 3 ? Colors.amber.withValues(alpha: 0.2) : null,
              child: Text(medal, style: const TextStyle(fontSize: 14)),
            ),
            title: Text(item.namaProduk,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${item.qtyTerjual} terjual'),
            trailing: Text(_currency.format(item.totalPenjualan),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  // ─── TAB 3: HUTANG ───

  Widget _buildHutang(LaporanState state) {
    if (state is! LaporanHutangLoaded) return _emptyState();
    final hutangList = state.hutangList;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.warning,
                label: 'Outstanding',
                value: _currency.format(state.totalOutstanding),
                color: AppTheme.warningRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle,
                label: 'Lunas',
                value: _currency.format(state.totalLunas),
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.people,
                label: 'Pelanggan Aktif',
                value: '${state.pelangganOutstanding}',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.receipt_long,
                label: 'Total Hutang',
                value: '${hutangList.length}',
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (hutangList.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Belum ada catatan hutang')),
          ))
        else
          ...hutangList.map((h) => Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: h.status == 'lunas'
                        ? AppTheme.lightGreen
                        : AppTheme.warningRed.withValues(alpha: 0.1),
                    child: Icon(
                      h.status == 'lunas'
                          ? Icons.check_circle
                          : Icons.pending,
                      color: h.status == 'lunas'
                          ? AppTheme.primaryGreen
                          : AppTheme.warningRed,
                      size: 20,
                    ),
                  ),
                  title: Text(h.namaPelanggan,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    h.status == 'lunas' ? 'Lunas' : 'Belum Lunas',
                    style: TextStyle(
                      fontSize: 12,
                      color: h.status == 'lunas'
                          ? AppTheme.primaryGreen
                          : AppTheme.warningRed,
                    ),
                  ),
                  trailing: Text(
                    _currency.format(h.jumlah),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: h.status == 'lunas'
                          ? AppTheme.neutralGrey
                          : AppTheme.warningRed,
                    ),
                  ),
                ),
              )),
      ],
    );
  }

  // ─── TAB 4: ARUS KAS ───

  Widget _buildArusKas(LaporanState state) {
    if (state is! LaporanArusKasLoaded) return _emptyState();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.arrow_upward,
                label: 'Pemasukan',
                value: _currency.format(state.totalPemasukan),
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.arrow_downward,
                label: 'Pengeluaran',
                value: _currency.format(state.totalPengeluaran),
                color: AppTheme.warningRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          color: state.saldoBersih >= 0
              ? AppTheme.lightGreen
              : AppTheme.warningRed.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state.saldoBersih >= 0
                      ? Icons.savings
                      : Icons.warning,
                  color: state.saldoBersih >= 0
                      ? AppTheme.primaryGreen
                      : AppTheme.warningRed,
                ),
                const SizedBox(width: 8),
                Text(
                  'Saldo Bersih: ${_currency.format(state.saldoBersih)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: state.saldoBersih >= 0
                        ? AppTheme.primaryGreen
                        : AppTheme.warningRed,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (state.items.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Belum ada data')),
          ))
        else
          ...state.items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dayFormat.format(item.tanggal),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '+${_currency.format(item.pemasukan)}',
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '-${_currency.format(item.pengeluaran)}',
                            style: const TextStyle(
                              color: AppTheme.warningRed,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  // ─── TAB 5: STOK MENIPIS ───

  Widget _buildStok(LaporanState state) {
    if (state is! LaporanStokLoaded) return _emptyState();
    final produkList = state.produkList;

    if (produkList.isEmpty) {
      return _centerText('Semua produk dalam stok cukup');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: produkList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _StatCard(
              icon: Icons.inventory,
              label: 'Produk Menipis',
              value: '${produkList.length} produk',
              color: AppTheme.warningRed,
            ),
          );
        }
        final p = produkList[index - 1];
        final minStok = p.stokMinimum ?? _getGlobalMinStok();
        return Card(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.warningRed.withValues(alpha: 0.1),
              child: Icon(Icons.warning, color: AppTheme.warningRed, size: 20),
            ),
            title: Text(p.nama, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              'Stok: ${p.stok} ${p.satuan ?? ''} (min: $minStok)',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              '${p.stok}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: p.stok <= 0 ? AppTheme.warningRed : AppTheme.warningOrange,
              ),
            ),
          ),
        );
      },
    );
  }

  int _getGlobalMinStok() {
    try {
      return sl<TokoService>().stokMinimumGlobal;
    } catch (_) {
      return 5;
    }
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: [
              Icon(Icons.touch_app, size: 48, color: AppTheme.neutralGrey.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'Pilih tab di atas untuk melihat laporan',
                style: TextStyle(color: AppTheme.neutralGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _centerText(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(text, style: TextStyle(color: AppTheme.neutralGrey)),
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
            Text(label,
                style: TextStyle(color: AppTheme.neutralGrey, fontSize: 12)),
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
