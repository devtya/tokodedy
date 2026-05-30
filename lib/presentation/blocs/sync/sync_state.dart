part of 'sync_bloc.dart';

sealed class SyncState extends Equatable {
  final List<SyncLogEntry> logs;
  const SyncState({this.logs = const []});

  @override
  List<Object?> get props => [logs];
}

class SyncInitial extends SyncState {
  const SyncInitial() : super();
}

class InitialSyncInProgress extends SyncState {
  final int fetched;
  final int total;
  final String phase; // 'counting', 'downloading', 'inserting', 'done'
  const InitialSyncInProgress({
    this.fetched = 0,
    this.total = 0,
    this.phase = 'downloading',
    super.logs,
  });

  @override
  List<Object?> get props => [fetched, total, phase, logs];
}

class SyncIdle extends SyncState {
  final bool isOnline;
  final DateTime? lastSync;

  const SyncIdle({this.isOnline = false, this.lastSync, super.logs});

  @override
  List<Object?> get props => [isOnline, lastSync, logs];
}

class SyncInProgress extends SyncState {
  final bool isOnline;
  const SyncInProgress({this.isOnline = false, super.logs});

  @override
  List<Object?> get props => [isOnline, logs];
}

class SyncSuccess extends SyncState {
  final bool isOnline;
  final DateTime lastSync;

  const SyncSuccess({this.isOnline = false, required this.lastSync, super.logs});

  @override
  List<Object?> get props => [isOnline, lastSync, logs];
}

class SyncError extends SyncState {
  final String message;
  final bool isOnline;
  final DateTime? lastSync;

  const SyncError({required this.message, this.isOnline = false, this.lastSync, super.logs});

  @override
  List<Object?> get props => [message, isOnline, lastSync, logs];
}
