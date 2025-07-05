import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:skillwave/features/profileScreen/data/datasource/profile_remote_data_source.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/domin/repository/profile_repository.dart';

@LazySingleton(as: IProfileRepository)
class ProfileReposiotryImpl implements IProfileRepository {
  final ProfileRemoteDatasource datasource;
  ProfileReposiotryImpl(this.datasource);
  @override
  Future<UserEntity> getUserData() async {
    final response = await datasource.getUserData();
    return response;
  }

  @override
  Future<void> updateProfilePicture(File imageFile) async {
    return await datasource.updateProfilePicture(imageFile);
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    required String bio,
  }) async {
    return await datasource.updateProfile(name: name, email: email, bio: bio);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await datasource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
