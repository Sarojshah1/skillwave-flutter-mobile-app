import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/splash_Screen.dart';

import 'config/di/di.container.dart';
import 'cores/services/snackbar_service.dart';
import 'features/welcomescreens/presentation/bloc/splashBloc/splash_bloc.dart';

class SkillWaveApp extends StatelessWidget {
  const SkillWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final snackbarService = getIt<SnackbarService>();
    final navKey = getIt<GlobalKey<NavigatorState>>();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;
        return MultiBlocProvider(
          providers: [
            BlocProvider<SplashBloc>(
              create: (_) => getIt<SplashBloc>()..add(CheckAppStatusEvent()),
            ),
            BlocProvider<AuthBloc>(
              create: (_) => getIt<AuthBloc>()),

          ],
          child: MaterialApp(
            title: 'SkillWave App',

            navigatorKey: navKey,
            scaffoldMessengerKey: snackbarService.messengerKey,
            debugShowCheckedModeBanner: false,
            home: SplashView(),

          ),
        );
      },
    );;
  }
}
