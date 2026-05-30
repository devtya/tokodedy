import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/backup/backup_bloc.dart';
import '../../blocs/backup/backup_event.dart';
import '../../blocs/backup/backup_state.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (context, state) {
          if (state is BackupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.primaryGreen,
                duration: const Duration(seconds: 5),
              ),
            );
            if (state.result != null) {
              final r = state.result!;
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Restore Selesai'),
                  content: Text(
                    'Berhasil: ${r.imported} produk\n'
                    'Dilewati: ${r.skipped} produk\n\n'
                    '${r.message}',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          } else if (state is BackupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is BackupLoading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.backup, size: 64, color: AppTheme.primaryGreen),
                const SizedBox(height: 16),
                Text(
                  'Backup & Restore Data',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ekspor data produk ke file Excel untuk cadangan,\n'
                  'atau impor file Excel untuk memulihkan data.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => context.read<BackupBloc>().add(BackupToExcel()),
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export ke Excel'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => _pickAndRestore(context),
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Import dari Excel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 24),
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memproses...'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickAndRestore(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result == null || result.files.single.path == null) return;

    if (!context.mounted) return;
    context.read<BackupBloc>().add(RestoreFromExcel(result.files.single.path!));
  }
}
