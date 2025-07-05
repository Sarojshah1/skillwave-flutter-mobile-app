import 'package:equatable/equatable.dart';
import '../../../domin/entity/post_entity.dart';

abstract class GetPostsState extends Equatable {
  const GetPostsState();

  @override
  List<Object?> get props => [];
}

class GetPostsInitial extends GetPostsState {}

class GetPostsLoading extends GetPostsState {}

class GetPostsLoadingMore extends GetPostsState {
  final PostsResponseEntity posts;

  const GetPostsLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}

class GetPostsLoaded extends GetPostsState {
  final PostsResponseEntity posts;

  const GetPostsLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class GetPostsError extends GetPostsState {
  final String message;

  const GetPostsError({required this.message});

  @override
  List<Object?> get props => [message];
}
