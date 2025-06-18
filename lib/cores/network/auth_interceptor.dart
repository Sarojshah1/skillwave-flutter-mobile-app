import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final UserSharedPrefs _userPrefs;

  AuthInterceptor(this._userPrefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final tokenResult = await _userPrefs.getUserToken();

    tokenResult.fold(
          (failure) {
        handler.next(options);
      },
          (token) {
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }
}
