import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/my-learnings/domain/repository/learning_repository.dart';

@lazySingleton
class GetLessonsUsecase {
  final LearningRepository repository;
  GetLessonsUsecase(this.repository);
  Future<SkillWaveResponse<List<LessonEntity>>> call(String courseId) async {
    try{
      final lessons = await repository.getLessons(courseId);
      return SkillWaveResponse.success(lessons);
    } catch (e) {
       if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}