import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart';

@lazySingleton
class GetReviewsByCourseIdUseCase {
  final CourseRepository repository;

  GetReviewsByCourseIdUseCase(this.repository);

  Future<SkillWaveResponse<List<ReviewEntity>>> call(String courseId) async {
    print("call from usecase");
    try {
      final result = await repository.getReviewsByCourseId(courseId);
      print(result);
      return SkillWaveResponse.success(result);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
