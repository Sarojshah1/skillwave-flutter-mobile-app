part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final SignUpEntity user;
  final File? profilePicture;

  const SignUpRequested({required this.user, this.profilePicture});

  @override
  List<Object?> get props => [user, profilePicture];
}

class LogInRequested extends AuthEvent {
  final LogInEntity entity;

  const LogInRequested({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class SendOtpEvent extends AuthEvent{
  final String email;
  const SendOtpEvent({required this.email});
  @override
  List<Object?> get props =>[email];

}
