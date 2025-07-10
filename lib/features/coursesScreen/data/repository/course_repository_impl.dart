import 'package:injectable/injectable.dart';
import 'package:skillwave/features/coursesScreen/data/datasource/course_datasource.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart';

@LazySingleton(as: CourseRepository)
class CourseRepositoryImpl implements CourseRepository {
  final CourseDatasource datasource;

  CourseRepositoryImpl(this.datasource);

  @override
  Future<List<CourseEntity>> getCourses({required int page, required int limit}) {
    return datasource.getCourses(page: page, limit: limit);
  }

  @override
  Future<CourseEntity> getCourseById(String courseId) {
    return datasource.getCourseById(courseId);
  }

  @override
  Future<bool> createPayment({
    required String courseId,
    required int amount,
    required String paymentMethod,
    required String status,
  }) {
    return datasource.createPayment(
      courseId: courseId,
      amount: amount,
      paymentMethod: paymentMethod,
      status: status,
    );
  }

  @override
  Future<bool> createReview({
    required String courseId,
    required int rating,
    required String comment,
  }) {
    return datasource.createReview(
      courseId: courseId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<List<ReviewEntity>> getReviewsByCourseId(String courseId) {
    return datasource.getReviewsByCourseId(courseId);
  }
}
