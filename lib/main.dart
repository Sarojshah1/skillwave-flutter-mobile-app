import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'config/di/di.container.dart';
import 'config/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final appRouter = getIt<AppRouter>();
  runApp(
    ProviderScope(
      child: SkillWaveApp(appRouter: appRouter), // <-- pass it to app
    ),
  );
}

