import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../../data/models/post_dto.dart';
import '../entity/post_entity.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class GetPostsUseCase {
  final DashboardRepository repository;

  GetPostsUseCase(this.repository);

  Future<SkillWaveResponse<PostsResponseEntity>> call(GetPostsDto dto) async {
    try {
      final posts = await repository.getPosts(dto);
      return SkillWaveResponse.success(posts);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
