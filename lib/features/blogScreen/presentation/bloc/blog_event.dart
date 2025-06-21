part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class LoadBlogs extends BlogEvent {
  final int page;
  final int limit;

  const LoadBlogs({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}
