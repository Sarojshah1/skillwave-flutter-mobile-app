import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/study_groups/data/datasource/group_study_datasource.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_study_repository.dart';

@LazySingleton(as: GroupStudyRepository)
class GroupStudyRepositoryImpl implements GroupStudyRepository {
  final GroupStudyDatasource datasource;

  GroupStudyRepositoryImpl(this.datasource);

  @override
  Future<GroupEntity> createGroup({
    required String groupName,
    required File groupImage,
    required String description,
  }) {
    return datasource.createGroup(
      groupName: groupName,
      groupImage: groupImage,
      description: description,
    );
  }

  @override
  Future<List<GroupEntity>> getAllGroups() {
    return datasource.getAllGroups();
  }

  @override
  Future<List<GroupEntity>> getUserGroups() {
    return datasource.getUserGroups();
  }
}
