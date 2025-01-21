import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;

  AuthFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class UserRoleState extends AuthState {
  final String role;

  UserRoleState(this.role);

  @override
  List<Object?> get props => [role];
}
