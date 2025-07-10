import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import '../../data/models/post_dto.dart';
import '../repository/dashboard_repository.dart';

@lazySingleton
class CreatePostUseCase {
  final DashboardRepository repository;

  CreatePostUseCase(this.repository);

  Future<SkillWaveResponse<String>> call(
    CreatePostDto dto, {
    List<File>? images,
  }) async {
    try {
      final post = await repository.createPost(dto, images: images);
      return SkillWaveResponse.success("post created successfully");
    } catch (e) {
      if (e is Failure) {
        return SkillWaveResponse.failure(e);
      } else {
        return SkillWaveResponse.failure(ApiFailure(message: e.toString()));
      }
    }
  }
}
