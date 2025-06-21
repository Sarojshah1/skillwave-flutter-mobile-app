import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/data/model/course_model.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart';

@lazySingleton
class GetCourseByIdUseCase {
  final CourseRepository repository;

  GetCourseByIdUseCase(this.repository);

  Future<SkillWaveResponse<CourseEntity>> call(String courseId) async {
    try {
      final course = await repository.getCourseById(courseId);
      return SkillWaveResponse.success(course);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
