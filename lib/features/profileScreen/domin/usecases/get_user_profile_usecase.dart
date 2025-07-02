import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/domin/repository/profile_repository.dart';

@lazySingleton
class GetUserProfileUseCase {
  final IProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<SkillWaveResponse<UserEntity>> call() async {
    try {
      final user = await repository.getUserData();
      return SkillWaveResponse.success(user);
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
