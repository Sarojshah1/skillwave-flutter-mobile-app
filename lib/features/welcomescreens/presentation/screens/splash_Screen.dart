import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/auth/presentation/screens/login_view.dart';
import 'package:skillwave/features/homeScreen/presentation/screens/home_view.dart';
import 'package:skillwave/features/welcomescreens/presentation/bloc/splashBloc/splash_bloc.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/onboarding_Screen.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(CheckAppStatusEvent());
  }

  void navigate(BuildContext context, SplashState state) {
    if (state is SplashNavigateToOnboarding) {
      Future.delayed(const Duration(seconds: 3), () {
        context.replaceRoute(const OnboardingRoute());
      });
    }else if(state is SplashNavigateToLogin){
      Future.delayed(const Duration(seconds: 3), () {
        context.replaceRoute(const LoginRoute());

      });

    }else if(state is SplashNavigateToHome){
      Future.delayed(const Duration(seconds: 3), () {
        context.replaceRoute(const HomeRoute());
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: navigate,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: SkillWaveAppColors.primary,
          body: Center(
            child: Image.asset(
              SkillWaveAppAssets.splash,
              width: 400.w,
              height: 400.h,
              fit: BoxFit.contain,
            )
                .animate()
                .fadeIn(duration: 1.5.seconds)
                .scale(duration: 1.5.seconds, curve: Curves.easeOutBack)
                .then(delay: 0.5.seconds)
                .shake(hz: 2, ),
          ),
        ),
      ),
    );
  }
}
