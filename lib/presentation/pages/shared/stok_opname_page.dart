import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/usecases/stok/stok_opname.dart';
import '../../blocs/stok_opname/stok_opname_bloc.dart';
import '../../blocs/stok_opname/stok_opname_event.dart';
import '../../blocs/stok_opname/stok_opname_state.dart';

class StokOpnamePage extends StatelessWidget {
  const StokOpnamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StokOpnameBloc>()..add(LoadStokOpname()),
      child: const _StokOpnameView(),
    );
  }
}

class _StokOpnameView extends StatefulWidget {
  const _StokOpnameView();

  @override
  State<_StokOpnameView> createState() => _StokOpnameViewState();
}

class _StokOpnameViewState extends State<_StokOpnameView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showKonfirmasiDialog(BuildContext context, StokOpnameLoaded state) {
    final itemsToUpdate = state.items.where((i) => i.adaSelisih).toList();
    if (itemsToUpdate.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Stok Opname'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Akan dikoreksi ${itemsToUpdate.length} produk:'),
              const SizedBox(height: 12),
              for (final item in itemsToUpdate.take(10))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${item.namaProduk}: ${item.stokSistem} → ${item.stokFisik} (${item.selisih > 0 ? '+' : ''}${item.selisih})',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              if (itemsToUpdate.length > 10)
                Text(
                  '...dan ${itemsToUpdate.length - 10} lainnya.',
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: state.isSaving
                ? null
                : () {
                    Navigator.pop(ctx);
                    context.read<StokOpnameBloc>().add(SimpanStokOpname());
                  },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StokOpnameBloc, StokOpnameState>(
      listener: (context, state) {
        if (state is StokOpnameSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil mengoreksi ${state.totalKoreksi} produk.'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
          Navigator.pop(context);
        } else if (state is StokOpnameError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stok Opname'),
          actions: [
            BlocBuilder<StokOpnameBloc, StokOpnameState>(
              builder: (context, state) {
                if (state is StokOpnameLoaded) {
                  return IconButton(
                    icon: Icon(
                      state.hanyaSelisih ? Icons.filter_alt : Icons.filter_alt_outlined,
                      color: state.hanyaSelisih ? AppTheme.accentGreen : null,
                    ),
                    onPressed: () {
                      context.read<StokOpnameBloc>().add(FilterHanyaSelisih(!state.hanyaSelisih));
                    },
                    tooltip: 'Filter Hanya Selisih',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<StokOpnameBloc, StokOpnameState>(
          builder: (context, state) {
            if (state is StokOpnameLoading || state is StokOpnameInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StokOpnameLoaded) {
              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama produk...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<StokOpnameBloc>().add(const SearchStokOpname(''));
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (value) {
                        context.read<StokOpnameBloc>().add(SearchStokOpname(value));
                      },
                    ),
                  ),

                  // Summary Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: state.totalSelisih > 0
                        ? AppTheme.warning.withValues(alpha: 0.15)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Text(
                      '${state.items.length} produk diperiksa | ${state.totalSelisih} produk ada selisih',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: state.totalSelisih > 0
                            ? AppTheme.warning
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // List View
                  Expanded(
                    child: state.filteredItems.isEmpty
                        ? const Center(child: Text('Tidak ada produk.'))
                        : ListView.builder(
                            itemCount: state.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = state.filteredItems[index];
                              return _StokOpnameListItem(item: item);
                            },
                          ),
                  ),

                  // Bottom Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${state.totalSelisih} produk perlu koreksi',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: state.totalSelisih > 0 && !state.isSaving
                                ? () => _showKonfirmasiDialog(context, state)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: state.isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Simpan Opname'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StokOpnameListItem extends StatelessWidget {
  final StokOpnameItem item;

  const _StokOpnameListItem({required this.item});

  void _showInputFisikDialog(BuildContext context, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Input Stok Fisik: ${item.namaProduk}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Stok Fisik',
          ),
          onSubmitted: (value) {
            final val = int.tryParse(value) ?? currentValue;
            context.read<StokOpnameBloc>().add(UpdateStokFisik(item.produkId, val));
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? currentValue;
              context.read<StokOpnameBloc>().add(UpdateStokFisik(item.produkId, val));
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = item.selisih > 0;
    final isNegative = item.selisih < 0;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
        color: isPositive
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : (isNegative ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3) : null),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaProduk,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stok Sistem: ${item.stokSistem} ${item.satuan}',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
                ),
                if (item.adaSelisih)
                  Text(
                    'Selisih: ${isPositive ? '+' : ''}${item.selisih}',
                    style: TextStyle(
                      color: isPositive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Theme.of(context).colorScheme.error,
                onPressed: () {
                  if (item.stokFisik > 0) {
                    context.read<StokOpnameBloc>().add(UpdateStokFisik(item.produkId, item.stokFisik - 1));
                  }
                },
              ),
              GestureDetector(
                onTap: () => _showInputFisikDialog(context, item.stokFisik),
                child: Container(
                  width: 50,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Text(
                    '${item.stokFisik}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  context.read<StokOpnameBloc>().add(UpdateStokFisik(item.produkId, item.stokFisik + 1));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
