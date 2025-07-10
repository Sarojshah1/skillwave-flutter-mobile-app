import 'package:equatable/equatable.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';

abstract class LearningState extends Equatable {
  const LearningState();

  @override
  List<Object?> get props => [];
}

class LearningInitial extends LearningState {}

class LearningLoading extends LearningState {}

class LearningLoaded extends LearningState {
  final List<EnrollmentEntity> learnings;
  const LearningLoaded(this.learnings);

  @override
  List<Object?> get props => [learnings];
}

class LearningFailure extends LearningState {
  final String message;
  const LearningFailure(this.message);

  @override
  List<Object?> get props => [message];
}
