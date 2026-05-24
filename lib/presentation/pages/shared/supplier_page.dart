import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/supplier.dart';
import '../../blocs/supplier/supplier_bloc.dart';
import '../../blocs/supplier/supplier_event.dart';
import '../../blocs/supplier/supplier_state.dart';
import 'supplier_form_page.dart';

class SupplierPage extends StatefulWidget {
  final bool isPicking;

  const SupplierPage({super.key, this.isPicking = false});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SupplierBloc>().add(LoadSupplier());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPicking ? 'Pilih Supplier' : 'Supplier'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Supplier',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<SupplierBloc>().add(LoadSupplier());
                } else {
                  context.read<SupplierBloc>().add(SearchSupplierEvent(value));
                }
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<SupplierBloc, SupplierState>(
              listener: (context, state) {
                if (state is SupplierOperationSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is SupplierError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppTheme.warningRed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is SupplierLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SupplierLoaded) {
                  final list = state.supplierList;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada supplier',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<SupplierBloc>().add(LoadSupplier());
                    },
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final supplier = list[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(
                              supplier.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              [
                                if (supplier.telepon != null) supplier.telepon,
                                if (supplier.alamat != null) supplier.alamat,
                              ].join(' • '),
                            ),
                            trailing: widget.isPicking
                                ? const Icon(Icons.chevron_right)
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: AppTheme.accentGreen,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<SupplierBloc>(),
                                                    child: SupplierFormPage(
                                                      supplier: supplier,
                                                    ),
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: AppTheme.warningRed,
                                        ),
                                        onPressed: () =>
                                            _confirmDelete(supplier),
                                      ),
                                    ],
                                  ),
                            onTap: widget.isPicking
                                ? () => Navigator.pop(context, supplier)
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Supplier>(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<SupplierBloc>(),
                child: const SupplierFormPage(),
              ),
            ),
          );
          if (widget.isPicking && result != null && context.mounted) {
            Navigator.pop(context, result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(Supplier supplier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Supplier'),
        content: Text('Yakin ingin menghapus "${supplier.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<SupplierBloc>().add(
                DeleteSupplierEvent(supplier.id!),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
