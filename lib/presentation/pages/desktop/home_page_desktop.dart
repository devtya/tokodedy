import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hend_kasir/core/services/toko_service.dart';
import 'package:hend_kasir/presentation/blocs/cashier/cashier_event.dart';
import 'package:hend_kasir/presentation/blocs/cashier/cashier_state.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../shared/login_page.dart';
import '../../../core/theme/app_theme.dart';
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
import '../shared/cashier_page.dart';
import '../shared/hutang_page.dart';
import '../shared/laporan_page.dart';
import '../shared/notifikasi_page.dart';
import '../shared/pembelian_page.dart';
import '../shared/produk_page.dart';
import '../shared/settings_page.dart';
import '../shared/supplier_page.dart';
import '../shared/transaksi_page.dart';
import '../shared/user_management_page.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final String? section;
  final bool adminOnly;

  const _NavItem({
    required this.icon,
    required this.label,
    this.section,
    this.adminOnly = false,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', section: 'Utama'),
  _NavItem(icon: Icons.point_of_sale_rounded, label: 'Kasir'),
  _NavItem(icon: Icons.inventory_2_rounded, label: 'Produk'),
  _NavItem(icon: Icons.shopping_bag_rounded, label: 'Pembelian'),
  _NavItem(icon: Icons.receipt_long_rounded, label: 'Riwayat Transaksi'),
  _NavItem(
    icon: Icons.business_rounded,
    label: 'Supplier',
    section: 'Admin',
    adminOnly: true,
  ),
  _NavItem(
    icon: Icons.account_balance_wallet_rounded,
    label: 'Hutang Piutang',
    adminOnly: true,
  ),
  _NavItem(icon: Icons.bar_chart_rounded, label: 'Laporan', adminOnly: true),
  _NavItem(icon: Icons.settings_rounded, label: 'Pengaturan'),
];

class HomeDesktopPage extends StatelessWidget {
  const HomeDesktopPage({super.key});

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
        BlocProvider(create: (context) => sl<CashierBloc>()),
      ],
      child: const _HomeDesktopView(),
    );
  }
}

class _HomeDesktopView extends StatefulWidget {
  const _HomeDesktopView();

  @override
  State<_HomeDesktopView> createState() => _HomeDesktopViewState();
}

class _HomeDesktopViewState extends State<_HomeDesktopView> {
  int _selectedIndex = 0;
  bool _emailPromptShown = false;

  void _reloadNotifikasiAndDashboard() {
    if (mounted) {
      context.read<NotifikasiBloc>().add(LoadNotifikasi());
      context.read<DashboardBloc>().add(LoadDashboardMetrics());
    }
  }

  void _onNavTap(int index, bool isAdmin, String username) {
    final visibleItems = _navItems
        .where((e) => isAdmin || !e.adminOnly)
        .toList();
    if (visibleItems[_selectedIndex].label == 'Kasir') {
      final cashierState = context.read<CashierBloc>().state;
      if (cashierState is CashierReady && cashierState.cart.isNotEmpty) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Keranjang Belum Kosong'),
            content: const Text(
              'Anda memiliki barang di keranjang kasir. Harap bersihkan keranjang '
              'atau simpan sebagai pending sebelum berpindah menu.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tetap di Kasir'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningRed,
                ),
                onPressed: () {
                  context.read<CashierBloc>().add(const ClearCart());
                  Navigator.pop(ctx);
                  setState(() => _selectedIndex = index);
                },
                child: const Text(
                  'Bersihkan & Pindah',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
        return;
      }
    }
    setState(() => _selectedIndex = index);
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

  Widget _buildPages(bool isAdmin, String username) {
    final visibleItems = _navItems
        .where((e) => isAdmin || !e.adminOnly)
        .toList();
    return IndexedStack(
      index: _selectedIndex,
      children: visibleItems.map((item) {
        switch (item.label) {
          case 'Dashboard':
            return _DashboardBody(
              isAdmin: isAdmin,
              onMenuTap: (label) {
                final idx = visibleItems.indexWhere((e) => e.label == label);
                if (idx != -1) _onNavTap(idx, isAdmin, username);
              },
            );
          case 'Kasir':
            return const CashierPage();
          case 'Produk':
            return BlocProvider(
              create: (_) => sl<ProdukBloc>(),
              child: const ProdukPage(),
            );
          case 'Pembelian':
            return BlocProvider(
              create: (_) => sl<PembelianBloc>(),
              child: const PembelianPage(),
            );
          case 'Riwayat Transaksi':
            return BlocProvider(
              create: (_) => sl<TransaksiBloc>(),
              child: const TransaksiPage(),
            );
          case 'Supplier':
            return BlocProvider(
              create: (_) => sl<SupplierBloc>(),
              child: const SupplierPage(),
            );
          case 'Hutang Piutang':
            return BlocProvider(
              create: (_) => sl<HutangBloc>(),
              child: const HutangPage(),
            );
          case 'Laporan':
            return BlocProvider(
              create: (_) => sl<LaporanBloc>(),
              child: const LaporanPage(),
            );
          case 'Pengaturan':
            return const SettingsPage();
          default:
            return const SizedBox();
        }
      }).toList(),
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

          final visibleItems = _navItems
              .where((e) => isAdmin || !e.adminOnly)
              .toList();

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Row(
              children: [
                _Sidebar(
                  username: username,
                  role: role,
                  isAdmin: isAdmin,
                  selectedIndex: _selectedIndex,
                  onNavTap: (i) => _onNavTap(i, isAdmin, username),
                  onSettingsTap: () {
                    // Cek jika pengaturan ada di navItems
                    final idx = visibleItems.indexWhere(
                      (e) => e.label == 'Pengaturan',
                    );
                    if (idx != -1) {
                      _onNavTap(idx, isAdmin, username);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        activeMenuName: visibleItems[_selectedIndex].label,
                        onNotifTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<NotifikasiBloc>(),
                                child: const NotifikasiPage(),
                              ),
                            ),
                          ).then((_) => _reloadNotifikasiAndDashboard());
                        },
                        onSettingsTap: () {
                          final idx = visibleItems.indexWhere(
                            (e) => e.label == 'Pengaturan',
                          );
                          if (idx != -1) {
                            _onNavTap(idx, isAdmin, username);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            );
                          }
                        },
                      ),
                      Expanded(child: _buildPages(isAdmin, username)),
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

class _Sidebar extends StatelessWidget {
  final String username;
  final String role;
  final bool isAdmin;
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  final VoidCallback onSettingsTap;

  const _Sidebar({
    required this.username,
    required this.role,
    required this.isAdmin,
    required this.selectedIndex,
    required this.onNavTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleItems = _navItems
        .where((e) => isAdmin || !e.adminOnly)
        .toList();

    final tokoName = sl<TokoService>().tokoName;
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70, // Sama rata dengan _TopBar
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'HendKasir',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                      ),
                      Text(
                        '$username ($role) • $tokoName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () =>
                  onNavTap(_navItems.indexWhere((e) => e.label == 'Kasir')),
              icon: const Icon(Icons.point_of_sale_rounded, size: 20),
              label: const Text('Kasir'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: visibleItems.length,
              itemBuilder: (context, i) {
                final item = visibleItems[i];
                final isSelected = selectedIndex == i;

                if (item.label == 'Kasir') return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NavTile(
                      icon: item.icon,
                      label: item.label,
                      selected: isSelected,
                      onTap: () => onNavTap(i),
                    ),
                  ],
                );
              },
            ),
          ),

          Divider(
            height: 0.5,
            thickness: 0.5,
            color: colorScheme.outlineVariant,
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  final navigator = Navigator.of(context);
                  showMenu<String>(
                    context: context,
                    position: const RelativeRect.fromLTRB(200, 600, 400, 700),
                    items: [
                      const PopupMenuItem(
                        value: 'settings',
                        child: ListTile(
                          leading: Icon(Icons.settings, size: 20),
                          title: Text('Pengaturan'),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      if (isAdmin)
                        const PopupMenuItem(
                          value: 'users',
                          child: ListTile(
                            leading: Icon(Icons.people, size: 20),
                            title: Text('Manajemen Pengguna'),
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'notes',
                        child: ListTile(
                          leading: Icon(Icons.warning_amber, size: 20),
                          title: Text('Catatan & Peringatan'),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == null) return;
                    switch (value) {
                      case 'settings':
                        onSettingsTap();
                        break;
                      case 'users':
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => const UserManagementPage(),
                          ),
                        );
                        break;
                      case 'notes':
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<NotifikasiBloc>(),
                              child: const NotifikasiPage(),
                            ),
                          ),
                        );
                        break;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primaryGreen,
                        child: Text(
                          username.isNotEmpty ? username[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isAdmin ? 'Administrator' : 'Kasir',
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.logout_rounded,
                        size: 17,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? colorScheme.secondaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String activeMenuName;
  final VoidCallback onNotifTap;
  final VoidCallback onSettingsTap;

  const _TopBar({
    required this.activeMenuName,
    required this.onNotifTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Container(
      height: 70, // Sama rata dengan _Sidebar
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                activeMenuName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Spacer(),

          Text(
            today,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),

          BlocBuilder<NotifikasiBloc, NotifikasiState>(
            builder: (context, state) {
              int unread = 0;
              if (state is NotifikasiLoaded) {
                unread = state.unreadNotifikasi.length;
              }
              return _TopBarButton(
                icon: Icons.notifications_outlined,
                badge: unread,
                onTap: onNotifTap,
              );
            },
          ),
          const SizedBox(width: 8),
          _TopBarButton(icon: Icons.settings_outlined, onTap: onSettingsTap),
        ],
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final int badge;
  final VoidCallback onTap;

  const _TopBarButton({
    required this.icon,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        if (badge > 0)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.warningRed,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).cardColor,
                  width: 1.5,
                ),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final bool isAdmin;
  final ValueChanged<String> onMenuTap;

  const _DashboardBody({required this.isAdmin, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAdmin) ...[
            _SectionLabel(label: 'Ringkasan Hari Ini'),
            const SizedBox(height: 16),
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
                  return Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Omzet Hari Ini',
                          value: formatCurrency.format(state.metrics.omzet),
                          icon: Icons.trending_up_rounded,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Transaksi',
                          value: '${state.metrics.transaksi}',
                          icon: Icons.receipt_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Barang Terjual',
                          value: '${state.metrics.terjual}',
                          icon: Icons.inventory_2_rounded,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 32),
          ],

          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kiri: Stok Menipis
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: 'Stok Menipis'),
                          const SizedBox(height: 16),
                          if (state.metrics.stokMenipis.isEmpty)
                            const _EmptyCard(message: 'Stok aman')
                          else
                            _StokMenipisList(
                              stokMenipis: state.metrics.stokMenipis,
                              onMenuTap: onMenuTap,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Kanan: Update Harga
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: 'Update Harga Terakhir'),
                          const SizedBox(height: 16),
                          if (state.metrics.updateHargaTerakhir.isEmpty)
                            const _EmptyCard(message: 'Belum ada update harga')
                          else
                            _UpdateHargaList(
                              riwayat: state.metrics.updateHargaTerakhir,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _StokMenipisList extends StatelessWidget {
  final List<dynamic> stokMenipis;
  final ValueChanged<String> onMenuTap;
  const _StokMenipisList({required this.stokMenipis, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stokMenipis.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        itemBuilder: (context, index) {
          final item = stokMenipis[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF93000a)
                    : const Color(0xFFef4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: isDark
                    ? const Color(0xFFffb4ab)
                    : const Color(0xFFef4444),
                size: 20,
              ),
            ),
            title: Text(
              item.nama,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFffb4ab)
                    : const Color(0xFFef4444),
                borderRadius: BorderRadius.circular(isDark ? 9999 : 8),
              ),
              child: Text(
                'Sisa ${item.stok}',
                style: TextStyle(
                  color: isDark ? const Color(0xFF93000a) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onTap: () => onMenuTap('Produk'),
          );
        },
      ),
    );
  }
}

class _UpdateHargaList extends StatelessWidget {
  final List<dynamic> riwayat;
  const _UpdateHargaList({required this.riwayat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: riwayat.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        itemBuilder: (context, index) {
          final item = riwayat[index];
          final formatCurrency = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          );
          final time = DateFormat('HH:mm').format(item.createdAt);

          final isHargaJualNaik = item.hargaJualBaru > item.hargaJualLama;
          final isHargaJualTurun = item.hargaJualBaru < item.hargaJualLama;
          final isHargaBeliNaik = item.hargaBeliBaru > item.hargaBeliLama;
          final isHargaBeliTurun = item.hargaBeliBaru < item.hargaBeliLama;

          bool isNaik =
              isHargaJualNaik || (!isHargaJualTurun && isHargaBeliNaik);
          bool isTurun =
              isHargaJualTurun || (!isHargaJualNaik && isHargaBeliTurun);

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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            title: Text(
              item.produkNama ?? 'Produk Dihapus',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            subtitle: Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency.format(item.hargaJualBaru),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  formatCurrency.format(item.hargaJualLama),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
