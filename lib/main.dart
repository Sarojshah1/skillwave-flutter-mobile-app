import 'package:flutter/material.dart';

import 'app.dart';
import 'config/di/di.container.dart';
import 'config/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final appRouter = getIt<AppRouter>();
  runApp(
    SkillWaveApp(appRouter: appRouter),
  );
}

