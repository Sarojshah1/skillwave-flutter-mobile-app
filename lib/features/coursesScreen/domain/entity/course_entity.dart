import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final CreatedByEntity createdBy;
  final CategoryEntity category;
  final int price;
  final String duration;
  final String level;
  final String thumbnail;
  final List<LessonEntity> lessons;
  final List<dynamic> quizzes;
  final List<dynamic> reviews;
  final List<dynamic> certificates;
  final DateTime createdAt;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.category,
    required this.price,
    required this.duration,
    required this.level,
    required this.thumbnail,
    required this.lessons,
    required this.quizzes,
    required this.reviews,
    required this.certificates,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdBy,
    category,
    price,
    duration,
    level,
    thumbnail,
    lessons,
    quizzes,
    reviews,
    certificates,
    createdAt,
  ];
}

class CreatedByEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String profilePicture;
  final String bio;
  final List<String> enrolledCourses;
  final List<String> payments;
  final List<dynamic> blogPosts;
  final List<dynamic> quizResults;
  final List<dynamic> reviews;
  final List<dynamic> certificates;
  final DateTime createdAt;
  final List<String> searchHistory;

  const CreatedByEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.profilePicture,
    required this.bio,
    required this.enrolledCourses,
    required this.payments,
    required this.blogPosts,
    required this.quizResults,
    required this.reviews,
    required this.certificates,
    required this.createdAt,
    required this.searchHistory,
  });

  @override
  List<Object?> get props => [id, name, email];
}

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name];
}

class LessonEntity extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final String videoUrl;
  final int order;
  final int? v; // optional __v field

  const LessonEntity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.videoUrl,
    required this.order,
    this.v,
  });

  @override
  List<Object?> get props =>
      [id, courseId, title, content, videoUrl, order, v];
}
