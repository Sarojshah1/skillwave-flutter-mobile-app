import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/repository/profile_repository.dart';

@lazySingleton
class ChangePasswordUseCase {
  final IProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<SkillWaveResponse<void>> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return SkillWaveResponse.success(null);
    } catch (e) {
      if (e is ApiFailure) {
        // Check if it's a network connection error
        if (e.message.contains('No internet connection') || 
            e.message.contains('network') ||
            e.message.contains('connection')) {
          return SkillWaveResponse.failure(
            ApiFailure(message: 'No internet connection. Please check your network.'),
          );
        }
        return SkillWaveResponse.failure(e);
      }
      return SkillWaveResponse.failure(
        ApiFailure(message: 'Failed to change password. Please try again.'),
      );
    }
  }
}
