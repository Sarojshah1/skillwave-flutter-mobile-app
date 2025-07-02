import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/cores/network/dio_interseptors.dart';
import 'package:local_auth/local_auth.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}
class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final available = await _auth.canCheckBiometrics;
      if (!available) {
        print('Biometrics not available');
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Authenticate to log in with your fingerprint/face',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true, // 🔥 IMPORTANT
        ),
      );
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }
}
