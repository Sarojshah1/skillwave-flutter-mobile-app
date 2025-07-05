import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../entity/post_entity.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class GetPostByIdUseCase {
  final DashboardRepository repository;

  GetPostByIdUseCase(this.repository);

  Future<SkillWaveResponse<PostEntity>> call(String id) async {
    try {
      final post = await repository.getPostById(id);
      return SkillWaveResponse.success(post);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
