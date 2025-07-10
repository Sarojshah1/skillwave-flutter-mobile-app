import 'package:equatable/equatable.dart';

class EnrollmentEntity extends Equatable {
  final String id;
  final String userId;
  final CourseEntity course;
  final String status;
  final int progress;
  final DateTime enrollmentDate;

  const EnrollmentEntity({
    required this.id,
    required this.userId,
    required this.course,
    required this.status,
    required this.progress,
    required this.enrollmentDate,
  });

  @override
  List<Object?> get props => [id, userId, course, status, progress, enrollmentDate];
}

class CourseEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String categoryId;
  final int price;
  final String duration;
  final String level;
  final String thumbnail;
  final List<String> lessons;
  final List<String> quizzes;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.categoryId,
    required this.price,
    required this.duration,
    required this.level,
    required this.thumbnail,
    required this.lessons,
    required this.quizzes,
  });

  @override
  List<Object?> get props => [id, title, description, createdBy, categoryId, price, duration, level, thumbnail, lessons, quizzes];
}
