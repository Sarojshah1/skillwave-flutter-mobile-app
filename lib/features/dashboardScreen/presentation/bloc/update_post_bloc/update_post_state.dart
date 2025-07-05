import 'package:equatable/equatable.dart';
import '../../../domin/entity/post_entity.dart';

abstract class UpdatePostState extends Equatable {
  const UpdatePostState();

  @override
  List<Object?> get props => [];
}

class UpdatePostInitial extends UpdatePostState {}

class UpdatePostLoading extends UpdatePostState {}

class UpdatePostLoaded extends UpdatePostState {
  final PostEntity post;

  const UpdatePostLoaded({required this.post});

  @override
  List<Object?> get props => [post];
}

class UpdatePostError extends UpdatePostState {
  final String message;

  const UpdatePostError({required this.message});

  @override
  List<Object?> get props => [message];
}
