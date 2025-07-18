import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/features/study_groups/domain/repository/group_study_repository.dart';

@lazySingleton
class GetUserGroupsUseCase {
  final GroupStudyRepository repository;
  GetUserGroupsUseCase(this.repository);

  Future<SkillWaveResponse<List<GroupEntity>>> call() async {
    try {
      final groups = await repository.getUserGroups();
      return SkillWaveResponse.success(groups);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
