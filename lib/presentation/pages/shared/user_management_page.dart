import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import 'invite_kasir_page.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final AuthRepository _authRepo = sl<AuthRepository>();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _authRepo.getAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat pengguna: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showEditDialog(User user) {
    final namaCtrl = TextEditingController(text: user.nama ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(user.isOwner ? 'Edit Owner' : 'Edit Kasir'),
        content: TextField(
          controller: namaCtrl,
          decoration: const InputDecoration(
            labelText: 'Nama',
            prefixIcon: Icon(Icons.badge),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nama = namaCtrl.text.trim();
              if (nama.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Nama tidak boleh kosong')),
                );
                return;
              }

              try {
                await _authRepo.updateUser(user.copyWith(nama: nama));
                if (mounted) {
                  Navigator.pop(ctx);
                  _loadUsers();
                }
                if (mounted) {
                  context.read<AuthBloc>().add(CheckAuthStatus());
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Gagal: $e')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(User user) {
    if (user.isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun owner tidak dapat dihapus')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: Text(
            'Yakin ingin menghapus akun ${user.nama ?? user.email}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _authRepo.deleteUser(user.id!);
                _loadUsers();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.warningRed),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Pengguna')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.isOwner
                        ? AppTheme.primaryGreen
                        : AppTheme.neutralGrey,
                    child: Icon(
                      user.isOwner
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(user.nama ?? user.email ?? 'Kasir'),
                  subtitle: Text(user.role.toUpperCase() + (user.email != null ? ' • ${user.email}' : '')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(user),
                      ),
                      if (!user.isOwner)
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppTheme.warningRed,
                          ),
                          onPressed: () => _confirmDelete(user),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const InviteKasirPage()),
          );
          if (result == true) _loadUsers();
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
