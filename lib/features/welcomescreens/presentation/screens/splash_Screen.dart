import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes.dart';
import 'package:skillwave/features/auth/presentation/screens/login_view.dart';
import 'package:skillwave/features/welcomescreens/presentation/bloc/splashBloc/splash_bloc.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/onboarding_Screen.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingView()),
        );
      });
    }else if(state is SplashNavigateToLogin){
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginView()),
        );
      });

    }else if(state is SplashNavigateToHome){
      // after creating home screen navigate to home screen
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginView()),
        );
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: navigate,
      child: Scaffold(
        backgroundColor: SkillWaveAppColors.primary,
        body: Center(
          child: Image.asset(
            SkillWaveAppAssets.splash,
            width: 400.w,
            height: 400.h,
            fit: BoxFit.contain,
          )
              .animate() // Begin animation
              .fadeIn(duration: 1.5.seconds)
              .scale(duration: 1.5.seconds, curve: Curves.easeOutBack)
              .then(delay: 0.5.seconds)
              .shake(hz: 2, ),
        ),
      ),
    );
  }
}
