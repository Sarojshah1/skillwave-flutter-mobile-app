import 'package:injectable/injectable.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/my-learnings/data%20/datasource/learning_data_source.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';
import 'package:skillwave/features/my-learnings/domain/repository/learning_repository.dart';

@LazySingleton(as: LearningRepository)
class LearningRepositoryImpl implements LearningRepository{
  final LearningDataSource dataSource;
  LearningRepositoryImpl(this.dataSource);
  @override
  Future<List<EnrollmentEntity>> getLearning() async {
    return await dataSource.getLearning();
  }

  @override
  Future<List<LessonEntity>> getLessons(String courseId) async{
   return await dataSource.getLessons(courseId);
  }
  
}