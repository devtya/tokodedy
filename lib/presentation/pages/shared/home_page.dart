import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../i18n/strings.g.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import 'login_page.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cashier/cashier_bloc.dart';
import '../../blocs/hutang/hutang_bloc.dart';
import '../../blocs/laporan/laporan_bloc.dart';
import '../../blocs/notifikasi/notifikasi_bloc.dart';
import '../../blocs/notifikasi/notifikasi_event.dart';
import '../../blocs/notifikasi/notifikasi_state.dart';
import '../../blocs/pembelian/pembelian_bloc.dart';
import '../../blocs/produk/produk_bloc.dart';
import '../../blocs/supplier/supplier_bloc.dart';
import '../../blocs/transaksi/transaksi_bloc.dart';
import '../../blocs/dashboard/dashboard_bloc.dart';
import '../../blocs/dashboard/dashboard_event.dart';
import '../../blocs/dashboard/dashboard_state.dart';
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
import '../../../core/services/toko_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: const Text('HendKasir', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${t.home.welcome} $username! \u{1f44b}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primaryGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        sl<TokoService>().tokoName ?? 'Toko',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryGreen,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                              final isDark = Theme.of(context).brightness == Brightness.dark;
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark 
                                      ? [const Color(0xFF1a4d2e), const Color(0xFF0f3320), const Color(0xFF0d0e0e)]
                                      : [const Color(0xFF22c55e), const Color(0xFF16a34a), const Color(0xFF14532d)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
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
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isDark ? 36 : 32,
                                        fontWeight: isDark ? FontWeight.w700 : FontWeight.w800,
                                        letterSpacing: -1,
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

                        // Quick Actions
                        const Text(
                          'Aksi Cepat',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  icon: Icons.inventory_2,
                                  label: 'PRODUK',
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
                        const SizedBox(height: 24),
                        
                        // Stok Menipis & Transaksi Terakhir (from DashboardBloc)
                        BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            if (state is DashboardLoaded) {
                              final isDark = Theme.of(context).brightness == Brightness.dark;
                              final borderColor = isDark ? Theme.of(context).colorScheme.outline : const Color(0xFFE5EAE5);
                              final cardRadius = isDark ? 20.0 : 14.0;
                              final borderWidth = isDark ? 1.0 : 1.5;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Stok Menipis
                                  if (state.metrics.stokMenipis.isNotEmpty) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Stok Menipis',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _navigateAndReload(
                                              BlocProvider.value(
                                                value: sl<ProdukBloc>(),
                                                child: const ProdukPage(),
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: const Text('Lihat semua', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark ? Theme.of(context).colorScheme.surfaceContainer : Colors.white,
                                        borderRadius: BorderRadius.circular(cardRadius),
                                        border: Border.all(color: borderColor, width: borderWidth),
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: state.metrics.stokMenipis.length,
                                        separatorBuilder: (context, index) => Divider(
                                          height: 1, 
                                          thickness: isDark ? 1 : 1.5,
                                          color: isDark ? Theme.of(context).colorScheme.surfaceContainerLow : const Color(0xFFEEEEEE),
                                        ),
                                        itemBuilder: (context, index) {
                                          final item = state.metrics.stokMenipis[index];
                                          final rowColor = isDark 
                                            ? (index.isOdd ? Theme.of(context).colorScheme.surfaceContainerLow : Colors.transparent)
                                            : Colors.transparent;
                                          return Container(
                                            color: rowColor,
                                            child: ListTile(
                                              leading: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: isDark ? const Color(0xFF93000a) : const Color(0xFFef4444).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(Icons.warning_rounded, color: isDark ? const Color(0xFFffb4ab) : const Color(0xFFef4444)),
                                              ),
                                              title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                              trailing: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: isDark ? const Color(0xFFffb4ab) : const Color(0xFFef4444),
                                                  borderRadius: BorderRadius.circular(isDark ? 9999 : 8),
                                                ),
                                                child: Text(
                                                  'Sisa ${item.stok}',
                                                  style: TextStyle(
                                                    color: isDark ? const Color(0xFF93000a) : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],

                                  // Update Harga Barang
                                  if (state.metrics.updateHargaTerakhir.isNotEmpty) ...[
                                    const Text(
                                      'Update Harga Barang',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark ? Theme.of(context).colorScheme.surfaceContainer : Colors.white,
                                        borderRadius: BorderRadius.circular(cardRadius),
                                        border: Border.all(color: borderColor, width: borderWidth),
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: state.metrics.updateHargaTerakhir.length,
                                        separatorBuilder: (context, index) => Divider(
                                          height: 1, 
                                          thickness: isDark ? 1 : 1.5,
                                          color: isDark ? Theme.of(context).colorScheme.surfaceContainerLow : const Color(0xFFEEEEEE),
                                        ),
                                        itemBuilder: (context, index) {
                                          final riwayat = state.metrics.updateHargaTerakhir[index];
                                          final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
                                          final time = DateFormat('HH:mm').format(riwayat.createdAt);
                                          
                                          final isHargaJualNaik = riwayat.hargaJualBaru > riwayat.hargaJualLama;
                                          final isHargaJualTurun = riwayat.hargaJualBaru < riwayat.hargaJualLama;
                                          final isHargaBeliNaik = riwayat.hargaBeliBaru > riwayat.hargaBeliLama;
                                          final isHargaBeliTurun = riwayat.hargaBeliBaru < riwayat.hargaBeliLama;

                                          bool isNaik = isHargaJualNaik || (!isHargaJualTurun && isHargaBeliNaik);
                                          bool isTurun = isHargaJualTurun || (!isHargaJualNaik && isHargaBeliTurun);
                                          
                                          Color iconColor = Colors.blue;
                                          IconData iconData = Icons.price_change;
                                          if (isNaik) {
                                            iconColor = AppTheme.error;
                                            iconData = Icons.trending_up; 
                                          } else if (isTurun) {
                                            iconColor = AppTheme.primaryGreen;
                                            iconData = Icons.trending_down;
                                          }

                                          return ListTile(
                                            leading: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: iconColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(iconData, color: iconColor),
                                            ),
                                            title: Text(
                                              riwayat.produkNama ?? 'Produk Dihapus',
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                            ),
                                            subtitle: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                            trailing: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formatCurrency.format(riwayat.hargaJualBaru),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  formatCurrency.format(riwayat.hargaJualLama),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        
                        const SizedBox(height: 80),
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
                      onTap: () {},
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
                    const SizedBox(width: 48),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isDark ? color.withValues(alpha: 0.12) : color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.25), 
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF737373) : const Color(0xFF666666),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
