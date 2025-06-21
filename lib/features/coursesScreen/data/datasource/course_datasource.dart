import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/coursesScreen/data/model/course_model.dart';
import 'package:skillwave/features/coursesScreen/data/model/review_model.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';

@LazySingleton()
class CourseDatasource {
  final Dio dio;

  CourseDatasource(this.dio);

  Future<List<CourseEntity>> getCourses({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getCourses,
        queryParameters: {'page': page, 'limit': limit},
      );
      print(response.data['courses']);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['courses'];

        return data
            .map((json) => CourseModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to load courses. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print(e.toString());
      throw Exception('Unexpected error: $e');
    }
  }

  Future<bool> createPayment({
    required String courseId,
    required int amount,
    required String paymentMethod,
    required String status,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.payment,
        data: {
          'course_id': courseId,
          'amount': amount,
          'payment_method': paymentMethod,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to create payment. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Payment error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<CourseEntity> getCourseById(String courseId) async {
    try {
      final response = await dio.get(ApiEndpoints.getCourseUrl(courseId));

      if (response.statusCode == 200) {
        final courseModel = CourseModel.fromJson(response.data);
        return courseModel.toEntity();
      } else {
        throw Exception(
          'Failed to load course by ID. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Fetch error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<bool> createReview({
    required String courseId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.addReviews,
        data: {'course_id': courseId, 'rating': rating, 'comment': comment},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
          'Failed to create review. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Create review error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<ReviewEntity>> getReviewsByCourseId(String courseId) async {
    try {
      final response = await dio.get(ApiEndpoints.getReviewUrl(courseId));

      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      // Accept 200 and 404 with empty reviews
      if (response.statusCode == 200 || response.statusCode == 404) {
        final data = response.data;

        if (data == null || data is! List) {
          final reviewList = data['reviews'];
          if (reviewList == null || reviewList is! List) return [];
          return reviewList
              .map((json) => ReviewModel.fromJson(json).toEntity())
              .toList();
        }
        return data
            .map((json) => ReviewModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to load reviews. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioException occurred: ${e.message}');
      print('Type: ${e.type}');
      print('Status Code: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Request: ${e.requestOptions}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }


}
