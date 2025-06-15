import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'auth_interceptor.dart';
import 'dio_interseptors.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor, DioErrorInterceptor errorInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: "application/json",
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      errorInterceptor,
    ]);

    return dio;
  }
}
