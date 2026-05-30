import 'package:equatable/equatable.dart';

abstract class LocalAuthState extends Equatable {
  const LocalAuthState();

  @override
  List<Object?> get props => [];
}

class LocalAuthInitial extends LocalAuthState {}

class LocalAuthLoading extends LocalAuthState {}

class PinNotSet extends LocalAuthState {}

class PinReady extends LocalAuthState {
  final bool biometricAvailable;
  final bool biometricEnabled;
  final bool isLockedOut;
  final int failedAttempts;
  final DateTime? lockoutUntil;

  const PinReady({
    this.biometricAvailable = false,
    this.biometricEnabled = false,
    this.isLockedOut = false,
    this.failedAttempts = 0,
    this.lockoutUntil,
  });

  @override
  List<Object?> get props => [
        biometricAvailable,
        biometricEnabled,
        isLockedOut,
        failedAttempts,
        lockoutUntil,
      ];
}

class PinVerified extends LocalAuthState {}

class PinSetSuccess extends LocalAuthState {}

class PinRemoved extends LocalAuthState {}

class PinError extends LocalAuthState {
  final String message;
  const PinError(this.message);

  @override
  List<Object?> get props => [message];
}
