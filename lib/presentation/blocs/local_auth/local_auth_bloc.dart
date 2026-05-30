import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/local_auth_repository.dart';
import 'local_auth_event.dart';
import 'local_auth_state.dart';

@injectable
class LocalAuthBloc extends Bloc<LocalAuthEvent, LocalAuthState> {
  final LocalAuthRepository _repo;

  LocalAuthBloc(this._repo) : super(LocalAuthInitial()) {
    on<CheckPinEvent>(_onCheckPin);
    on<SetPinEvent>(_onSetPin);
    on<VerifyPinEvent>(_onVerifyPin);
    on<RemovePinEvent>(_onRemovePin);
    on<BiometricLoginEvent>(_onBiometricLogin);
    on<ToggleBiometricEvent>(_onToggleBiometric);
    on<ResetPinByOwnerEvent>(_onResetPinByOwner);
  }

  Future<void> _onCheckPin(
    CheckPinEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    try {
      final hasPin = await _repo.hasPin(event.userId);
      if (!hasPin) {
        emit(PinNotSet());
        return;
      }

      final bioAvail = await _repo.isBiometricAvailable();
      final bioEnabled = bioAvail && await _repo.isBiometricEnabled(event.userId);
      final lockoutUntil = await _repo.getLockoutUntil(event.userId);
      final locked = _repo.isLockedOut(lockoutUntil);
      final attempts = await _repo.getFailedAttempts(event.userId);

      emit(PinReady(
        biometricAvailable: bioAvail,
        biometricEnabled: bioEnabled,
        isLockedOut: locked,
        failedAttempts: attempts,
        lockoutUntil: lockoutUntil,
      ));
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }

  Future<void> _onSetPin(
    SetPinEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    try {
      await _repo.setPin(event.userId, event.pin);
      emit(PinSetSuccess());
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }

  Future<void> _onVerifyPin(
    VerifyPinEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    try {
      final valid = await _repo.verifyPin(event.userId, event.pin);
      if (valid) {
        emit(PinVerified());
      } else {
        final lockoutUntil = await _repo.getLockoutUntil(event.userId);
        final locked = _repo.isLockedOut(lockoutUntil);
        final attempts = await _repo.getFailedAttempts(event.userId);

        if (locked) {
          emit(PinError('Terlalu banyak percobaan. Tunggu 30 detik.'));
        } else {
          emit(PinError('PIN salah. Sisa percobaan: ${5 - attempts}'));
        }
      }
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }

  Future<void> _onRemovePin(
    RemovePinEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    try {
      await _repo.removePin(event.userId);
      emit(PinRemoved());
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }

  Future<void> _onBiometricLogin(
    BiometricLoginEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    try {
      final authenticated = await _repo.authenticateWithBiometrics();
      if (authenticated) {
        await _repo.resetAttempts(event.userId);
        emit(PinVerified());
      } else {
        emit(PinError('Verifikasi sidik jari gagal'));
      }
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }

  Future<void> _onToggleBiometric(
    ToggleBiometricEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    try {
      if (event.enabled) {
        await _repo.enableBiometric(event.userId);
      } else {
        await _repo.disableBiometric(event.userId);
      }
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }

  Future<void> _onResetPinByOwner(
    ResetPinByOwnerEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(LocalAuthLoading());
    try {
      await _repo.removePin(event.userId);
      await _repo.setPin(event.userId, event.newPin);
      emit(PinSetSuccess());
    } catch (e) {
      emit(PinError(e.toString()));
    }
  }
}
