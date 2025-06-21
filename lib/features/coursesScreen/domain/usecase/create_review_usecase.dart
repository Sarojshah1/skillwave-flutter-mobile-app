import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart';

@lazySingleton
class CreateReviewUseCase {
  final CourseRepository repository;

  CreateReviewUseCase(this.repository);

  Future<SkillWaveResponse<bool>> call({
    required String courseId,
    required int rating,
    required String comment,
  }) async {
    try {
      final result = await repository.createReview(
        courseId: courseId,
        rating: rating,
        comment: comment,
      );
      return SkillWaveResponse.success(result);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
