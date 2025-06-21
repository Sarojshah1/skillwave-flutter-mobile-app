part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseEntity> courses;
  final bool hasReachedMax;

  const CourseLoaded({required this.courses, this.hasReachedMax = false});

  @override
  List<Object?> get props => [courses, hasReachedMax];
}

class CourseError extends CourseState {
  final Failure failure;

  const CourseError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class CourseByIdLoaded extends CourseState {
  final CourseEntity course;

  const CourseByIdLoaded({required this.course});

  @override
  List<Object?> get props => [course];
}

class PaymentSuccess extends CourseState {

}
