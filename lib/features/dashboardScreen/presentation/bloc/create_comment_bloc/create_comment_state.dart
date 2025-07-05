import 'package:equatable/equatable.dart';

abstract class CreateCommentState extends Equatable {
  const CreateCommentState();

  @override
  List<Object?> get props => [];
}

class CreateCommentInitial extends CreateCommentState {}

class CreateCommentLoading extends CreateCommentState {}

class CreateCommentLoaded extends CreateCommentState {}

class CreateCommentError extends CreateCommentState {
  final String message;

  const CreateCommentError({required this.message});

  @override
  List<Object?> get props => [message];
}
