import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/sync/sync_bloc.dart';
import '../pages/shared/sync_log_page.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        if (state is SyncInProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state is SyncInProgress || state is InitialSyncInProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        IconData icon;
        Color color;

        switch (state) {
          case SyncInitial():
            icon = Icons.sync_disabled;
            color = Colors.grey;
          case SyncIdle(isOnline: var online):
            icon = online ? Icons.cloud_done : Icons.cloud_off;
            color = online ? const Color(0xFF2ECC71) : Colors.grey;
          case SyncSuccess():
            icon = Icons.cloud_done;
            color = const Color(0xFF2ECC71);
          case SyncError():
            icon = Icons.cloud_off;
            color = Colors.red;
          default:
            icon = Icons.sync;
            color = Colors.amber;
        }

        return IconButton(
          icon: Icon(icon, color: color, size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SyncLogPage()),
            );
          },
          onLongPress: () =>
              context.read<SyncBloc>().add(const SyncTriggered()),
          tooltip: 'Riwayat sinkronisasi',
        );
      },
    );
  }
}
