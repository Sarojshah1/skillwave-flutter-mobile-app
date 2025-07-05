import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class LikePostUseCase {
  final DashboardRepository repository;

  LikePostUseCase(this.repository);

  Future<SkillWaveResponse<void>> call(String postId) async {
    try {
      await repository.likePost(postId);
      return SkillWaveResponse.success(null);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
