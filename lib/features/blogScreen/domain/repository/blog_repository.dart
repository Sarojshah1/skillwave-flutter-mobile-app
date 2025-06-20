import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';

abstract class BlogRepository {
  Future<List<BlogEntity>> getBlogs({required int page, required int limit});
}