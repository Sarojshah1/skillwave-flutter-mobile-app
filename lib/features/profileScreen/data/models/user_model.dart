import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';


part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: "_id") required String id,
    required String name,
    required String email,
    required String role,
    required String bio,
    @JsonKey(name: "profile_picture") required String profilePicture,
    @Default([]) List<String> enrolledCourses,
    @Default([]) List<String> certificates,
    @JsonKey(name: "created_at") required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    role: role,
    bio: bio,
    profilePicture: profilePicture,
    enrolledCourses: enrolledCourses,
    certificates: certificates,
    createdAt: createdAt,
  );
}
