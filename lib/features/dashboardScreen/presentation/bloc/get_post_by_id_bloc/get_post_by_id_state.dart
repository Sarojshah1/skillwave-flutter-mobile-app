import 'package:equatable/equatable.dart';
import '../../../domin/entity/post_entity.dart';

abstract class GetPostByIdState extends Equatable {
  const GetPostByIdState();

  @override
  List<Object?> get props => [];
}

class GetPostByIdInitial extends GetPostByIdState {}

class GetPostByIdLoading extends GetPostByIdState {}

class GetPostByIdLoaded extends GetPostByIdState {
  final PostEntity post;

  const GetPostByIdLoaded({required this.post});

  @override
  List<Object?> get props => [post];
}

class GetPostByIdError extends GetPostByIdState {
  final String message;

  const GetPostByIdError({required this.message});

  @override
  List<Object?> get props => [message];
}
