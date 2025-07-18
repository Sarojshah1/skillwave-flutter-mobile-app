import 'dart:io';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';

abstract class GroupStudyRepository {
  Future<GroupEntity> createGroup({
    required String groupName,
    required File groupImage,
    required String description,
  });

  Future<List<GroupEntity>> getAllGroups();
  Future<List<GroupEntity>> getUserGroups();
}
