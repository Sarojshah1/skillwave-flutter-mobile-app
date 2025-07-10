import 'package:equatable/equatable.dart';

abstract class LessonsEvent extends Equatable {
  const LessonsEvent();

  @override
  List<Object?> get props => [];
}

class FetchLessonsEvent extends LessonsEvent {
  final String courseId;
  const FetchLessonsEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
