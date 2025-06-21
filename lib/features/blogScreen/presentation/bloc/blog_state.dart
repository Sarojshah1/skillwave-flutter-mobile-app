part of 'blog_bloc.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<BlogEntity> blogs;
  final bool hasReachedMax;

  const BlogLoaded({required this.blogs, this.hasReachedMax = false});

  @override
  List<Object?> get props => [blogs,hasReachedMax];
}

class BlogError extends BlogState {
  final Failure failure;

  const BlogError(this.failure);

  @override
  List<Object?> get props => [failure];
}
