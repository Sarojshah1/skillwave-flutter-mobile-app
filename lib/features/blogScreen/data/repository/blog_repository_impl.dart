import 'package:injectable/injectable.dart';
import 'package:skillwave/features/blogScreen/data/datasources/blog_datasource.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/features/blogScreen/domain/repository/blog_repository.dart';

@LazySingleton(as: BlogRepository)
class BlogRepositoryImpl implements BlogRepository {
  final BlogDatasource _blogDatasource;

  BlogRepositoryImpl(this._blogDatasource);

  @override
  Future<List<BlogEntity>> getBlogs({required int page, required int limit}) async {
    try {
      return await _blogDatasource.getBlogs(page: page, limit: limit);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}