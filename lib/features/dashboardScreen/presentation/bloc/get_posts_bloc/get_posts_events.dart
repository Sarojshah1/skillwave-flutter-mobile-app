import 'package:equatable/equatable.dart';
import '../../../data/models/post_dto.dart';

abstract class GetPostsEvents extends Equatable {
  const GetPostsEvents();

  @override
  List<Object?> get props => [];
}

class GetPosts extends GetPostsEvents {
  final GetPostsDto dto;

  const GetPosts(this.dto);

  @override
  List<Object?> get props => [dto];
}

class RefreshPosts extends GetPostsEvents {
  final GetPostsDto dto;

  const RefreshPosts(this.dto);

  @override
  List<Object?> get props => [dto];
}

class LoadMorePosts extends GetPostsEvents {
  final GetPostsDto dto;

  const LoadMorePosts(this.dto);

  @override
  List<Object?> get props => [dto];
}
