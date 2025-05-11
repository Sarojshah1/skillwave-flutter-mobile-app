part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final bool isAuthenticated;

  const LoginSuccess({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}

class SignupSuccess extends AuthState {
  final bool isRegistered;

  const SignupSuccess({required this.isRegistered});

  @override
  List<Object?> get props => [isRegistered];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
