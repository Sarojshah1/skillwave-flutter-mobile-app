import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';

abstract class CourseRepository {
  Future<List<CourseEntity>> getCourses({required int page, required int limit});
  Future<CourseEntity> getCourseById(String courseId);
  Future<bool> createPayment({
    required String courseId,
    required int amount,
    required String paymentMethod,
    required String status,
  });
  Future<bool> createReview({
    required String courseId,
    required int rating,
    required String comment,
  });

  Future<List<ReviewEntity>> getReviewsByCourseId(String courseId);
}
