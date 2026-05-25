import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/toko_service.dart';
import '../../../core/services/update_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/sync/sync_bloc.dart';
import 'login_page.dart';
import 'pengaturan_toko_page.dart';
import 'printer_settings_page.dart';
import 'user_management_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _updateService = sl<UpdateService>();
  String _appVersion = '';
  bool _checkingUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _appVersion = info.version);
    } catch (_) {}
  }

  Future<void> _checkUpdate() async {
    setState(() => _checkingUpdate = true);
    try {
      final update = await _updateService.checkForUpdate();
      if (!mounted) return;
      setState(() => _checkingUpdate = false);

      if (update == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aplikasi sudah versi terbaru')),
        );
        return;
      }

      final install = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Update Tersedia'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Versi baru: ${update.version}'),
                  if (update.notes != null && update.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text('Catatan rilis:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(update.notes!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Nanti')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Update')),
          ],
        ),
      );

      if (install == true) {
        final progressController = StreamController<double>();

        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Mengunduh Pembaruan'),
              content: StreamBuilder<double>(
                stream: progressController.stream,
                initialData: 0.0,
                builder: (context, snapshot) {
                  final pct = ((snapshot.data ?? 0.0) * 100).toInt();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        value: snapshot.data,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$pct% selesai',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Harap jangan tutup aplikasi selama proses unduh berlangsung.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        try {
          final path = await _updateService.downloadApk(
            update.url,
            assetName: update.assetName,
            onProgress: (progress) {
              progressController.add(progress);
            },
          );

          progressController.close();
          if (mounted) {
            Navigator.pop(context); // Tutup dialog progress
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download selesai, membuka installer...')),
            );
          }
          await _updateService.installApk(path);
        } catch (err) {
          progressController.close();
          if (mounted) {
            Navigator.pop(context); // Tutup dialog progress
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal mengunduh pembaruan: $err')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _checkingUpdate = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memeriksa update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokoService = sl<TokoService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Toko Info ---
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PengaturanTokoPage()),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.store, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tokoService.tokoName ?? 'Toko Saya',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                      ],
                    ),
                    if (tokoService.tokoId != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'ID Toko: ${tokoService.tokoId}',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Theme ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tema Aplikasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _themeLabel(themeMode),
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.system,
                                label: Text('System'),
                                icon: Icon(Icons.settings_brightness),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: Text('Terang'),
                                icon: Icon(Icons.light_mode),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: Text('Gelap'),
                                icon: Icon(Icons.dark_mode),
                              ),
                            ],
                            selected: {themeMode},
                            onSelectionChanged: (modes) {
                              context.read<ThemeCubit>().setTheme(modes.first);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Printer & User Management ---
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.print, color: AppTheme.primaryGreen),
                    title: const Text('Pengaturan Printer'),
                    subtitle: const Text('Printer thermal USB/Bluetooth'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrinterSettingsPage()),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.people, color: AppTheme.primaryGreen),
                    title: const Text('Manajemen Pengguna'),
                    subtitle: const Text('Kelola admin dan kasir'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserManagementPage()),
                    ),
                  ),
                  const Divider(height: 1),
                  BlocConsumer<SyncBloc, SyncState>(
                    listener: (context, state) {
                      if (state is SyncSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sinkronisasi data ke cloud BERHASIL!'),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                        );
                      } else if (state is SyncError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sinkronisasi GAGAL: ${state.message}'),
                            backgroundColor: AppTheme.warningRed,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isSyncing = state is SyncInProgress;
                      return ListTile(
                        leading: isSyncing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryGreen,
                                ),
                              )
                            : const Icon(Icons.cloud_sync, color: AppTheme.primaryGreen),
                        title: const Text('Sinkronisasi Cloud'),
                        subtitle: Text(
                          isSyncing
                              ? 'Sedang menyelaraskan data dengan cloud...'
                              : 'Kirim data lokal & unduh data dari cloud',
                        ),
                        trailing: isSyncing
                            ? const SizedBox.shrink()
                            : const Icon(Icons.sync),
                        onTap: isSyncing
                            ? null
                            : () {
                                context.read<SyncBloc>().add(const SyncTriggered());
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Info Aplikasi & Logout ---
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _appVersion.isNotEmpty ? 'Versi $_appVersion' : 'Memuat versi...',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.system_update,
                      color: _checkingUpdate ? Colors.grey : AppTheme.primaryGreen,
                    ),
                    title: Text(_checkingUpdate ? 'Memeriksa...' : 'Periksa Pembaruan'),
                    trailing: _checkingUpdate
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: _checkingUpdate ? null : _checkUpdate,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppTheme.warningRed),
                    title: const Text('Logout',
                        style: TextStyle(color: AppTheme.warningRed)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Apakah Anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.read<AuthBloc>().add(LogoutEvent());
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                  (route) => false,
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.warningRed,
                              ),
                              child: const Text('Logout'),
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
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Mengikuti tema sistem';
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
    }
  }
}
