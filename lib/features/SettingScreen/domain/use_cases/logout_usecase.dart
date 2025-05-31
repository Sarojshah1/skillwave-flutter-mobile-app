
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/auth/domian/repository/auth_repository.dart';

@lazySingleton
final class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<SkillWaveResponse<bool>> call() async {
    try {
      final result = await _repository.logout();
      print(result);
      return result.fold(
            (failure) => SkillWaveResponse.failure(failure),
            (success) => SkillWaveResponse.success(success),
      );
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
