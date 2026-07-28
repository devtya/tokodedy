import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository})
      : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Phase 1 — local cache dulu (instant, tanpa network)
    User? localUser;
    try {
      localUser = authRepository.getCurrentUser();
      if (localUser != null) {
        emit(Authenticated(localUser));
      }
    } catch (_) {}

    // Phase 2 — validasi/refresh dari Supabase (non-blocking, timeout pendek)
    try {
      final freshUser = await authRepository
          .fetchCurrentUser()
          .timeout(const Duration(seconds: 5));
      if (freshUser != null) {
        emit(Authenticated(freshUser));
        return;
      }
    } on TimeoutException {
      if (kDebugMode) debugPrint('[AuthBloc] fetchCurrentUser timed out — offline');
    } catch (e, stack) {
      if (kDebugMode) debugPrint('[AuthBloc] checkAuth error: $e\n$stack');
    }

    // Jika sudah punya localUser, biarkan tetap Authenticated (offline mode)
    if (localUser != null) return;

    // Tidak ada data sama sekali → unauthenticated
    emit(Unauthenticated());
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    if (kDebugMode) debugPrint('[AuthBloc] _onLogin START | usernameOrEmail="${event.usernameOrEmail}" | password.length=${event.password.length}');
    emit(AuthLoading());
    try {
      if (kDebugMode) debugPrint('[AuthBloc] Calling authRepository.login() ...');
      final user = await authRepository
          .login(event.usernameOrEmail, event.password)
          .timeout(const Duration(seconds: 30));
      if (kDebugMode) debugPrint('[AuthBloc] authRepository.login() returned: ${user != null ? "User(${user.nama}, ${user.email})" : "null"}');
      if (user != null) {
        if (kDebugMode) debugPrint('[AuthBloc] Emitting Authenticated');
        emit(Authenticated(user));
      } else {
        if (kDebugMode) debugPrint('[AuthBloc] login returned null → emitting AuthError');
        emit(const AuthError('Username atau password salah!'));
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) debugPrint('[AuthBloc] TIMEOUT after 30s: $e');
      emit(const AuthError(
        'Koneksi lambat. Periksa internet Anda dan coba lagi.',
      ));
    } catch (e, stack) {
      if (kDebugMode) debugPrint('[AuthBloc] EXCEPTION: $e');
      if (kDebugMode) debugPrint('[AuthBloc] STACKTRACE: $stack');
      emit(AuthError(e.toString()));
    }
    if (kDebugMode) debugPrint('[AuthBloc] _onLogin END');
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

}
