import 'package:injectable/injectable.dart';
import 'package:skillwave/features/profileScreen/data/datasource/profile_remote_data_source.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/domin/repository/profile_repository.dart';

@LazySingleton(as:IProfileRepository)
class ProfileReposiotryImpl implements IProfileRepository{
  final ProfileRemoteDatasource datasource;
  ProfileReposiotryImpl(this.datasource);
  @override
  Future<UserEntity> getUserData() async{
    final response=await datasource.getUserData();
    return response;


  }

}