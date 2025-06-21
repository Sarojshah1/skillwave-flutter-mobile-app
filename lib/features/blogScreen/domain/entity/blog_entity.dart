import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  const BlogEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, user, title, content, createdAt, updatedAt, tags];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePicture;
  final String bio;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.bio,
  });

  @override
  List<Object?> get props => [id, name, email, role, profilePicture, bio];
}
