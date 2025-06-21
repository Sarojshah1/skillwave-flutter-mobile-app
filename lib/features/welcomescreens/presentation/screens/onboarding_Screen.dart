import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/cores/shared_prefs/app_shared_prefs.dart';
import 'package:skillwave/features/auth/presentation/screens/login_view.dart';

// Updated OnboardingCubit with dynamic last page index
class OnboardingCubit extends Cubit<int> {
  final int lastPageIndex;

  OnboardingCubit({required this.lastPageIndex}) : super(0);

  void nextPage() {
    if (state < lastPageIndex) {
      emit(state + 1);
    }
  }

  void skipOnboarding() {
    emit(lastPageIndex);
  }

  bool isLastPage() {
    return state == lastPageIndex;
  }
}

@RoutePage()
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final lastPageIndex = OnboardingScreen.onboardingData.length - 1;

    return BlocProvider(
      create: (_) => OnboardingCubit(lastPageIndex: lastPageIndex),
      child: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static final List<Map<String, String>> onboardingData = [
    {
      "image": SkillWaveAppAssets.onboarding1,
      "title": "Start Your Journey Today",
      "description":
          "Begin your educational adventure with SkillWave, where every lesson counts.",
    },
    {
      "image": SkillWaveAppAssets.onboarding2,
      "title": "Empower Your Education Journey",
      "description":
          "Strengthen your knowledge with interactive lessons designed for your success.",
    },
    {
      "image": SkillWaveAppAssets.onboarding3,
      "title": "Explore Endless Possibilities",
      "description":
          "Unlock new skills and potential with comprehensive quizzes and assessments.",
    },
    {
      "image": SkillWaveAppAssets.onboarding4,
      "title": "Step into a World of Learning Excellence",
      "description":
          "Achieve your goals with a personalized learning experience and progress tracking.",
    },
  ];

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    context.read<OnboardingCubit>().stream.listen((pageIndex) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  context.read<OnboardingCubit>().emit(index);
                },
                itemCount: OnboardingScreen.onboardingData.length,
                itemBuilder: (context, index) => OnboardingSlide(
                  image: OnboardingScreen.onboardingData[index]["image"]!,
                  title: OnboardingScreen.onboardingData[index]["title"]!,
                  description:
                      OnboardingScreen.onboardingData[index]["description"]!,
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: TextButton(
                  onPressed: () {
                    context.read<OnboardingCubit>().skipOnboarding();
                  },
                  child: Text(
                    "Skip",
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40.h,
                left: 20.w,
                right: 20.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        OnboardingScreen.onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 8.h,
                          width: currentPage == index ? 20.w : 8.w,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? theme.colorScheme.primary
                                : theme.disabledColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final cubit = context.read<OnboardingCubit>();
                        if (cubit.isLastPage()) {
                          final appSharedPrefs = GetIt.I<AppSharedPrefs>();
                          appSharedPrefs.setFirstTime(false);
                          context.router.replaceAll([const LoginRoute()]);
                        } else {
                          cubit.nextPage();
                        }
                      },
                      icon: Icon(
                        currentPage ==
                                OnboardingScreen.onboardingData.length - 1
                            ? Icons.arrow_forward_outlined
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: Text(
                        currentPage ==
                                OnboardingScreen.onboardingData.length - 1
                            ? "Continue"
                            : "Next",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
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

  const OnboardingSlide({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300.h, fit: BoxFit.contain),
          SizedBox(height: 30.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
