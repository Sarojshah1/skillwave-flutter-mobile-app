import 'package:flutter/material.dart';

import 'app.dart';
import 'config/di/di.container.dart';
import 'config/routes/app_router.dart';
import 'cores/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final appRouter = getIt<AppRouter>();
  final hiveService = HiveService();
  await hiveService.init();
  runApp(
    SkillWaveApp(appRouter: appRouter),
  );
}

