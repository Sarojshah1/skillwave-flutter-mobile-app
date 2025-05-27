import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
// Feature screens
import 'package:skillwave/features/auth/presentation/screens/login_view.dart';
import 'package:skillwave/features/auth/presentation/screens/reset_password_Screen.dart';
import 'package:skillwave/features/auth/presentation/screens/send_otp_screen.dart';
import 'package:skillwave/features/auth/presentation/screens/signup_view.dart';
import 'package:skillwave/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:skillwave/features/homeScreen/presentation/screens/home_view.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/onboarding_Screen.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/splash_Screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page|View,Route')
@lazySingleton
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // initial route
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    // auth routes
    AutoRoute(page: LoginRoute.page,),
    AutoRoute(page: SignupRoute.page,),
    AutoRoute(page: ResetPasswordRoute.page,),
    AutoRoute(page: SendOtpRoute.page,),
    AutoRoute(page: VerifyOtpRoute.page,),
    // dashboard routes
    AutoRoute(page: HomeRoute.page),
  ];
}
