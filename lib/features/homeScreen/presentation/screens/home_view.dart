import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/homeScreen/presentation/constants/bottom_nav_items.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final double _shakeThreshold = 55.0;
  DateTime? _lastShakeTime;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen(
      _onAccelerometerEvent,
    );
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final double acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    if (acceleration > _shakeThreshold && !_isDialogShowing) {
      _showExitDialog();
    }
  }

  void _showExitDialog() {
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 16,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                SkillWaveAppColors.primary.withOpacity(0.95),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: SkillWaveAppColors.primary.withOpacity(0.2),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/updated.json',
                width: 90,
                height: 90,
                repeat: false,
              ),
              SizedBox(height: 12),
              Text(
                'Exit App',
                style: TextStyle(
                  color: SkillWaveAppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Do you want to exit this app?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: SkillWaveAppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: SkillWaveAppColors.primary,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _isDialogShowing = false;
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SkillWaveAppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => _exitApp(),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exitApp() {
    Navigator.of(context).pop();
    _isDialogShowing = false;
    Future.delayed(Duration(milliseconds: 200), () {
      try {
        SystemNavigator.pop();
      } catch (_) {
        exit(0);
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      animationDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, child, animation) =>
          FadeTransition(opacity: animation, child: child),
      routes: const [
        DashboardRoute(),
        CoursesRoute(),
        BlogsRoute(),
        ProfileRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            if (index == 3) {
              context.read<ProfileBloc>().add(LoadUserProfile());
            }
            tabsRouter.setActiveIndex(index);
          },
          selectedItemColor: SkillWaveAppColors.primary,
          unselectedItemColor: SkillWaveAppColors.grey,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          items: BottomNavItems.items,
        );
      },
    );
  }
}
