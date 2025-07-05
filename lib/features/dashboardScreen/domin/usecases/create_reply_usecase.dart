import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../../data/models/post_dto.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class CreateReplyUseCase {
  final DashboardRepository repository;

  CreateReplyUseCase(this.repository);

  Future<SkillWaveResponse<void>> call(
    String postId,
    String commentId,
    CreateReplyDto dto,
  ) async {
    try {
      await repository.createReply(postId, commentId, dto);
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
