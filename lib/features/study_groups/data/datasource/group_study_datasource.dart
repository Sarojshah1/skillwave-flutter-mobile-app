import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/study_groups/data/model/group_model.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';

@LazySingleton()
class GroupStudyDatasource {
  final Dio dio;

  GroupStudyDatasource(this.dio);

  Future<GroupEntity> createGroup({
    required String groupName,
    required File groupImage,
    required String description,
  }) async {
    try {
      final formData = FormData.fromMap({
        'group_name': groupName,
        'group_image': await MultipartFile.fromFile(
          groupImage.path,
          filename: groupImage.uri.pathSegments.last,
        ),
        'description': description,
      });
      final response = await dio.post(ApiEndpoints.createGroup, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GroupModel.fromJson(response.data).toEntity();
      } else {
        throw Exception(
          'Failed to create group. Status code: \\${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: \\${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<GroupEntity>> getAllGroups() async {
    try {
      final response = await dio.get(ApiEndpoints.getAllGroups);
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => GroupModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to load groups. Status code: \\${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: \\${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<GroupEntity>> getUserGroups() async {
    try {
      final response = await dio.get(ApiEndpoints.getUserGroupsUrl());
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => GroupModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to load user groups. Status code: \\${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: \\${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
