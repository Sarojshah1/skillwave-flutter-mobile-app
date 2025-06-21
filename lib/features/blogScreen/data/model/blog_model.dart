import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';

part 'blog_model.freezed.dart';
part 'blog_model.g.dart';

@freezed
class BlogModel with _$BlogModel {
  const factory BlogModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required UserModel user,
    required String title,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required List<String> tags,
  }) = _BlogModel;

  factory BlogModel.fromJson(Map<String, dynamic> json) => _$BlogModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'profile_picture') required String profilePicture,
    required String bio,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
extension BlogModelMapper on BlogModel {
  BlogEntity toEntity() {
    return BlogEntity(
      id: id,
      user: user.toEntity(),
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
    );
  }
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      profilePicture: profilePicture,
      bio: bio,
    );
  }
}