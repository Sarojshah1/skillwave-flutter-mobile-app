import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/profileScreen/data/models/user_model.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/cores/failure/failure.dart';

@LazySingleton()
class ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasource({required this.dio});

  Future<UserEntity> getUserData() async {
    try {
      final response = await dio.get(ApiEndpoints.profile);
      print(response.data);
      final userModel = UserModel.fromJson(response.data);
      return userModel.toEntity();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.error is SocketException) {
        throw ApiFailure(
          message: 'No internet connection. Please check your network.',
        );
      } else if (e.response != null) {
        throw ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch profile',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiFailure(message: 'Failed to fetch profile: ${e.message}');
      }
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      await dio.put(
        ApiEndpoints.updateProfilePicture,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update profile picture: ${e.toString()}');
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String bio,
  }) async {
    try {
      await dio.put(
        ApiEndpoints.updateDetails,
        data: {'name': name, 'email': email, 'bio': bio},
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.error is SocketException) {
        throw ApiFailure(
          message: 'No internet connection. Please check your network.',
        );
      } else if (e.response != null) {
        throw ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update profile',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiFailure(message: 'Failed to update profile: ${e.message}');
      }
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await dio.put(
        ApiEndpoints.changePassword,
        data: {
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.error is SocketException) {
        throw ApiFailure(
          message: 'No internet connection. Please check your network.',
        );
      } else if (e.response != null) {
        throw ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to change password',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiFailure(message: 'Failed to change password: ${e.message}');
      }
    }
  }
}
