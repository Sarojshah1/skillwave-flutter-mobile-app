import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/auth/data/models/login/login_model_params.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';

abstract class AuthRepository{
  Future<Either<ApiFailure, bool>> createUser(SignUpEntity user, File? profilePicture);
  Future<Either<ApiFailure, bool>> userLogin(LogInModel loginModel);
  Future<Either<ApiFailure,String>> sendOtp(String email);
  Future<Either<ApiFailure,String>> verifyOtp(String otp,String email);
  Future<Either<ApiFailure,String>> forgetPassword(String password,String email);
}