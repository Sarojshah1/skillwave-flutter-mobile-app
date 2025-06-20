import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/blogScreen/data/model/blog_model.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';

@LazySingleton()
class BlogDatasource {
  final Dio dio;

  BlogDatasource(this.dio);

  Future<List<BlogEntity>> getBlogs({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getBlogs,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      print(response);

      if (response.statusCode == 200) {
        // final data = response.data;
        final List<dynamic> data = response.data;

        return data
            .map((json) => BlogModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception('Failed to load blogs. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
