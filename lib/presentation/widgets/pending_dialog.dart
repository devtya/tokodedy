import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/pending_order.dart';
import '../../domain/repositories/pending_order_repository.dart';

class PendingDialog extends StatefulWidget {
  final PendingOrderRepository repository;
  final void Function(String id) onLoadPending;

  const PendingDialog({
    super.key,
    required this.repository,
    required this.onLoadPending,
  });

  @override
  State<PendingDialog> createState() => _PendingDialogState();
}

class _PendingDialogState extends State<PendingDialog> {
  List<PendingOrder> _pendings = [];
  bool _loading = true;
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await widget.repository.getAllPending();
      setState(() {
        _pendings = list;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Order',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _pendings.isEmpty
                ? const Center(child: Text('Tidak ada pending order'))
                : ListView.builder(
                    itemCount: _pendings.length,
                    itemBuilder: (context, index) {
                      final p = _pendings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.warningOrange.withValues(
                              alpha: 0.15,
                            ),
                            child: const Icon(
                              Icons.pending_actions,
                              color: AppTheme.warningOrange,
                            ),
                          ),
                          title: Text(p.namaPelanggan),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p.catatan != null)
                                Text(
                                  p.catatan!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.neutralGrey,
                                  ),
                                ),
                              Text(
                                _dateFormat.format(p.createdAt!),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.neutralGrey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.download,
                                  color: AppTheme.primaryGreen,
                                ),
                                onPressed: () {
                                  widget.onLoadPending(p.id!);
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppTheme.warningRed,
                                ),
                                onPressed: () async {
                                  await widget.repository.deletePending(p.id!);
                                  _load();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ),
        ],
      ),
    );
  }
}
