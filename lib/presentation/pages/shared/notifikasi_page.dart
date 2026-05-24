import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/notifikasi/notifikasi_bloc.dart';
import '../../blocs/notifikasi/notifikasi_event.dart';
import '../../blocs/notifikasi/notifikasi_state.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

  @override
  void initState() {
    super.initState();
    context.read<NotifikasiBloc>().add(LoadNotifikasi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tandai semua dibaca',
            onPressed: () {
              context.read<NotifikasiBloc>().add(MarkAllNotifikasiAsRead());
            },
          ),
        ],
      ),
      body: BlocBuilder<NotifikasiBloc, NotifikasiState>(
        builder: (context, state) {
          if (state is NotifikasiLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotifikasiLoaded) {
            final items = state.allNotifikasi;
            if (items.isEmpty) {
              return const Center(child: Text('Belum ada notifikasi.'));
            }

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notif = items[index];
                final bool isWarning = notif.tipe == 'WARNING';

                return ListTile(
                  tileColor: notif.isRead
                      ? null
                      : AppTheme.surface.withValues(alpha: 0.5),
                  leading: CircleAvatar(
                    backgroundColor: isWarning
                        ? AppTheme.warningRed.withValues(alpha: 0.2)
                        : AppTheme.primaryGreen.withValues(alpha: 0.2),
                    child: Icon(
                      isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.info_outline,
                      color: isWarning
                          ? AppTheme.warningRed
                          : AppTheme.primaryGreen,
                    ),
                  ),
                  title: Text(
                    notif.judul,
                    style: TextStyle(
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notif.pesan),
                      const SizedBox(height: 4),
                      Text(
                        _dateFormat.format(notif.createdAt ?? DateTime.now()),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!notif.isRead) {
                      context.read<NotifikasiBloc>().add(
                        MarkNotifikasiAsRead(notif.id!),
                      );
                    }
                  },
                );
              },
            );
          }
          if (state is NotifikasiError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
