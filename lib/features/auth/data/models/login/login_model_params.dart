import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';


part 'login_model_params.freezed.dart';
part 'login_model_params.g.dart';

@freezed
class LogInModel with _$LogInModel {
  const factory LogInModel({
    required String email,
    required String password,
  }) = _LogInModel;

  factory LogInModel.fromJson(Map<String, dynamic> json) => _$LogInModelFromJson(json);
}
extension LogInModelMapper on LogInModel {
  LogInEntity toEntity() {
    return LogInEntity(
      email: email,
      password: password,
    );
  }
}
