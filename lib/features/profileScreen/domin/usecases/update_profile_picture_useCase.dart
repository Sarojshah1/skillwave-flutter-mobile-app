import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/repository/profile_repository.dart';

@lazySingleton
class UpdateProfilePictureUseCase {
  final IProfileRepository repository;

  UpdateProfilePictureUseCase(this.repository);

  Future<SkillWaveResponse<void>> call(File imageFile) async {
    try {
      print("usecase");
      await repository.updateProfilePicture(imageFile);
      return SkillWaveResponse.success(null);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
