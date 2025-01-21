import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String role;

  SignupEvent(this.email, this.password, this.role);

  @override
  List<Object?> get props => [email, password, role];
}

class CheckUserRoleEvent extends AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

