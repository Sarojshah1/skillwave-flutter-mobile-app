import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';

abstract interface class IProfileRepository{
  Future<UserEntity> getUserData();
}