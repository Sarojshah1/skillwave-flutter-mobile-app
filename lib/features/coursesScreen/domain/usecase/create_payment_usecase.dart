import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart';

@lazySingleton
class CreatePaymentUseCase {
  final CourseRepository repository;

  CreatePaymentUseCase(this.repository);

  Future<SkillWaveResponse<bool>> call({
    required String courseId,
    required int amount,
    required String paymentMethod,
    required String status,
  }) async {
    try {
      final result = await repository.createPayment(
        courseId: courseId,
        amount: amount,
        paymentMethod: paymentMethod,
        status: status,
      );
      return SkillWaveResponse.success(result);
    } catch (e) {
      return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
    }
  }
}
