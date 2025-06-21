part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {
  final int page;
  final int limit;

  const LoadCourses({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}
class LoadCourseById extends CourseEvent {
  final String courseId;

  const LoadCourseById(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class CreatePayment extends CourseEvent {
  final String courseId;
  final int amount;
  final String paymentMethod;
  final String status;

  const CreatePayment({
    required this.courseId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
  });

  @override
  List<Object?> get props => [courseId, amount, paymentMethod, status];
}

class CreateReview extends CourseEvent {
  final String courseId;
  final int rating;
  final String comment;

  const CreateReview({
    required this.courseId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [courseId, rating, comment];
}
