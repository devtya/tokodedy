part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class SyncTriggered extends SyncEvent {
  const SyncTriggered();
}

class SyncStatusChanged extends SyncEvent {
  final bool isOnline;
  const SyncStatusChanged(this.isOnline);

  @override
  List<Object?> get props => [isOnline];
}

class InitialSyncTriggered extends SyncEvent {
  const InitialSyncTriggered();
}

class ClearSyncError extends SyncEvent {
  const ClearSyncError();
}
