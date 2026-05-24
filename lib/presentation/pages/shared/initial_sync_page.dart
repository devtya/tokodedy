import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/sync/sync_bloc.dart';

class InitialSyncPage extends StatefulWidget {
  final Widget destination;
  const InitialSyncPage({super.key, required this.destination});

  @override
  State<InitialSyncPage> createState() => _InitialSyncPageState();
}

class _InitialSyncPageState extends State<InitialSyncPage> {
  StreamSubscription? _syncSub;

  @override
  void initState() {
    super.initState();
    context.read<SyncBloc>().add(const InitialSyncTriggered());
  }

  @override
  void dispose() {
    _syncSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SyncBloc, SyncState>(
        listener: (context, state) {
          if (state is InitialSyncInProgress && state.phase == 'done') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => widget.destination),
            );
          }
        },
        child: BlocBuilder<SyncBloc, SyncState>(
          builder: (context, state) {
            if (state is InitialSyncInProgress) {
              return _buildProgress(state);
            }
            return _buildInitial();
          },
        ),
      ),
    );
  }

  Widget _buildInitial() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 24),
          Text(
            'Menghubungkan ke server...',
            style: TextStyle(color: AppTheme.neutralGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(InitialSyncInProgress state) {
    final progress = state.total > 0 ? state.fetched / state.total : 0.0;

    String statusText;
    if (state.phase == 'counting') {
      statusText = 'Menghitung data...';
    } else if (state.fetched < state.total) {
      statusText = 'Mengunduh data...';
    } else {
      statusText = 'Menyimpan ke database...';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/icon.png',
            width: 80,
            height: 80,
            errorBuilder: (_, _, _) => Icon(
              Icons.cloud_download,
              size: 64,
              color: const Color(0xFF2ECC71),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'HendKasir',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sinkronisasi awal',
            style: TextStyle(color: AppTheme.neutralGrey),
          ),
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.phase == 'counting' ? null : progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.phase == 'counting'
                ? statusText
                : '$statusText ${state.fetched}/${state.total}',
            style: TextStyle(color: AppTheme.neutralGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
