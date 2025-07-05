import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../../data/models/post_dto.dart';
import '../entity/post_entity.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class UpdatePostUseCase {
  final DashboardRepository repository;

  UpdatePostUseCase(this.repository);

  Future<SkillWaveResponse<PostEntity>> call(
    String id,
    UpdatePostDto dto,
  ) async {
    try {
      final post = await repository.updatePost(id, dto);
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
