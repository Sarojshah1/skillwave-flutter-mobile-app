import 'package:equatable/equatable.dart';
import '../../../domin/entity/post_entity.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostLoaded extends CreatePostState {
  final PostEntity post;

  const CreatePostLoaded({required this.post});

  @override
  List<Object?> get props => [post];
}

class CreatePostError extends CreatePostState {
  final String message;

  const CreatePostError({required this.message});

  @override
  List<Object?> get props => [message];
}
