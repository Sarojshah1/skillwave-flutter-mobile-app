import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes.dart';
import 'package:skillwave/cores/shared_prefs/app_shared_prefs.dart';
import 'package:skillwave/features/welcomescreens/presentation/bloc/obBoardingBloc/onboarding_cubit.dart';


class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<OnboardingCubit>(),
      child: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
   OnboardingScreen({super.key});

  final List<Map<String, String>> onboardingData = [
    {
      "image": SkillWaveAppAssets.onboarding1,
      "title": "Start Your Journey Today",
      "description": "Begin your educational adventure with SkillWave, where every lesson counts."
    },
    {
      "image":  SkillWaveAppAssets.onboarding2,
      "title": "Empower Your Education Journey",
      "description": "Strengthen your knowledge with interactive lessons designed for your success."
    },
    {
      "image":  SkillWaveAppAssets.onboarding3,
      "title": "Explore Endless Possibilities",
      "description": "Unlock new skills and potential with comprehensive quizzes and assessments."
    },
    {
      "image":  SkillWaveAppAssets.onboarding4,
      "title": "Step into a World of Learning Excellence",
      "description": "Achieve your goals with a personalized learning experience and progress tracking."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                onPageChanged: (index) {
                  context.read<OnboardingCubit>().emit(index);
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardingSlide(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              Positioned(
                top: screenHeight * 0.05,
                right: screenWidth * 0.05,
                child: TextButton(
                  onPressed: () {
                    context.read<OnboardingCubit>().skipOnboarding();
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        onboardingData.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          height: 8,
                          width: currentPage == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? SkillWaveAppColors.primary
                                : SkillWaveAppColors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (context.read<OnboardingCubit>().isLastPage()) {
                          // Set first-time user to false
                          final appSharedPrefs = GetIt.I<AppSharedPrefs>();
                          appSharedPrefs.setFirstTime(false);

                          // Navigate to login screen
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => LoginView()),
                          // );
                        } else {
                          context.read<OnboardingCubit>().nextPage();
                        }
                      },
                      label: Text(
                        currentPage == onboardingData.length - 1
                            ? "Continue"
                            : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(
                        currentPage == onboardingData.length - 1
                            ? Icons.arrow_forward_outlined
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SkillWaveAppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double screenWidth;
  final double screenHeight;

  const OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    double imageHeight = screenHeight * 0.4;
    if (screenWidth > 600) {
      imageHeight = screenHeight * 0.5;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: screenHeight * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenHeight * 0.04),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth > 600
                  ? screenWidth * 0.05
                  : screenWidth * 0.045,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
