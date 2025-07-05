import 'dart:io';

import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';

abstract interface class IProfileRepository {
  Future<UserEntity> getUserData();
  Future<void> updateProfilePicture(File imageFile);
  Future<void> updateProfile({
    required String name,
    required String email,
    required String bio,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
