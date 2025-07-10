import 'package:equatable/equatable.dart';

abstract class LearningEvent extends Equatable {
  const LearningEvent();

  @override
  List<Object?> get props => [];
}

class FetchLearningEvent extends LearningEvent {}
