import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    try {
      // Validasi session Supabase dulu (cek apakah token masih valid)
      final user = await authRepository.fetchCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
        return;
      }
    } catch (_) {
      // Network error — fallback ke cache lokal
    }

    // Fallback: cache lokal (offline mode)
    try {
      final user = authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository
          .login(event.usernameOrEmail, event.password)
          .timeout(const Duration(seconds: 30));
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Username atau password salah!'));
      }
    } on TimeoutException {
      emit(const AuthError(
        'Koneksi lambat. Periksa internet Anda dan coba lagi.',
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
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
