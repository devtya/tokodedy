import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/services/toko_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final TokoService tokoService;

  AuthBloc({required this.authRepository, required this.tokoService})
      : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterStoreEvent>(_onRegisterStore);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
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
      final user =
          await authRepository.login(event.usernameOrEmail, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Username atau password salah!'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      await tokoService.clear();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterStore(
    RegisterStoreEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.registerStore(
        namaToko: event.namaToko,
        alamat: event.alamat,
        email: event.email,
        password: event.password,
        nama: event.nama,
      );
      emit(StoreRegistered(user));
      // Emit Authenticated setelah StoreRegistered agar semua page yang
      // mengecek `authState is Authenticated` langsung mendapat role yang benar.
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
