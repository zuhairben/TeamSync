import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:firebase_flutter/auth/AuthService.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      final result = await _authService.login(
        email: event.email,
        password: event.password,
      );
      if (result == "Success") {
        emit(AuthSuccessState());
      } else {
        emit(AuthFailureState(result ?? 'Error during login'));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoadingState());
      final result = await _authService.registration(
        email: event.email,
        password: event.password,
        role: event.role,
      );
      if (result == "Success") {
        emit(AuthSuccessState());
      } else {
        emit(AuthFailureState(result ?? 'Error during signup'));
      }
    });

    on<CheckUserRoleEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final role = await _authService.getUserRole();
        emit(UserRoleState(role));
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final userCredential = await _authService.signInWithGoogle();
        emit(AuthSuccessState());
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await _authService.logout();
        emit(AuthInitialState()); // Return to initial state after logout
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });
  }
}
