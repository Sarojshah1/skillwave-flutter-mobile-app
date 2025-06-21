
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/features/blogScreen/domain/repository/blog_repository.dart';

@lazySingleton
class GetBlogsUseCase {
  final BlogRepository repository;

  GetBlogsUseCase(this.repository);

  Future<SkillWaveResponse<List<BlogEntity>>> call({
    required int page,
    required int limit,
  }) async {
    try {
      final blogs = await repository.getBlogs(page: page, limit: limit);
      return SkillWaveResponse.success(blogs);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}