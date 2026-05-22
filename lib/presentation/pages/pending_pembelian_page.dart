import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/pending_pembelian.dart';
import '../../domain/repositories/pending_pembelian_repository.dart';
import '../blocs/pembelian/pembelian_bloc.dart';
import '../blocs/produk/produk_bloc.dart';
import 'pembelian_form_page.dart';

class PendingPembelianPage extends StatefulWidget {
  const PendingPembelianPage({super.key});

  @override
  State<PendingPembelianPage> createState() => _PendingPembelianPageState();
}

class _PendingPembelianPageState extends State<PendingPembelianPage> {
  final _repository = sl<PendingPembelianRepository>();
  List<PendingPembelian> _pendingList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final list = await _repository.getAllPending();
      if (mounted) {
        setState(() {
          _pendingList = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat pending: $e')),
        );
      }
    }
  }

  Future<void> _delete(String id) async {
    await _repository.deletePending(id);
    _loadData();
  }

  void _openPending(PendingPembelian pending) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<PembelianBloc>()),
            BlocProvider.value(value: sl<ProdukBloc>()),
          ],
          child: PembelianFormPage(pendingId: pending.id),
        ),
      ),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Pembelian')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingList.length,
              itemBuilder: (context, index) {
                final item = _pendingList[index];
                final dateStr = item.createdAt != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt!)
                    : '-';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppTheme.border),
                  ),
                  child: InkWell(
                    onTap: () => _openPending(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pause_circle_outline,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.namaSupplier ?? 'Tanpa Supplier',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    color: AppTheme.neutralGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppTheme.warningRed,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Pending'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus transaksi pending ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        _delete(item.id!);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppTheme.warningRed,
                                      ),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppTheme.neutralGrey),
          SizedBox(height: 16),
          Text(
            'Belum ada pembelian pending',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.neutralGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
