import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_dto.freezed.dart';
part 'post_dto.g.dart';

@freezed
class CreatePostDto with _$CreatePostDto {
  const factory CreatePostDto({
    required String title,
    required String content,
    required List<String> images,
    required List<String> tags,
    required String category,
  }) = _CreatePostDto;

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);
}

@freezed
class UpdatePostDto with _$UpdatePostDto {
  const factory UpdatePostDto({
    required String title,
    required String content,
    required List<String> images,
    required List<String> tags,
    required String category,
  }) = _UpdatePostDto;

  factory UpdatePostDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostDtoFromJson(json);
}

@freezed
class CreateCommentDto with _$CreateCommentDto {
  const factory CreateCommentDto({required String content}) = _CreateCommentDto;

  factory CreateCommentDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentDtoFromJson(json);
}

@freezed
class CreateReplyDto with _$CreateReplyDto {
  const factory CreateReplyDto({required String content}) = _CreateReplyDto;

  factory CreateReplyDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReplyDtoFromJson(json);
}

@freezed
class GetPostsDto with _$GetPostsDto {
  const factory GetPostsDto({
    @Default(1) int page,
    @Default(3) int limit,
    String? category,
    String? search,
    List<String>? tags,
  }) = _GetPostsDto;

  factory GetPostsDto.fromJson(Map<String, dynamic> json) =>
      _$GetPostsDtoFromJson(json);
}

@freezed
class LikePostDto with _$LikePostDto {
  const factory LikePostDto({required String postId}) = _LikePostDto;

  factory LikePostDto.fromJson(Map<String, dynamic> json) =>
      _$LikePostDtoFromJson(json);
}

@freezed
class UnlikePostDto with _$UnlikePostDto {
  const factory UnlikePostDto({required String postId}) = _UnlikePostDto;

  factory UnlikePostDto.fromJson(Map<String, dynamic> json) =>
      _$UnlikePostDtoFromJson(json);
}

@freezed
class PostFilterDto with _$PostFilterDto {
  const factory PostFilterDto({
    String? category,
    String? search,
    List<String>? tags,
    String? sortBy,
    String? sortOrder,
  }) = _PostFilterDto;

  factory PostFilterDto.fromJson(Map<String, dynamic> json) =>
      _$PostFilterDtoFromJson(json);
}
