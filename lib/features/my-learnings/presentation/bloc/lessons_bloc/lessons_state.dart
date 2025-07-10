import 'package:equatable/equatable.dart';
// import 'package:skillwave/features/my-learnings/domain/entity/lesson_entity.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();

  @override
  List<Object?> get props => [];
}

class LessonsInitial extends LessonsState {}

class LessonsLoading extends LessonsState {}

class LessonsLoaded extends LessonsState {
  final List<dynamic> lessons; 
  const LessonsLoaded(this.lessons);

  @override
  List<Object?> get props => [lessons];
}

class LessonsFailure extends LessonsState {
  final String message;
  const LessonsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
