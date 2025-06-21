import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/auth/domian/repository/auth_repository.dart';

@lazySingleton
class VerifyOtpUseCase {
  final AuthRepository _repository;
  VerifyOtpUseCase(this._repository);

  Future<SkillWaveResponse<String>> call(String otp, String email) async {
    try {
      final result = await _repository.verifyOtp(otp, email);
      return result.fold(
        (failure) => SkillWaveResponse.failure(failure),
        (message) => SkillWaveResponse.success(message),
      );
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
