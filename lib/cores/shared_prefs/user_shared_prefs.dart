import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillwave/cores/failure/failure.dart';

@lazySingleton
class UserSharedPrefs {
  final SharedPreferences _sharedPreferences;

  UserSharedPrefs(this._sharedPreferences);

  Future<Either<Failure, bool>> setUserToken(String token) async {
    try {
      await _sharedPreferences.setString('skillwave_token', token);
      return right(true);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getUserToken() async {
    try {
      final token = _sharedPreferences.getString("skillwave_token");
      return right(token);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserToken() async {
    try {
      await _sharedPreferences.remove('skillwave_token');
      return right(true);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setUserRole(String role) async {
    try {
      await _sharedPreferences.setString('role', role);
      return right(true);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getUserRole() async {
    try {
      final role = _sharedPreferences.getString('role');
      return right(role);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserRole() async {
    try {
      await _sharedPreferences.remove('role');
      return right(true);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setUserId(String id) async {
    try {
      await _sharedPreferences.setString('userId', id);
      return right(true);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getUserId() async {
    try {
      final id = _sharedPreferences.getString('userId');
      return right(id);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserId() async {
    try {
      await _sharedPreferences.remove('userId');
      return right(true);
    } catch (e) {
      return left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
