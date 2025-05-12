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

class SendOtpState extends AuthState{
  final String messgae;
  const SendOtpState({required this.messgae});
  @override
  List<Object?> get props =>[messgae];
}

class VerifyOtpState extends AuthState{
  final String messgae;
  const VerifyOtpState({required this.messgae});
  @override
  List<Object?> get props =>[messgae];
}

class ForgetPasswordState extends AuthState{
  final String messgae;
  const ForgetPasswordState({required this.messgae});
  @override
  List<Object?> get props =>[messgae];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
