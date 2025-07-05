import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class DeletePostUseCase {
  final DashboardRepository repository;

  DeletePostUseCase(this.repository);

  Future<SkillWaveResponse<void>> call(String id) async {
    try {
      await repository.deletePost(id);
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
