import 'package:hive/hive.dart';
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

  Future<void> saveCredentials(String email, String password) async {
    final box = Hive.box(_userBoxName);
    await box.put('email', email);
    await box.put('password', password);
  }

  String? getPassword() {
    final box = Hive.box(_userBoxName);
    return box.get('password');
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final box = Hive.box(_userBoxName);
    await box.put('biometric_enabled', enabled);
  }

  bool isBiometricEnabled() {
    final box = Hive.box(_userBoxName);
    return box.get('biometric_enabled', defaultValue: false);
  }

  Map<String, dynamic>? getBiometricData() {
    final box = Hive.box(_userBoxName);
    final data = box.get('biometric_data');
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }
}
