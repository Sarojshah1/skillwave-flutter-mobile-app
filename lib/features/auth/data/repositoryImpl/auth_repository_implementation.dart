
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/auth/data/datasources/auth_remote_data_Source.dart';
import 'package:skillwave/features/auth/data/models/login/login_model_params.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/domian/repository/auth_repository.dart';

@LazySingleton(as:AuthRepository)
class IAuthRepository implements AuthRepository{
  final AuthRemoteDataSource dataSource;
  IAuthRepository({required this.dataSource});
  @override
  Future<Either<ApiFailure, bool>> createUser(SignUpEntity user, File? profilePicture) async{
    return await dataSource.createUser(user, profilePicture);
  }

  @override
  Future<Either<ApiFailure, bool>> userLogin(LogInModel loginModel) async{
    print("login repo");
    return await dataSource.userLogin(loginModel);
  }

  @override
  Future<Either<ApiFailure, String>> forgetPassword(String password, String email) async{
   return await dataSource.forgetPassword(password, email);
  }

  @override
  Future<Either<ApiFailure, String>> sendOtp(String email) async{
    return await dataSource.sendOtp(email);

  }

  @override
  Future<Either<ApiFailure, String>> verifyOtp(String otp, String email) async{

    return await dataSource.verifyOtp(otp, email);
  }

  @override
  Future<Either<ApiFailure, bool>> logout() async{
    return await dataSource.logout();
  }

}