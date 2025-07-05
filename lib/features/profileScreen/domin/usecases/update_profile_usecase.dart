import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/repository/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<SkillWaveResponse<void>> call({
    required String name,
    required String email,
    required String bio,
  }) async {
    try {
      await repository.updateProfile(name: name, email: email, bio: bio);
      return SkillWaveResponse.success(null);
    } catch (e) {
      if (e is ApiFailure) {
        // Check if it's a network connection error
        if (e.message.contains('No internet connection') ||
            e.message.contains('network') ||
            e.message.contains('connection')) {
          return SkillWaveResponse.failure(
            ApiFailure(
              message: 'No internet connection. Please check your network.',
            ),
          );
        }
        return SkillWaveResponse.failure(e);
      }
      return SkillWaveResponse.failure(
        ApiFailure(message: 'Failed to update profile. Please try again.'),
      );
    }
  }
}
