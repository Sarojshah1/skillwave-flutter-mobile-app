import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_study_repository.dart';

@lazySingleton
class CreateGroupUseCase {
  final GroupStudyRepository repository;
  CreateGroupUseCase(this.repository);

  Future<SkillWaveResponse<GroupEntity>> call({
    required String groupName,
    required File groupImage,
    required String description,
  }) async {
    try {
      final group = await repository.createGroup(
        groupName: groupName,
        groupImage: groupImage,
        description: description,

      );
      return SkillWaveResponse.success(group);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
