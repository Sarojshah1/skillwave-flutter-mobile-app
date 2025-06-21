import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart';

@lazySingleton
class GetCoursesUseCase {
  final CourseRepository repository;

  GetCoursesUseCase(this.repository);

  Future<SkillWaveResponse<List<CourseEntity>>> call({
    required int page,
    required int limit,
  }) async {
    try {
      final courses = await repository.getCourses(page: page, limit: limit);
      return SkillWaveResponse.success(courses);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
