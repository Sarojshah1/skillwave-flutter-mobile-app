
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/profileScreen/data/models/user_model.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';

@LazySingleton()
class ProfileRemoteDatasource{
  final Dio dio;

  ProfileRemoteDatasource({
    required this.dio,
  });

Future<UserEntity> getUserData()async{
  try{
    final response=await dio.get(ApiEndpoints.profile);
    print(response.data);
    final userModel = UserModel.fromJson(response.data);
    return userModel.toEntity();


  }on DioException catch(e){
    throw Exception(e.toString());
  }

}

}