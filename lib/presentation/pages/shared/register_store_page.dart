import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import 'home_page.dart';

class RegisterStorePage extends StatefulWidget {
  const RegisterStorePage({super.key});

  @override
  State<RegisterStorePage> createState() => _RegisterStorePageState();
}

class _RegisterStorePageState extends State<RegisterStorePage> {
  final _tokoController = TextEditingController();
  final _alamatController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _tokoController.dispose();
    _alamatController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final namaToko = _tokoController.text.trim();
    final alamat = _alamatController.text.trim();
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (namaToko.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua field wajib')),
      );
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      RegisterStoreEvent(
        namaToko: namaToko,
        alamat: alamat.isEmpty ? null : alamat,
        email: email,
        password: password,
        nama: nama.isEmpty ? null : nama,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Toko Baru')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is StoreRegistered || state is Authenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningRed,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.store, size: 64, color: AppTheme.primaryGreen),
              const SizedBox(height: 16),
              const Text(
                'Daftarkan Toko Anda',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Isi data toko dan akun admin',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.neutralGrey),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _tokoController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko *',
                  prefixIcon: Icon(Icons.store),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat (opsional)',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const Text(
                'Akun Admin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama (opsional)',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Admin *',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password *',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _register,
                      child: const Text(
                        'DAFTAR TOKO',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
