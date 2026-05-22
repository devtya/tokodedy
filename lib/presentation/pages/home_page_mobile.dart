import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/dashboard/dashboard_state.dart';
import 'cashier_page.dart';
import 'hutang_page.dart';
import 'laporan_page.dart';
import 'notifikasi_page.dart';
import 'pembelian_page.dart';
import 'produk_page.dart';
import 'settings_page.dart';
import 'supplier_page.dart';
import 'transaksi_page.dart';
import 'user_management_page.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<NotifikasiBloc>()..add(LoadNotifikasi()),
        ),
        BlocProvider(
          create: (context) => sl<DashboardBloc>()..add(LoadDashboardMetrics()),
        ),
      ],
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
  final List<_QuickActionDef> _customQuickActions = [];
  static const _prefsKey = 'custom_quick_actions';

  @override
  void initState() {
    super.initState();
    _loadCustomQuickActions();
  }

  Future<void> _loadCustomQuickActions() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey) ?? [];
    setState(() {
      _customQuickActions.clear();
      for (final label in saved) {
        final match = _availableQuickActions.where((a) => a.label == label);
        if (match.isNotEmpty) {
          _customQuickActions.add(match.first);
        }
      }
    });
  }

  Future<void> _saveCustomQuickActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _customQuickActions.map((a) => a.label).toList(),
    );
  }

  static final List<_QuickActionDef> _availableQuickActions = [
    _QuickActionDef('Pembelian', Icons.shopping_bag, Colors.teal),
    _QuickActionDef('Supplier', Icons.business, Colors.brown),
    _QuickActionDef('Hutang', Icons.account_balance_wallet, AppTheme.warningOrange),
  ];

  Widget _buildQuickActionPage(String label) {
    switch (label) {
      case 'Pembelian':
        return BlocProvider.value(
          value: sl<PembelianBloc>(),
          child: const PembelianPage(),
        );
      case 'Supplier':
        return BlocProvider.value(
          value: sl<SupplierBloc>(),
          child: const SupplierPage(),
        );
      case 'Hutang':
        return BlocProvider.value(
          value: sl<HutangBloc>(),
          child: const HutangPage(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showAddQuickActionDialog() {
    final available = _availableQuickActions.where(
      (a) => !_customQuickActions.any((c) => c.label == a.label),
    ).toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua menu sudah ditambahkan')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Aksi Cepat'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: available.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: Icon(available[i].icon, color: available[i].color),
              title: Text(available[i].label),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _customQuickActions.add(available[i]));
                _saveCustomQuickActions();
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _reloadDashboardAndNotif() {
    if (mounted) {
      context.read<NotifikasiBloc>().add(LoadNotifikasi());
      context.read<DashboardBloc>().add(LoadDashboardMetrics());
    }
  }

  void _navigateAndReload(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) => _reloadDashboardAndNotif());
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

  void _showLainnyaBottomSheet(BuildContext context, bool isAdmin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Menu Lainnya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _LainnyaGridItem(
                  icon: Icons.shopping_bag,
                  label: 'Pembelian',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pop(context);
                    _navigateAndReload(
                      BlocProvider.value(
                        value: sl<PembelianBloc>(),
                        child: const PembelianPage(),
                      ),
                    );
                  },
                ),
                if (isAdmin)
                  _LainnyaGridItem(
                    icon: Icons.business,
                    label: 'Supplier',
                    color: Colors.brown,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateAndReload(
                        BlocProvider.value(
                          value: sl<SupplierBloc>(),
                          child: const SupplierPage(),
                        ),
                      );
                    },
                  ),
                if (isAdmin)
                  _LainnyaGridItem(
                    icon: Icons.people,
                    label: 'Hutang',
                    color: AppTheme.warningOrange,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateAndReload(
                        BlocProvider.value(
                          value: sl<HutangBloc>(),
                          child: const HutangPage(),
                        ),
                      );
                    },
                  ),
                if (isAdmin)
                  _LainnyaGridItem(
                    icon: Icons.bar_chart,
                    label: 'Laporan',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateAndReload(
                        BlocProvider.value(
                          value: sl<LaporanBloc>(),
                          child: const LaporanPage(),
                        ),
                      );
                    },
                  ),
                if (isAdmin)
                  _LainnyaGridItem(
                    icon: Icons.manage_accounts,
                    label: 'Pengguna',
                    color: Colors.brown,
                    onTap: () {
                      Navigator.pop(context);
                      _navigateAndReload(const UserManagementPage());
                    },
                  ),
                _LainnyaGridItem(
                  icon: Icons.settings,
                  label: 'Pengaturan',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pop(context);
                    _navigateAndReload(const SettingsPage());
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
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
              title: const Text('hend_kasir', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                context.read<NotifikasiBloc>().add(LoadNotifikasi());
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
            body: RefreshIndicator(
              onRefresh: () async {
                _reloadDashboardAndNotif();
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Greeting
                        Text(
                          'Halo, $username!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Selamat datang kembali di dashboard utama.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Dashboard Summary Card
                        BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            if (state is DashboardLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is DashboardLoaded) {
                              final formatCurrency = NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              );
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryGreen.withValues(alpha: 0.9),
                                      AppTheme.darkGreen,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.trending_up, color: Colors.white70, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'OMZET HARI INI',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatCurrency.format(state.metrics.omzet),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Transaksi',
                                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${state.metrics.transaksi}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Terjual',
                                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${state.metrics.terjual}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 24),

                        // System Alerts
                        BlocBuilder<NotifikasiBloc, NotifikasiState>(
                          builder: (context, state) {
                            if (state is NotifikasiLoaded && state.unreadNotifikasi.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.warning_amber_rounded, color: AppTheme.warningOrange),
                                      SizedBox(width: 8),
                                      Text(
                                        'Peringatan Sistem',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...state.unreadNotifikasi.take(2).map((notif) {
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      color: AppTheme.warningOrange.withValues(alpha: 0.1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: AppTheme.warningOrange.withValues(alpha: 0.3)),
                                      ),
                                      child: ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.warningOrange.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.inventory_2, color: AppTheme.warningOrange),
                                        ),
                                        title: Text(
                                          notif.judul,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        subtitle: Text(
                                          notif.pesan,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: const Icon(Icons.chevron_right),
                                        onTap: () {
                                          _navigateAndReload(
                                            BlocProvider.value(
                                              value: context.read<NotifikasiBloc>(),
                                              child: const NotifikasiPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        // Quick Actions
                        Row(
                          children: [
                            const Text(
                              'Aksi Cepat',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Material(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: _showAddQuickActionDialog,
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.add, size: 20, color: AppTheme.primaryGreen),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            children: [
                              SizedBox(
                                width: 90,
                                child: _QuickActionCard(
                                  icon: Icons.point_of_sale,
                                  label: 'KASIR',
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
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: _QuickActionCard(
                                  icon: Icons.print,
                                  label: 'LAPORAN',
                                  color: Colors.purple,
                                  onTap: isAdmin ? () {
                                    _navigateAndReload(
                                      BlocProvider.value(
                                        value: sl<LaporanBloc>(),
                                        child: const LaporanPage(),
                                      ),
                                    );
                                  } : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Hanya owner yang bisa akses Laporan')),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: _QuickActionCard(
                                  icon: Icons.add_box,
                                  label: 'STOK',
                                  color: Colors.blue,
                                  onTap: () {
                                    _navigateAndReload(
                                      BlocProvider.value(
                                        value: sl<ProdukBloc>(),
                                        child: const ProdukPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ..._customQuickActions.map((a) => Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  width: 90,
                                  child: _QuickActionCard(
                                    icon: a.icon,
                                    label: a.label,
                                    color: a.color,
                                    onTap: () => _navigateAndReload(_buildQuickActionPage(a.label)),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: _QuickActionCard(
                                  icon: Icons.add,
                                  label: 'TAMBAH',
                                  color: AppTheme.neutralGrey,
                                  onTap: _showAddQuickActionDialog,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80), // padding for bottom nav
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(top: 24),
              child: FloatingActionButton(
                onPressed: () {
                  _navigateAndReload(
                    BlocProvider.value(
                      value: sl<CashierBloc>(),
                      child: const CashierPage(),
                    ),
                  );
                },
                backgroundColor: AppTheme.primaryGreen,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.shopping_cart, color: Colors.white, size: 32),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BottomNavItem(
                      icon: Icons.home,
                      label: 'Beranda',
                      isActive: true,
                      onTap: () {}, // Already here
                    ),
                    _BottomNavItem(
                      icon: Icons.inventory_2,
                      label: 'Produk',
                      isActive: false,
                      onTap: () {
                        _navigateAndReload(
                          BlocProvider.value(
                            value: sl<ProdukBloc>(),
                            child: const ProdukPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 48), // Space for FAB
                    _BottomNavItem(
                      icon: Icons.receipt_long,
                      label: 'Riwayat',
                      isActive: false,
                      onTap: () {
                        _navigateAndReload(
                          BlocProvider(
                            create: (_) => sl<TransaksiBloc>(),
                            child: const TransaksiPage(),
                          ),
                        );
                      },
                    ),
                    _BottomNavItem(
                      icon: Icons.menu,
                      label: 'Lainnya',
                      isActive: false,
                      onTap: () => _showLainnyaBottomSheet(context, isAdmin),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickActionDef {
  final String label;
  final IconData icon;
  final Color color;
  const _QuickActionDef(this.label, this.icon, this.color);
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppTheme.primaryGreen : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _LainnyaGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _LainnyaGridItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
               color: color.withValues(alpha: 0.1),
               shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
