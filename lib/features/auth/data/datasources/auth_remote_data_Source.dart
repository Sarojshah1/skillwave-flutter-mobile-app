import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';
import 'package:skillwave/features/auth/data/models/login/login_model_params.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';


@LazySingleton()
class AuthRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({
    required this.dio,
    required this.userSharedPrefs,
  });

  Future<Either<ApiFailure, bool>> createUser(SignUpEntity user, File? profilePicture) async {
    try {
      final formData = FormData.fromMap({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'role': user.role,
        'bio': user.bio ?? '',
        if (profilePicture != null)
          'profile_picture': await MultipartFile.fromFile(
            profilePicture.path,
            filename: profilePicture.uri.pathSegments.last,
          ),
      });

      final response = await dio.post(
        ApiEndpoints.register,
        data: formData,
      );

      if (response.statusCode == 201) {
        return Right(true);
      }

      return Left(
        ApiFailure(
          statusCode: response.statusCode, message: response.data['message'] ?? 'Failed to create user',
        ),
      );
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message.toString()));
    }
  }

  Future<Either<ApiFailure, bool>> userLogin(LogInModel loginModel) async {
    try {
      print(loginModel.toJson());
      final response = await dio.post(
        ApiEndpoints.login,
        data: loginModel.toJson(),
      );
      print(response);
      print("hello from auth datasource");
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final role = response.data['role'];
        final id = response.data['id'];
        await userSharedPrefs.setUserToken(token);
        await userSharedPrefs.setUserRole(role);
        await userSharedPrefs.setUserId(id);
      }

      return const Right(true);
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message.toString()));
    }
  }
  Future<Either<ApiFailure,String>> sendOtp(String email)async{
    try{
      Response response=await dio.post(ApiEndpoints.sendOtp,data: {'email':email});
      if(response.statusCode==200){

        String message=response.data;
        return right(message);

      }else{
        return left(ApiFailure(message: "failed to send otp please try again"));
      }

    }on DioException catch(e){
      return left(ApiFailure(message: e.error.toString()));
    }
  }
  Future<Either<ApiFailure,String>> verifyOtp(String otp,String email)async{
    try{
      Response response=await dio.post(ApiEndpoints.verifyOtp,data: {'email':email,'otp':otp});
      if(response.statusCode==200){
        String message=response.data['message'];
        return right(message);

      }else{
        return left(ApiFailure(message: "failed to verify otp please try again"));
      }

    }on DioException catch(e){
      return left(ApiFailure(message: e.error.toString()));
    }
  }
  Future<Either<ApiFailure,String>> forgetPassword(String password,String email)async{
    try{
      Response response=await dio.put(ApiEndpoints.ForgetPassword,data: {'email':email,'newPassword':password});
      print(response.data);
      print(response.statusCode);
      if(response.statusCode==200){
        String message=response.data['message'];
        return right(message);

      }else{
        return left(ApiFailure(message: "failed to update password please try again"));
      }

    }on DioException catch(e){
      return left(ApiFailure(message: e.error.toString()));
    }
  }

}
