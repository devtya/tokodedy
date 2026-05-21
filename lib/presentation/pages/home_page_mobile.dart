import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import 'login_page.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/cashier/cashier_bloc.dart';
import '../blocs/hutang/hutang_bloc.dart';
import '../blocs/laporan/laporan_bloc.dart';
import '../blocs/notifikasi/notifikasi_bloc.dart';
import '../blocs/notifikasi/notifikasi_event.dart';
import '../blocs/notifikasi/notifikasi_state.dart';
import '../blocs/pembelian/pembelian_bloc.dart';
import '../blocs/produk/produk_bloc.dart';
import '../blocs/supplier/supplier_bloc.dart';
import '../blocs/transaksi/transaksi_bloc.dart';
import 'cashier_page.dart';
import 'hutang_page.dart';
import 'laporan_page.dart';
import 'notifikasi_page.dart';
import 'pembelian_page.dart';
import 'produk_page.dart';
import 'settings_page.dart';
import 'supplier_page.dart';
import 'transaksi_page.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotifikasiBloc>()..add(LoadNotifikasi()),
      child: const _HomeMobileView(),
    );
  }
}

class _HomeMobileView extends StatefulWidget {
  const _HomeMobileView();

  @override
  State<_HomeMobileView> createState() => _HomeMobileViewState();
}

class _HomeMobileViewState extends State<_HomeMobileView> {
  bool _emailPromptShown = false;

  void _reloadNotifikasi() {
    if (mounted) {
      context.read<NotifikasiBloc>().add(LoadNotifikasi());
    }
  }

  void _navigateAndReload(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) => _reloadNotifikasi());
  }

  void _showEmailDialog(BuildContext context, User user) {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Lengkapi Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anda login menggunakan username. Silakan isi email '
              'untuk keamanan akun dan fitur lupa password.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailCtrl.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Email tidak boleh kosong')),
                );
                return;
              }
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Format email tidak valid')),
                );
                return;
              }
              try {
                await sl<AuthRepository>().updateUser(
                  user.copyWith(email: email),
                );
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  context.read<AuthBloc>().add(CheckAuthStatus());
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Gagal menyimpan: $e')),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, current) => current is Unauthenticated,
      listener: (context, state) {
        _emailPromptShown = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
        String username = '';
        String role = 'kasir';
        if (authState is Authenticated) {
          username = authState.user.nama ?? authState.user.email ?? '';
          role = authState.user.role;
        } else if (authState is StoreRegistered) {
          username = authState.user.nama ?? authState.user.email ?? '';
          role = authState.user.role;
        }
        final isAdmin = role == 'owner';

        // Prompt email jika login via username (email null)
        final currentUser = authState is Authenticated
            ? authState.user
            : authState is StoreRegistered
                ? authState.user
                : null;
        if (currentUser != null &&
            currentUser.email == null &&
            !_emailPromptShown) {
          _emailPromptShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEmailDialog(context, currentUser);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Halo, $username! 👋'),
            centerTitle: false,
            actions: [
              BlocBuilder<NotifikasiBloc, NotifikasiState>(
                builder: (context, state) {
                  int unreadCount = 0;
                  if (state is NotifikasiLoaded) {
                    unreadCount = state.unreadNotifikasi.length;
                  }

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<NotifikasiBloc>(),
                                child: const NotifikasiPage(),
                              ),
                            ),
                          ).then((_) {
                            if (context.mounted) {
                              context.read<NotifikasiBloc>().add(
                                LoadNotifikasi(),
                              );
                            }
                          });
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppTheme.warningRed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: BlocBuilder<NotifikasiBloc, NotifikasiState>(
                  builder: (context, state) {
                    if (state is NotifikasiLoaded &&
                        state.unreadNotifikasi.isNotEmpty) {
                      final latestNotif = state.unreadNotifikasi.first;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Card(
                          color: AppTheme.warningOrange.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppTheme.warningOrange.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.campaign,
                              color: AppTheme.warningOrange,
                              size: 32,
                            ),
                            title: Text(
                              latestNotif.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.warningOrange,
                              ),
                            ),
                            subtitle: Text(
                              latestNotif.pesan,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<NotifikasiBloc>(),
                                    child: const NotifikasiPage(),
                                  ),
                                ),
                              ).then((_) {
                                if (context.mounted) {
                                  context.read<NotifikasiBloc>().add(
                                    LoadNotifikasi(),
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio:
                      1.1,
                  children: [
                    _MenuGridCard(
                      icon: Icons.shopping_cart,
                      label: 'Kasir',
                      color: AppTheme.primaryGreen,
                      onTap: () {
                        _navigateAndReload(
                          BlocProvider.value(
                            value: sl<CashierBloc>(),
                            child: const CashierPage(),
                          ),
                        );
                      },
                    ),
                    _MenuGridCard(
                      icon: Icons.inventory_2,
                      label: 'Produk',
                      color: AppTheme.darkGreen,
                      onTap: () {
                        _navigateAndReload(
                          BlocProvider.value(
                            value: sl<ProdukBloc>(),
                            child: const ProdukPage(),
                          ),
                        );
                      },
                    ),
                    _MenuGridCard(
                      icon: Icons.shopping_bag,
                      label: 'Pembelian',
                      color: Colors.teal,
                      onTap: () {
                        _navigateAndReload(
                          BlocProvider.value(
                            value: sl<PembelianBloc>(),
                            child: const PembelianPage(),
                          ),
                        );
                      },
                    ),
                    if (isAdmin)
                      _MenuGridCard(
                        icon: Icons.business,
                        label: 'Supplier',
                        color: Colors.brown,
                        onTap: () {
                          _navigateAndReload(
                            BlocProvider.value(
                              value: sl<SupplierBloc>(),
                              child: const SupplierPage(),
                            ),
                          );
                        },
                      ),
                    _MenuGridCard(
                      icon: Icons.receipt_long,
                      label: 'Riwayat Transaksi',
                      color: Colors.blue,
                      onTap: () {
                        _navigateAndReload(
                          BlocProvider(
                            create: (_) => sl<TransaksiBloc>(),
                            child: const TransaksiPage(),
                          ),
                        );
                      },
                    ),
                    if (isAdmin)
                      _MenuGridCard(
                        icon: Icons.people,
                        label: 'Hutang Piutang',
                        color: AppTheme.warningOrange,
                        onTap: () {
                          _navigateAndReload(
                            BlocProvider.value(
                              value: sl<HutangBloc>(),
                              child: const HutangPage(),
                            ),
                          );
                        },
                      ),
                    if (isAdmin)
                      _MenuGridCard(
                        icon: Icons.bar_chart,
                        label: 'Laporan',
                        color: Colors.purple,
                        onTap: () {
                          _navigateAndReload(
                            BlocProvider.value(
                              value: sl<LaporanBloc>(),
                              child: const LaporanPage(),
                            ),
                          );
                        },
                      ),
                    _MenuGridCard(
                      icon: Icons.settings,
                      label: 'Pengaturan',
                      color: Colors.indigo,
                      onTap: () {
                        _navigateAndReload(const SettingsPage());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
    );
  }
}

class _MenuGridCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _MenuGridCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
