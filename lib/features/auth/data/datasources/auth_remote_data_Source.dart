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
      print('Login Request: ${loginModel.toJson()}');

      final response = await dio.post(
        ApiEndpoints.login,
        data: loginModel.toJson(),
      );

      print('Login Response: ${response.statusMessage}');
      print("hello from auth datasource");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // Validate response structure
        if (data.containsKey('token') && data.containsKey('role') && data.containsKey('id')) {
          final token = data['token'];
          final role = data['role'];
          final id = data['id'];

          await userSharedPrefs.setUserToken(token);
          await userSharedPrefs.setUserRole(role);
          await userSharedPrefs.setUserId(id);

          return const Right(true);
        } else {
          print( "Login failed: ${response.statusCode ?? 'Unknown error'}");
          return const Left(ApiFailure(message: "Missing fields in response"));
        }
      } else {
        print( "Login failed: ${response.statusCode ?? 'Unknown error'}");
        return Left(ApiFailure(
          message: "Login failed: ${response.statusMessage ?? 'Unknown error'}",
        ));
      }
    } on DioException catch (e) {
      print( "Login failed: ${e.response!.data}");
      return Left(ApiFailure(message: e.response!.data['message']));
    } catch (e) {
      return Left(ApiFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<Either<ApiFailure,String>> sendOtp(String email)async{
    try{
      print("sendotp data source");
      Response response=await dio.post(ApiEndpoints.sendOtp,data: {'email':email});
      print(response);
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

  Future<Either<ApiFailure, bool>> logout() async {
    try {
      final deleteToken = await userSharedPrefs.deleteUserToken();
      final deleteRole = await userSharedPrefs.deleteUserRole();
      final deleteId = await userSharedPrefs.deleteUserId();

      if (deleteToken.isRight() && deleteRole.isRight() && deleteId.isRight()) {
        return const Right(true);
      } else {
        return const Left(ApiFailure(message: "Failed to clear user session"));
      }
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }


}
