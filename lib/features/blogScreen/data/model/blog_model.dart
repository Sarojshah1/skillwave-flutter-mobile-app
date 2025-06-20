import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/features/profileScreen/data/models/user_model.dart';

part 'blog_model.freezed.dart';
part 'blog_model.g.dart';

@freezed
class BlogModel with _$BlogModel {
  const factory BlogModel({
    required String id,
    required UserModel userId,
    required String title,
    required String content,
    required List<String> tags,
    required DateTime createdAt,
  }) = _BlogModel;

  /// From JSON
  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);


  const BlogModel._();

  BlogEntity toEntity() => BlogEntity(
    id: id,
    userId: userId,
    title: title,
    content: content,
    tags: tags,
    createdAt: createdAt,
  );
  
  factory BlogModel.fromEntity(BlogEntity entity) => BlogModel(
    id: entity.id,
    userId: entity.userId,
    title: entity.title,
    content: entity.content,
    tags: entity.tags,
    createdAt: entity.createdAt,
  );
}
