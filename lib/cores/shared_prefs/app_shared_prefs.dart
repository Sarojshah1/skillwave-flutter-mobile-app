import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillwave/cores/failure/failure.dart';

@lazySingleton
class AppSharedPrefs {
  final SharedPreferences _sharedPreferences;

  AppSharedPrefs(this._sharedPreferences);

  Future<Either<Failure, void>> setFirstTime(bool time) async {
    try {
      await _sharedPreferences.setBool('FirstTime', time);
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool?>> getFirstTime() async {
    try {
      final firstTime = _sharedPreferences.getBool('FirstTime');
      return Right(firstTime);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> initializeFirstTime() async {
    try {
      if (!_sharedPreferences.containsKey('FirstTime')) {
        await _sharedPreferences.setBool('FirstTime', true);
      }
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteFirstTime() async {
    try {
      await _sharedPreferences.remove('FirstTime');
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> setDarkMode(bool mode) async {
    try {
      await _sharedPreferences.setBool('DarkMode', mode);
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool?>> getDarkMode() async {
    try {
      final darkMode = _sharedPreferences.getBool('DarkMode');
      return Right(darkMode);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteDarkMode() async {
    try {
      await _sharedPreferences.remove('DarkMode');
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
