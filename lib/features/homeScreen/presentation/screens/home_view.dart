import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/homeScreen/presentation/constants/bottom_nav_items.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
          onTap: tabsRouter.setActiveIndex,
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
