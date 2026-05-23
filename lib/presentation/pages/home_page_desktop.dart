import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/di/injection.dart';
import 'login_page.dart';
import '../../core/theme/app_theme.dart';
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
import 'user_management_page.dart';

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
  _NavItem(icon: Icons.point_of_sale_rounded,   label: 'Kasir',               section: 'Utama'),
  _NavItem(icon: Icons.inventory_2_rounded,      label: 'Produk'),
  _NavItem(icon: Icons.shopping_bag_rounded,     label: 'Pembelian'),
  _NavItem(icon: Icons.receipt_long_rounded,     label: 'Riwayat Transaksi'),
  _NavItem(icon: Icons.business_rounded,         label: 'Supplier',            section: 'Admin', adminOnly: true),
  _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Hutang Piutang', adminOnly: true),
  _NavItem(icon: Icons.bar_chart_rounded,        label: 'Laporan',             adminOnly: true),
  _NavItem(icon: Icons.settings_rounded,          label: 'Pengaturan'),
];

class HomeDesktopPage extends StatelessWidget {
  const HomeDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotifikasiBloc>()..add(LoadNotifikasi()),
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

  void _reloadNotifikasi() {
    if (mounted) context.read<NotifikasiBloc>().add(LoadNotifikasi());
  }

  Future<void> _navigateAndReload(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _reloadNotifikasi();
  }

  void _onNavTap(int index, bool isAdmin, String username) {
    setState(() => _selectedIndex = index);

    final visibleItems = _navItems
        .where((e) => isAdmin || !e.adminOnly)
        .toList();

    if (index >= visibleItems.length) return;
    final item = visibleItems[index];

    switch (item.label) {
      case 'Kasir':
        _navigateAndReload(BlocProvider.value(
          value: sl<CashierBloc>(),
          child: const CashierPage(),
        ));
      case 'Produk':
        _navigateAndReload(BlocProvider.value(
          value: sl<ProdukBloc>(),
          child: const ProdukPage(),
        ));
      case 'Pembelian':
        _navigateAndReload(BlocProvider.value(
          value: sl<PembelianBloc>(),
          child: const PembelianPage(),
        ));
      case 'Riwayat Transaksi':
        _navigateAndReload(BlocProvider(
          create: (_) => sl<TransaksiBloc>(),
          child: const TransaksiPage(),
        ));
      case 'Supplier':
        _navigateAndReload(BlocProvider.value(
          value: sl<SupplierBloc>(),
          child: const SupplierPage(),
        ));
      case 'Hutang Piutang':
        _navigateAndReload(BlocProvider.value(
          value: sl<HutangBloc>(),
          child: const HutangPage(),
        ));
      case 'Laporan':
        _navigateAndReload(BlocProvider.value(
          value: sl<LaporanBloc>(),
          child: const LaporanPage(),
        ));
      case 'Pengaturan':
        _navigateAndReload(const SettingsPage());
    }
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
            backgroundColor: AppTheme.surface,
            body: Row(
              children: [
                _Sidebar(
                  username: username,
                  role: role,
                  isAdmin: isAdmin,
                  selectedIndex: _selectedIndex,
                  onNavTap: (i) => _onNavTap(i, isAdmin, username),
                  onSettingsTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        username: username,
                        onNotifTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<NotifikasiBloc>(),
                                child: const NotifikasiPage(),
                              ),
                            ),
                          ).then((_) => _reloadNotifikasi());
                        },
                        onSettingsTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        ),
                      ),
                    Expanded(
                      child: _DashboardBody(
                        isAdmin: isAdmin,
                        onMenuTap: (label) {
                          final visibleItems = _navItems
                              .where((e) => isAdmin || !e.adminOnly)
                              .toList();
                          final idx = visibleItems
                              .indexWhere((e) => e.label == label);
                          if (idx != -1) _onNavTap(idx, isAdmin, username);
                        },
                      ),
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
    final visibleItems =
        _navItems.where((e) => isAdmin || !e.adminOnly).toList();

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('hend_kasir',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text('Sistem Kasir',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 0.5, thickness: 0.5, color: colorScheme.outlineVariant),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: visibleItems.length,
              itemBuilder: (context, i) {
                final item = visibleItems[i];
                final isSelected = selectedIndex == i;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.section != null) ...[
                      if (i != 0) const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                        child: Text(
                          item.section!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
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

          Divider(height: 0.5, thickness: 0.5, color: colorScheme.outlineVariant),

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
                    position: RelativeRect.fromLTRB(200, 600, 400, 700),
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
                      case 'users':
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => const UserManagementPage(),
                          ),
                        );
                      case 'notes':
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<NotifikasiBloc>(),
                              child: const NotifikasiPage(),
                            ),
                          ),
                        );
                    }
                  });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primaryGreen,
                        child: Text(
                          username.isNotEmpty
                              ? username[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis),
                            Text(isAdmin ? 'Administrator' : 'Kasir',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Icon(Icons.logout_rounded,
                          size: 17, color: colorScheme.onSurfaceVariant),
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
      color: selected
          ? AppTheme.primaryGreen.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: selected
                    ? AppTheme.primaryGreen
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected
                        ? AppTheme.primaryGreen
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
  final String username;
  final VoidCallback onNotifTap;
  final VoidCallback onSettingsTap;

  const _TopBar({
    required this.username,
    required this.onNotifTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    return Container(
      height: 56,
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
              Text('Halo, $username! 👋',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(today,
                  style: TextStyle(
                      fontSize: 11, color: colorScheme.onSurfaceVariant)),
            ],
          ),

          const Spacer(),

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
          _TopBarButton(
            icon: Icons.settings_outlined,
            onTap: onSettingsTap,
          ),
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
                    color: colorScheme.outlineVariant, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  size: 18, color: colorScheme.onSurfaceVariant),
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
                    color: Theme.of(context).cardColor, width: 1.5),
              ),
              constraints:
                  const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$badge',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
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


          _SectionLabel(label: 'Menu Cepat'),
          const SizedBox(height: 12),
          _MenuGrid(isAdmin: isAdmin, onMenuTap: onMenuTap),

          const SizedBox(height: 28),

          if (isAdmin) ...[
            _SectionLabel(label: 'Ringkasan Hari Ini'),
            const SizedBox(height: 12),
            const _StatsRow(),
          ],
        ],
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String title;
  final String message;

  const _AlertBanner({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.warningOrange.withValues(alpha: 0.10),
        border: Border.all(
            color: AppTheme.warningOrange.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.campaign_rounded,
              color: AppTheme.warningOrange, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warningOrange)),
                Text(message,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.warningOrange
                            .withValues(alpha: 0.8)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
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
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  final bool isAdmin;
  final ValueChanged<String> onMenuTap;

  const _MenuGrid({required this.isAdmin, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuDef('Kasir',               Icons.point_of_sale_rounded,          const Color(0xFF1D9E75), const Color(0xFFE1F5EE), false),
      _MenuDef('Produk',              Icons.inventory_2_rounded,             const Color(0xFF3B6D11), const Color(0xFFEAF3DE), false),
      _MenuDef('Pembelian',           Icons.shopping_bag_rounded,            const Color(0xFF185FA5), const Color(0xFFE6F1FB), false),
      _MenuDef('Riwayat Transaksi',   Icons.receipt_long_rounded,            const Color(0xFF993C1D), const Color(0xFFFAECE7), false),
      _MenuDef('Supplier',            Icons.business_rounded,                const Color(0xFF854F0B), const Color(0xFFFAEEDA), true),
      _MenuDef('Hutang Piutang',      Icons.account_balance_wallet_rounded,  const Color(0xFF993556), const Color(0xFFFBEAF0), true),
      _MenuDef('Laporan',             Icons.bar_chart_rounded,               const Color(0xFF534AB7), const Color(0xFFEEEDFE), true),
      _MenuDef('Manajemen Pengguna',  Icons.manage_accounts_rounded,         const Color(0xFF5F5E5A), const Color(0xFFF1EFE8), true),
    ];

    final visible = menus.where((m) => isAdmin || !m.adminOnly).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final colCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: colCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
          ),
          itemCount: visible.length,
          itemBuilder: (context, i) => _MenuCard(
            def: visible[i],
            onTap: () => onMenuTap(visible[i].label),
          ),
        );
      },
    );
  }
}

class _MenuDef {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool adminOnly;

  const _MenuDef(
      this.label, this.icon, this.iconColor, this.bgColor, this.adminOnly);
}

class _MenuCard extends StatelessWidget {
  final _MenuDef def;
  final VoidCallback onTap;

  const _MenuCard({required this.def, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: colorScheme.outlineVariant, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: def.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(def.icon, color: def.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  def.label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
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

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            label: 'Total Penjualan',
            value: 'Rp 0',
            sub: 'hari ini',
            icon: Icons.payments_rounded,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Transaksi',
            value: '0',
            sub: 'transaksi selesai',
            icon: Icons.receipt_rounded,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Produk Menipis',
            value: '0',
            sub: 'perlu restock',
            icon: Icons.warning_amber_rounded,
            danger: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final bool danger;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final valueColor =
        danger ? AppTheme.warningRed : Theme.of(context).textTheme.bodyLarge!.color!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (danger ? AppTheme.warningRed : AppTheme.primaryGreen)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                size: 20,
                color: danger ? AppTheme.warningRed : AppTheme.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11, color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: valueColor)),
                Text(sub,
                    style: TextStyle(
                        fontSize: 11, color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
