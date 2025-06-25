import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/%20theme/dark_theme.dart';
import 'package:skillwave/config/themes/%20theme/light_theme.dart';
import 'package:skillwave/features/SettingScreen/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/blogScreen/presentation/bloc/blog_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/course_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/payment_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/review_bloc/review_bloc.dart';
import 'config/di/di.container.dart';
import 'config/routes/app_router.dart';
import 'config/themes/theme_bloc/theme_bloc.dart';
import 'cores/services/snackbar_service.dart';
import 'features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'features/welcomescreens/presentation/bloc/splashBloc/splash_bloc.dart';

class SkillWaveApp extends StatelessWidget {
  final AppRouter appRouter;
  const SkillWaveApp({super.key, required this.appRouter});

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
            BlocProvider(create: (_) => getIt<ThemeBloc>()..add(LoadTheme()), lazy: false),
            BlocProvider<SplashBloc>(
              create: (_) => getIt<SplashBloc>()..add(CheckAppStatusEvent()),
            ),
            BlocProvider<AuthBloc>(
              create: (_) => getIt<AuthBloc>()),
            BlocProvider<LogoutBloc>(
                create: (_) => getIt<LogoutBloc>()),
            BlocProvider<ProfileBloc>(
              create: (_) => getIt<ProfileBloc>(),
            ),
            BlocProvider<BlogBloc>(
              create: (_) => getIt<BlogBloc>(),
            ),
            BlocProvider<CourseBloc>(
              create: (_) => getIt<CourseBloc>(),
            ),  BlocProvider<ReviewBloc>(
              create: (_) => getIt<ReviewBloc>(),
            ),
             BlocProvider<PaymentBloc>(
              create: (_) => getIt<PaymentBloc>(),
            ),


          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context,themeState){
            return MaterialApp.router(
              title: 'SkillWave App',
              routerConfig: appRouter.config(),
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeState.themeMode,
              scaffoldMessengerKey: snackbarService.messengerKey,
              debugShowCheckedModeBanner: false,
            );
          }),
        );
      },
    );
  }
}
