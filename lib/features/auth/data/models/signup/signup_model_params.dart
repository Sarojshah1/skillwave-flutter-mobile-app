
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';


part 'signup_model_params.freezed.dart';
part 'signup_model_params.g.dart';

@freezed
class SignUpModel with _$SignUpModel {
  const factory SignUpModel({
    required String name,
    required String email,
    required String password,
    required String role,
    required String bio,
  }) = _SignUpModel;


  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);
}
extension SignUpModelMapper on SignUpModel {
  SignUpEntity toEntity() {
    return SignUpEntity(
      name: name,
      email: email,
      password: password,
      role: role,
      bio: bio,
    );
  }
}

