import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String bio;
  final String profilePicture;
  final List<String> enrolledCourses;
  final List<String> certificates;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    required this.profilePicture,
    required this.enrolledCourses,
    required this.certificates,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    bio,
    profilePicture,
    enrolledCourses,
    certificates,
    createdAt,
  ];
}
