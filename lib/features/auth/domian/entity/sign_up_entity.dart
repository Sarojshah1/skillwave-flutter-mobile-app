
import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  final String name;
  final String email;
  final String password;
  final String role;
  final String bio;

  const SignUpEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.bio,
  });
  @override
  List<Object?> get props => [
    name,
    email,
    password,
    role,
    bio,
  ];
}
