import 'package:equatable/equatable.dart';

abstract class LocalAuthEvent extends Equatable {
  const LocalAuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckPinEvent extends LocalAuthEvent {
  final String userId;
  const CheckPinEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SetPinEvent extends LocalAuthEvent {
  final String userId;
  final String pin;
  const SetPinEvent(this.userId, this.pin);

  @override
  List<Object?> get props => [userId, pin];
}

class VerifyPinEvent extends LocalAuthEvent {
  final String userId;
  final String pin;
  const VerifyPinEvent(this.userId, this.pin);

  @override
  List<Object?> get props => [userId, pin];
}

class RemovePinEvent extends LocalAuthEvent {
  final String userId;
  const RemovePinEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class BiometricLoginEvent extends LocalAuthEvent {
  final String userId;
  const BiometricLoginEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleBiometricEvent extends LocalAuthEvent {
  final String userId;
  final bool enabled;
  const ToggleBiometricEvent(this.userId, this.enabled);

  @override
  List<Object?> get props => [userId, enabled];
}

class ResetPinByOwnerEvent extends LocalAuthEvent {
  final String userId;
  final String newPin;
  const ResetPinByOwnerEvent(this.userId, this.newPin);

  @override
  List<Object?> get props => [userId, newPin];
}
