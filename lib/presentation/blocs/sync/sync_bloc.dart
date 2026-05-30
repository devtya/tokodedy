import 'package:injectable/injectable.dart';
import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/supabase_sync_service.dart';

part 'sync_event.dart';
part 'sync_state.dart';

@injectable
class SyncLogEntry extends Equatable {
  final DateTime timestamp;
  final String type; // 'push_table', 'pull_table', 'push_done', 'pull_done', 'error'
  final String? tableName;
  final String message;
  final bool isSuccess;

  const SyncLogEntry({
    required this.timestamp,
    required this.type,
    this.tableName,
    required this.message,
    this.isSuccess = true,
  });

  factory SyncLogEntry.tablePush(String tableName, int count) {
    return SyncLogEntry(
      timestamp: DateTime.now(),
      type: 'push_table',
      tableName: tableName,
      message: '$count records pushed',
    );
  }

  factory SyncLogEntry.tablePull(String tableName, int count) {
    return SyncLogEntry(
      timestamp: DateTime.now(),
      type: 'pull_table',
      tableName: tableName,
      message: '$count records pulled',
    );
  }

  factory SyncLogEntry.pushDone(int totalTables) {
    return SyncLogEntry(
      timestamp: DateTime.now(),
      type: 'push_done',
      message: 'Push selesai ($totalTables tabel)',
    );
  }

  factory SyncLogEntry.pullDone(int totalTables) {
    return SyncLogEntry(
      timestamp: DateTime.now(),
      type: 'pull_done',
      message: 'Pull selesai ($totalTables tabel)',
    );
  }

  factory SyncLogEntry.error(String error) {
    return SyncLogEntry(
      timestamp: DateTime.now(),
      type: 'error',
      message: error,
      isSuccess: false,
    );
  }

  @override
  List<Object?> get props => [timestamp, type, tableName, message, isSuccess];
}

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SupabaseSyncService _syncService;
  final Connectivity _connectivity;
  StreamSubscription? _connectivitySub;
  Timer? _periodicTimer;
  Timer? _retryTimer;
  final List<SyncLogEntry> _logs = [];
  int _syncAttempts = 0;
  DateTime? _lastSync;

  SyncBloc({
    required SupabaseSyncService syncService,
    required Connectivity connectivity,
  })  : _syncService = syncService,
        _connectivity = connectivity,
        super(const SyncInitial()) {
    on<SyncTriggered>(_onSyncTriggered);
    on<SyncStatusChanged>(_onSyncStatusChanged);
    on<InitialSyncTriggered>(_onInitialSyncTriggered);
    on<ClearSyncError>(_onClearError);

    _init();
  }

  void _init() {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((result) {
      final online = result.any((r) => r != ConnectivityResult.none);
      add(SyncStatusChanged(online));
    });
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => add(const SyncTriggered()),
    );
  }

  void _addLog(SyncLogEntry entry) {
    _logs.insert(0, entry);
    if (_logs.length > 200) _logs.removeLast();
  }

  Future<void> _onSyncTriggered(
    SyncTriggered event,
    Emitter<SyncState> emit,
  ) async {
    final current = state;
    final online = current is SyncInitial
        ? _syncAttempts == 0
        : (current is SyncIdle
            ? current.isOnline
            : current is SyncError
                ? current.isOnline
                : (current as dynamic).isOnline ?? false);

    if (!online) {
      _addLog(SyncLogEntry.error('Tidak ada koneksi internet'));
      emit(SyncError(
        message: 'Tidak ada koneksi internet',
        isOnline: false,
        lastSync: _lastSync,
        logs: List.of(_logs),
      ));
      _scheduleRetry(emit);
      return;
    }

    emit(SyncInProgress(isOnline: online, logs: List.of(_logs)));

    try {
      // Flush antrian operasi offline
      final flushed = await _syncService.flushQueue();
      if (flushed > 0) {
        _addLog(SyncLogEntry.tablePush('queue', flushed));
        _addLog(SyncLogEntry.pushDone(1));
      }
      emit(SyncInProgress(isOnline: online, logs: List.of(_logs)));

      // Pull perubahan dari Supabase
      final pullResults = await _syncService.pull(
        onTablePulled: (table, count) {
          _addLog(SyncLogEntry.tablePull(table, count));
        },
      );
      _addLog(SyncLogEntry.pullDone(pullResults.length));
      emit(SyncInProgress(isOnline: online, logs: List.of(_logs)));

      _syncAttempts = 0;
      _lastSync = DateTime.now();
      emit(SyncSuccess(
        isOnline: online,
        lastSync: _lastSync!,
        logs: List.of(_logs),
      ));
    } catch (e) {
      _syncAttempts++;
      _addLog(SyncLogEntry.error(e.toString()));
      emit(SyncError(
        message: e.toString(),
        isOnline: online,
        lastSync: _lastSync,
        logs: List.of(_logs),
      ));
      _scheduleRetry(emit);
    }
  }

  void _scheduleRetry(Emitter<SyncState> emit) {
    _retryTimer?.cancel();
    if (_syncAttempts >= 10) return; // max 10 retry

    final delay = Duration(seconds: min(pow(2, _syncAttempts).toInt(), 60));
    _retryTimer = Timer(delay, () {
      if (!isClosed) add(const SyncTriggered());
    });
  }

  @override
  void onEvent(SyncEvent event) {
    // Reset retry count for user-triggered or connectivity-triggered events
    if (event is SyncTriggered || event is SyncStatusChanged) {
      _retryTimer?.cancel();
    }
    // Reset retry count on successful connectivity
    if (event is SyncStatusChanged && event.isOnline) {
      _syncAttempts = 0;
    }
    super.onEvent(event);
  }

  Future<void> _onInitialSyncTriggered(
    InitialSyncTriggered event,
    Emitter<SyncState> emit,
  ) async {
    emit(const InitialSyncInProgress(phase: 'counting'));

    try {
      await _syncService.performInitialSync(
        onProgress: (fetched, total) {
          if (!isClosed) {
            emit(InitialSyncInProgress(
              fetched: fetched,
              total: total,
              phase: fetched < total ? 'downloading' : 'inserting',
            ));
          }
        },
      );

      emit(const InitialSyncInProgress(
        fetched: 0,
        total: 0,
        phase: 'done',
      ));
    } catch (e) {
      _addLog(SyncLogEntry.error(e.toString()));
      emit(const InitialSyncInProgress(phase: 'done'));
    }
  }

  Future<bool> get isInitialSyncDone => _syncService.isInitialSyncDone;

  Future<void> _onSyncStatusChanged(
    SyncStatusChanged event,
    Emitter<SyncState> emit,
  ) async {
    if (event.isOnline) {
      _syncAttempts = 0;
      add(const SyncTriggered());
    }
    if (state is SyncInitial) {
      emit(SyncIdle(isOnline: event.isOnline, lastSync: _lastSync));
    }
    // Update isOnline on current state for UI
    if (state is SyncIdle && !event.isOnline) {
      emit(SyncIdle(isOnline: false, lastSync: _lastSync));
    }
  }

  Future<void> _onClearError(
    ClearSyncError event,
    Emitter<SyncState> emit,
  ) async {
    emit(SyncIdle(
      isOnline: await _syncService.isOnline,
      lastSync: _lastSync,
      logs: List.of(_logs),
    ));
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    _periodicTimer?.cancel();
    _retryTimer?.cancel();
    return super.close();
  }
}
