import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';


part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'group_name') required String groupName,
    @JsonKey(name: 'group_image') required String groupImage,
    required String description,
    @JsonKey(name: 'created_by') required UserModel createdBy,
    required List<UserModel> members,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    @JsonKey(name: 'profile_picture') required String profilePicture,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension GroupModelX on GroupModel {
  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      groupName: groupName,
      groupImage: groupImage,
      description: description,
      createdBy: createdBy.toEntity(),
      members: members.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      profilePicture: profilePicture,
    );
  }
}