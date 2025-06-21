import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePicture;
  final String bio;
  final List<String> enrolledCourses;
  final List<String> payments;
  final List<String> blogPosts;
  final List<String> quizResults;
  final List<String> reviews;
  final List<String> certificates;
  final List<String> searchHistory;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.bio,
    required this.enrolledCourses,
    required this.payments,
    required this.blogPosts,
    required this.quizResults,
    required this.reviews,
    required this.certificates,
    required this.searchHistory,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    profilePicture,
    bio,
    enrolledCourses,
    payments,
    blogPosts,
    quizResults,
    reviews,
    certificates,
    searchHistory,
    createdAt,
  ];
}

class ReviewEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String courseId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.user,
    required this.courseId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, user, courseId, rating, comment, createdAt];
}
