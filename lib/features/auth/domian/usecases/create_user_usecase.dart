import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/domian/repository/auth_repository.dart';

@lazySingleton
class CreateUserUseCase {
  final AuthRepository _repository;
  const CreateUserUseCase(this._repository);

  Future<SkillWaveResponse<bool>> call(
    SignUpEntity user,
    File? profilePicture,
  ) async {
    try {
      final result = await _repository.createUser(user, profilePicture);
      return result.fold(
        (failure) => SkillWaveResponse.failure(failure),
        (success) => SkillWaveResponse.success(success),
      );
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
