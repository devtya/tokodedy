import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/local_auth/local_auth_bloc.dart';
import '../../blocs/local_auth/local_auth_event.dart';
import '../../blocs/local_auth/local_auth_state.dart';
import 'pin_setup_page.dart';
import 'pin_verify_page.dart';

class PinSettingsPage extends StatefulWidget {
  const PinSettingsPage({super.key});

  @override
  State<PinSettingsPage> createState() => _PinSettingsPageState();
}

class _PinSettingsPageState extends State<PinSettingsPage> {
  String? _userId;
  bool _hasPin = false;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userId = authState.user.id;
      context.read<LocalAuthBloc>().add(CheckPinEvent(_userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan PIN')),
      body: BlocConsumer<LocalAuthBloc, LocalAuthState>(
        listener: (context, state) {
          if (state is PinReady) {
            setState(() {
              _hasPin = true;
              _biometricAvailable = state.biometricAvailable;
              _biometricEnabled = state.biometricEnabled;
            });
          } else if (state is PinNotSet) {
            setState(() {
              _hasPin = false;
              _biometricAvailable = false;
              _biometricEnabled = false;
            });
          } else if (state is PinRemoved) {
            setState(() => _hasPin = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN berhasil dihapus')),
            );
          } else if (state is PinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LocalAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _hasPin ? Icons.lock : Icons.lock_open,
                            color: _hasPin ? AppTheme.primaryGreen : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _hasPin ? 'PIN Aktif' : 'PIN Belum Diset',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _hasPin
                            ? 'PIN digunakan untuk verifikasi saat login aplikasi'
                            : 'Atur PIN untuk keamanan tambahan saat login',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (!_hasPin)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.add, color: AppTheme.primaryGreen),
                    title: const Text('Set PIN'),
                    subtitle: const Text('Buat PIN 4-6 digit'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _userId == null ? null : () => _setPin(),
                  ),
                ),
              if (_hasPin) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.orange),
                          title: const Text('Ubah PIN'),
                          subtitle: const Text('Ganti PIN lama dengan yang baru'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _userId == null ? null : () => _changePin(),
                        ),
                        if (_biometricAvailable) ...[
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: const Icon(Icons.fingerprint, color: AppTheme.primaryGreen),
                            title: const Text('Sidik Jari'),
                            subtitle: const Text('Verifikasi pakai fingerprint'),
                            value: _biometricEnabled,
                            onChanged: (val) {
                              context.read<LocalAuthBloc>().add(
                                    ToggleBiometricEvent(_userId!, val),
                                  );
                              setState(() => _biometricEnabled = val);
                            },
                          ),
                        ],
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.delete_forever, color: AppTheme.warningRed),
                          title: const Text('Hapus PIN'),
                          subtitle: const Text('Nonaktifkan PIN login'),
                          onTap: _userId == null ? null : () => _removePin(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _setPin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LocalAuthBloc>(),
          child: PinSetupPage(userId: _userId!),
        ),
      ),
    );
    if (result == true) _load();
  }

  Future<void> _changePin() async {
    final verified = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LocalAuthBloc>(),
          child: PinVerifyPage(
            userId: _userId!,
            onVerified: () => Navigator.pop(context, true),
            onSkip: () => Navigator.pop(context, false),
          ),
        ),
      ),
    );
    if (verified == true && mounted) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<LocalAuthBloc>(),
            child: PinSetupPage(userId: _userId!),
          ),
        ),
      );
      if (result == true) _load();
    }
  }

  Future<void> _removePin() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus PIN'),
        content: const Text('Apakah Anda yakin ingin menghapus PIN keamanan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.warningRed),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      context.read<LocalAuthBloc>().add(RemovePinEvent(_userId!));
    }
  }
}
