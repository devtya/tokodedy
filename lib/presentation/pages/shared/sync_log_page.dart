import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/sync/sync_bloc.dart';

class SyncLogPage extends StatelessWidget {
  const SyncLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Sinkronisasi'),
        actions: [
          BlocBuilder<SyncBloc, SyncState>(
            builder: (context, state) {
              if (state is SyncInProgress) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.sync),
                tooltip: 'Sync sekarang',
                onPressed: () =>
                    context.read<SyncBloc>().add(const SyncTriggered()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SyncBloc, SyncState>(
        builder: (context, state) {
          final logs = state.logs;
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sync_disabled,
                      size: 64, color: AppTheme.neutralGrey),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat sinkronisasi',
                    style: TextStyle(color: AppTheme.neutralGrey),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () =>
                        context.read<SyncBloc>().add(const SyncTriggered()),
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync sekarang'),
                  ),
                ],
              ),
            );
          }

          // Show sync status banner
          Widget? statusBanner;
          if (state is SyncSuccess) {
            statusBanner = Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF2ECC71).withValues(alpha: 0.15),
              child: Row(
                children: [
                  const Icon(Icons.cloud_done, color: Color(0xFF2ECC71), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Sinkronisasi berhasil — ${_formatTime(state.lastSync)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          } else if (state is SyncError) {
            statusBanner = Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppTheme.warningRed.withValues(alpha: 0.15),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppTheme.warningRed, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.message,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SyncInProgress) {
            statusBanner = Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.amber.withValues(alpha: 0.15),
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Sinkronisasi berlangsung...',
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            );
          }

          return Column(
            children: [
              ?statusBanner,
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text('${logs.length} entri',
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.neutralGrey)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context
                            .read<SyncBloc>()
                            .add(const SyncTriggered());
                      },
                      child: const Text('Sync sekarang'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: logs.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 56),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _LogTile(log: log);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m yang lalu';
    if (diff.inHours < 24) return '${diff.inHours}h yang lalu';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _LogTile extends StatelessWidget {
  final SyncLogEntry log;
  const _LogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String label;

    switch (log.type) {
      case 'push_table':
        icon = Icons.arrow_upward;
        color = Colors.orange;
        label = 'Upload';
        break;
      case 'pull_table':
        icon = Icons.arrow_downward;
        color = Colors.blue;
        label = 'Download';
        break;
      case 'push_done':
        icon = Icons.cloud_done;
        color = const Color(0xFF2ECC71);
        label = 'Upload selesai';
        break;
      case 'pull_done':
        icon = Icons.cloud_done;
        color = const Color(0xFF2ECC71);
        label = 'Download selesai';
        break;
      case 'error':
        icon = Icons.error_outline;
        color = AppTheme.warningRed;
        label = 'Error';
        break;
      default:
        icon = Icons.info_outline;
        color = AppTheme.neutralGrey;
        label = log.type;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        log.tableName != null ? '$label — ${log.tableName}' : label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        log.message,
        style: TextStyle(fontSize: 12, color: AppTheme.neutralGrey),
      ),
      trailing: Text(
        '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 11, color: AppTheme.neutralGrey),
      ),
    );
  }
}
