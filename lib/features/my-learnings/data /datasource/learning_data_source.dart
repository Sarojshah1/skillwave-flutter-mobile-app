import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/coursesScreen/data/model/course_model.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/my-learnings/data%20/model/enrollment_model.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';

@LazySingleton()
class LearningDataSource {
  final Dio dio;
  LearningDataSource(this.dio);
  Future<List<EnrollmentEntity>> getLearning() async {
    try{
      final response = await dio.get(ApiEndpoints.getLearnings);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EnrollmentModel.fromJson(json).toEntity()).toList();
      } else {
        throw Exception('Failed to load learnings. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  Future<List<LessonEntity>> getLessons(String courseId) async {
    try {
      final response = await dio.get(ApiEndpoints.getLessonsByCourseId(courseId));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LessonModel.fromJson(json).toEntity()).toList();
      } else {
        throw Exception('Failed to load lessons. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
