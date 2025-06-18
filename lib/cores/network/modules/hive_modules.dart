import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/hive_service.dart';

@module
abstract class HiveModule {
  @preResolve
  Future<HiveService> get hiveService async {
    final service = HiveService();
    await service.init();
    return service;
  }
}
