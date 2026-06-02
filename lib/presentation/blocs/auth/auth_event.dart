import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String usernameOrEmail;
  final String password;

  const LoginEvent(this.usernameOrEmail, this.password);

  @override
  List<Object?> get props => [usernameOrEmail, password];
}

class LogoutEvent extends AuthEvent {}
