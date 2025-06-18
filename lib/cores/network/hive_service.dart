import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _userBoxName = 'userBox';

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.openBox(_userBoxName);
  }

  Future<void> saveLogin(String token) async {
    final box = Hive.box(_userBoxName);
    await box.put('token', token);
    // await box.put('email', email);
  }

  String? getToken() {
    final box = Hive.box(_userBoxName);
    return box.get('token');
  }

  String? getEmail() {
    final box = Hive.box(_userBoxName);
    return box.get('email');
  }

  Future<void> clearUser() async {
    final box = Hive.box(_userBoxName);
    await box.clear();
  }

  bool isLoggedIn() {
    final box = Hive.box(_userBoxName);
    return box.get('token') != null;
  }
}
