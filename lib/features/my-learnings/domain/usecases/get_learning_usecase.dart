import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';
import 'package:skillwave/features/my-learnings/domain/repository/learning_repository.dart';

@lazySingleton
class GetLearningUseCase {
  final LearningRepository repository;

  GetLearningUseCase(this.repository);

  Future<SkillWaveResponse<List<EnrollmentEntity>>> call() async {
    try {
      final result = await repository.getLearning();
      return SkillWaveResponse.success(result);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
