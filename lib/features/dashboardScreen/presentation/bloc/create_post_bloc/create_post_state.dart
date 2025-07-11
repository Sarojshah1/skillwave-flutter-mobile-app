import 'package:equatable/equatable.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostLoaded extends CreatePostState {
  final String message;

  const CreatePostLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}

class CreatePostError extends CreatePostState {
  final String message;

  const CreatePostError({required this.message});

  @override
  List<Object?> get props => [message];
}
