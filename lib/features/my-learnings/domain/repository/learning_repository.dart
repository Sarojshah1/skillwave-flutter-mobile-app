import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';

abstract class LearningRepository {
  Future<List<EnrollmentEntity>> getLearning();
  Future<List<LessonEntity>> getLessons(String courseId);
} 