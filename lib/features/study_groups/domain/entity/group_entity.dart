import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String groupName;
  final String groupImage;
  final String description;
  final UserEntity createdBy;
  final List<UserEntity> members;
  final DateTime createdAt;

  const GroupEntity({
    required this.id,
    required this.groupName,
    required this.groupImage,
    required this.description,
    required this.createdBy,
    required this.members,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, groupName, groupImage, description, createdBy, members, createdAt];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String profilePicture;

  const UserEntity({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  @override
  List<Object> get props => [id, name, profilePicture];
}
