import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';
import 'package:skillwave/features/auth/domian/repository/auth_repository.dart';
import 'package:skillwave/features/auth/data/models/login/login_model_params.dart';

@lazySingleton
final class LogInUseCase {
  final AuthRepository _repository;
  LogInUseCase(this._repository);

  Future<SkillWaveResponse<bool>> call(LogInEntity entity) async {
    try {
      print("login usecase");
      final model = LogInModel(
        email: entity.email,
        password: entity.password,
      );

      final result = await _repository.userLogin(model);

      return result.fold(
            (failure){
              print(failure);
             return SkillWaveResponse.failure(failure);
            },
            (success) => SkillWaveResponse.success(success),
      );
    } catch (e) {
      print(e.toString());
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
